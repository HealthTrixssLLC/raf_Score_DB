 
Create         procedure [dbo].[sp_RS_Medicare_PartC_CMSHCC_Inner](@PmtYear as int, @Membership as [Validated_InputMembership_PartC] READONLY, @DxTable as [InputDiagnosis_Inner] READONLY, @ClinicalVersion VARCHAR(20),@EngineType INT = 1 )
as
 

declare @Dosyear as int=@PmtYear-1
Declare @Model as VARCHAR(200)
---------------------------------------------------------------------------------------------
--Prepare Lookups
---------------------------------------------------------------------------------------------
--ICD Mapping
drop table if exists #lookup_ICDMapping
select * 
into 
	#lookup_ICDMapping 
 
from 
	 [dbo].[vw_ref_Medicare_PartC_ICD_Category_Mapping] 
where 
	PmtYear=@PmtYear and ClinicalVersion=@ClinicalVersion
---------------------------------------------------------------------------------------------
--demographic factor lookup table
drop table if exists #lookup_vw_ref_Medicare_PartC_Demographic_Factor 
--
select * 
into 
	#lookup_vw_ref_Medicare_PartC_Demographic_Factor
from 
	 [dbo].[vw_ref_Medicare_PartC_Demographic_Factor]
where 1=1 
AND
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear

 --select * from #lookup_vw_ref_Medicare_PartC_Demographic_Factor
---------------------------------------------------------------------------------------------
--demographic status factor lookup table
drop table if exists #lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor
--
select * 
into 
	#lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor
from 
	 [dbo].vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor
where 1=1
AND
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear
	--select * from #lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor
---------------------------------------------------------------------------------------------
--disease factor
drop table if exists #lookup_vw_ref_Medicare_PartC_Disease_Factor
--
select * 
into
	#lookup_vw_ref_Medicare_PartC_Disease_Factor

FROM 
	[dbo].[vw_ref_Medicare_PartC_Disease_Factor]
where 1=1
AND 
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 
---------------------------------------------------------------------------------------------
--disease count factor
drop table if exists #lookup_vw_ref_Medicare_PartC_Disease_Count_Factor
--
select * 
into
	#lookup_vw_ref_Medicare_PartC_Disease_Count_Factor
FROM 
	[dbo].[vw_ref_Medicare_PartC_Disease_Count_Factor]
where 1=1
AND
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 
---------------------------------------------------------------------------------------------
--disease group mapping
drop table if exists #lookup_vw_ref_Medicare_PartC_Disease_Group_Map
--
select * 
into
	#lookup_vw_ref_Medicare_PartC_Disease_Group_Map
FROM 
	[dbo].vw_ref_Medicare_PartC_Disease_Group_Map
where 1=1
AND 
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 

 
---------------------------------------------------------------------------------------------
--disease hierarchy
drop table if exists #lookup_vw_ref_Medicare_PartC_Hierarchy
--
select * 
into
	#lookup_vw_ref_Medicare_PartC_Hierarchy
FROM 
	[dbo].[vw_ref_Medicare_PartC_Hierarchy]
where 1=1
AND
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 
---------------------------------------------------------------------------------------------
--disease interaction map
drop table if exists #lookup_vw_ref_Medicare_PartC_Interaction_Map
--
select * 
into
	#lookup_vw_ref_Medicare_PartC_Interaction_Map
	--SELECT *
FROM 
	[dbo].[vw_ref_Medicare_PartC_Interaction_Map]
where 1=1
AND
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 

 
---------------------------------------------------------------------------------------------
--disease interaction factor
drop table if exists #lookup_vw_ref_Medicare_PartC_Disease_Interaction_Factor

select *
into
	#lookup_vw_ref_Medicare_PartC_Disease_Interaction_Factor
from 
	dbo.[vw_ref_Medicare_PartC_Disease_Interaction_Factor]
where 1=1
AND
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 

	--select * from #lookup_vw_ref_Medicare_PartC_Disease_Interaction_Factor
----------------------------------------------------------------------------------------------
--disease disability factor
drop table if exists #lookup_vw_ref_Medicare_PartC_Disease_Disability_Factor
--
select * 
into
	#lookup_vw_ref_Medicare_PartC_Disease_Disability_Factor
	 
from 
	dbo.[vw_ref_Medicare_PartC_Disease_Disability_Factor]
where 1=1
AND
	Model like 'HCC Model-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 

	 
----------------------------------------------------------------------------------------------	

Declare @M as [Validated_InputMembership_PartC] 
Declare @d as [InputDiagnosis_Inner]

insert into @d
select * from @DxTable --You should have this data as user

insert into @M
select * from @Membership-- You should have this data as user
---------------------------------------------------------------------------------------------
--RAF PROCESS
---------------------------------------------------------------------------------------------
drop table if exists #membership
select distinct
	@PmtYear as PmtYear,
	m.MemberID,
	m.BirthDate as BirthDate_org,
	case when m.BirthDate is null then getdate() else m.BirthDate end as BirthDate,
	[dbo].[CalculateAge](case when m.BirthDate is null then getdate() else m.BirthDate end , CAST(cast(@PmtYear as VARCHAR(10))+'/02/01' as DATE)) as Age,
	CAST('' as VARCHAR(20)) as AgeBand,
	m.Gender_org as Gender_org,
	case when m.Gender in ('M','F') then m.Gender else 'M' end as Gender,
	M.RAtype_org AS RAtype_org,
    M.RAType AS RAType,
    CASE 
        WHEN R.AgedDisabled = 'Yes' AND [dbo].[CalculateAge](CASE WHEN m.BirthDate IS NULL THEN GETDATE() ELSE m.BirthDate END, CAST(CAST(@PmtYear AS VARCHAR(10)) + '/02/01' AS DATE)) < 65 THEN CONCAT(R.RAType_Engine, 'D')
        WHEN R.AgedDisabled = 'Yes' AND [dbo].[CalculateAge](CASE WHEN m.BirthDate IS NULL THEN GETDATE() ELSE m.BirthDate END, CAST(CAST(@PmtYear AS VARCHAR(10)) + '/02/01' AS DATE)) >= 65 THEN CONCAT(R.RAType_Engine, 'A')
        ELSE ISNULL(NULLIF(RAType_Engine, ''), m.RAType) END RAType_Engine,
	--m.ESRD as ESRD_org,
	--case when ISNULL(r.ESRD,'') in ('Yes') then 'Y' else 'N' end as ESRD,

	m.Hospice_org as Hospice_org,
	case when ISNULL(m.Hospice,'') in ('Y','N') then m.Hospice else 'N' end as Hospice,

	m.LTIMCAID_org as LTIMCAID_org,
	case when ISNULL(m.LTIMCAID,'') in ('Y','N') then m.LTIMCAID else 'N' end as LTIMCAID,

	m.NEMCAID_org as NEMCAID_org,
	case when ISNULL(m.NEMCAID,'') in ('Y','N') then m.NEMCAID else 'N' end as NEMCAID,

	m.OREC_org as OREC_org,
	case when ISNULL(m.OREC,'') in (0,1,2,3) then m.OREC else 0 end as OREC,
	'N' as OriginallyDisabled,
	--cast('' as VARCHAR(500)) as dis_list_diagnosis,
	cast('' as VARCHAR(500)) as dis_list_category,
	cast('' as VARCHAR(500)) as dis_count,
	cast('' as VARCHAR(500)) as dis_int_dis,
	cast('' as VARCHAR(500)) as dis_int_disab,
	cast('' as VARCHAR(500)) as ra_variable,
	cast (0.00 as decimal(7,3)) as raf_demo,
	cast (0.00 as decimal(7,3)) as raf_demo_status,
	cast (0.00 as decimal(7,3)) as raf_dis,
	cast (0.00 as decimal(7,3)) as raf_dis_count,
	cast (0.00 as decimal(7,3)) as raf_dis_int_dis,
	cast (0.00 as decimal(7,3)) as raf_dis_int_disab,
	cast (0.00 as decimal(7,3)) as raf_total,
	cast('' as VARCHAR(200)) as Model,
	IsError,
	[MessageCode]
INTO #membership
FROM @M m
LEFT JOIN [dbo].[vw_ref_Medicare_PartC_RATypeMapping] R ON m.RAType = r.RAType 
WHERE R.PaymentYear = @PmtYear
AND IsError=0

--------------------------------------------------------------------------------------------
--DROP TABLE IF EXISTS #ErrorMembership
--SELECT DISTINCT
--    @PmtYear AS PmtYear,
--    m.MemberID,
--    m.BirthDate AS BirthDate_org,
--    CASE WHEN m.BirthDate IS NULL THEN GETDATE() ELSE m.BirthDate END AS BirthDate,
--    [dbo].[CalculateAge](CASE WHEN m.BirthDate IS NULL THEN GETDATE() ELSE m.BirthDate END, CAST(CAST(@PmtYear AS VARCHAR(10)) + '/02/01' AS DATE)) AS Age,
--    CAST('' AS VARCHAR(20)) AS AgeBand,
--    m.Gender AS Gender_org,
--    CASE WHEN m.Gender IN ('M', 'F') THEN m.Gender ELSE 'M' END AS Gender,
--    M.RAType AS RAtype_org,
--    M.RAType AS RAType,
--    CASE 
--        WHEN R.AgedDisabled = 'Yes' AND [dbo].[CalculateAge](CASE WHEN m.BirthDate IS NULL THEN GETDATE() ELSE m.BirthDate END, CAST(CAST(@PmtYear AS VARCHAR(10)) + '/02/01' AS DATE)) < 65 THEN CONCAT(R.RAType_Engine, 'D')
--        WHEN R.AgedDisabled = 'Yes' AND [dbo].[CalculateAge](CASE WHEN m.BirthDate IS NULL THEN GETDATE() ELSE m.BirthDate END, CAST(CAST(@PmtYear AS VARCHAR(10)) + '/02/01' AS DATE)) >= 65 THEN CONCAT(R.RAType_Engine, 'A')
--        ELSE ISNULL(NULLIF(RAType_Engine, ''), m.RAType) END RAType_Engine,
--    m.Hospice AS Hospice_org,
--    CASE WHEN ISNULL(m.Hospice, '') IN ('Y', 'N') THEN m.Hospice ELSE 'N' END AS Hospice,
--    m.LTIMCAID AS LTIMCAID_org,
--    CASE WHEN ISNULL(m.LTIMCAID, '') IN ('Y', 'N') THEN m.LTIMCAID ELSE 'N' END AS LTIMCAID,
--    m.NEMCAID AS NEMCAID_org,
--    CASE WHEN ISNULL(m.NEMCAID, '') IN ('Y', 'N') THEN m.NEMCAID ELSE 'N' END AS NEMCAID,
--    m.OREC AS OREC_org,
--    CASE WHEN ISNULL(m.OREC, '') IN (0, 1, 2, 3) THEN m.OREC ELSE 0 END AS OREC,
--    'N' AS OriginallyDisabled,
--    CAST('' AS VARCHAR(500)) AS dis_list_category,
--    CAST('' AS VARCHAR(500)) AS dis_count,
--    CAST('' AS VARCHAR(500)) AS dis_int_dis,
--    CAST('' AS VARCHAR(500)) AS dis_int_disab,
--    CAST('' AS VARCHAR(500)) AS ra_variable,
--    CAST(0.00 AS DECIMAL(7, 3)) AS raf_demo,
--    CAST(0.00 AS DECIMAL(7, 3)) AS raf_demo_status,
--    CAST(0.00 AS DECIMAL(7, 3)) AS raf_dis,
--    CAST(0.00 AS DECIMAL(7, 3)) AS raf_dis_count,
--    CAST(0.00 AS DECIMAL(7, 3)) AS raf_dis_int_dis,
--    CAST(0.00 AS DECIMAL(7, 3)) AS raf_dis_int_disab,
--    CAST(0.00 AS DECIMAL(7, 3)) AS raf_total,
--    CAST('' AS VARCHAR(200)) AS Model,
--	IsError,
--	[MessageCode]
--INTO #ErrorMembership
--FROM @M m
--LEFT JOIN [dbo].[vw_ref_Medicare_PartC_RATypeMapping] R ON m.RAType = r.RAType 
--WHERE R.PaymentYear = @PmtYear
--AND IsError=1

-------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--Correct Incorrect Input--START
---------------------------------------------------------------------------------------------
--Member must have OREC=1 and disabled=Y if they are less than 65 years old
--UPDATE a
--SET a.OREC = 1
--FROM #membership a
--WHERE Age < 65 AND OREC = 0 AND RAType_Engine IN ('CFD', 'CND', 'CPD')

--If Member is younger than 65, the member has to be disabled. i.e Right(RATYPE,1) should be A 
--and in this case OREC should be set to 1 as well. last part is already taken care above. 

--If Member is 65 or more the member cannot be disabled. i.e Right(RATYPE,1) should be A.- Change the RATYPE

--If Disabled flag is N but the RAType indicates the member is disabled, we will prioritize the RAType
--and update disability flag to Y

--If Disabled flag is Y but the RAType indicates the member is NOT disabled, we will prioritize the RAType
--and update disability flag to N

--If Medicaid flag is N but the RAType indicates the member is Medicaid, we will prioritize the RAType
--and update Medicaid flag to Y

--If Medicaid flag is Y but the RAType indicates the member is NOT Medicaid, we will prioritize the RAType
--and update Medicaid flag to N

--UPDATE A
--SET NEMCAID = 'N'
--FROM #membership a
--WHERE NEMCAID = 'Y' AND RAType_Engine NOT IN ('NE', 'SNPNE')

--UPDATE A
--SET LTIMCAID = 'N'
--FROM #membership a
--WHERE LTIMCAID = 'Y' AND RAType_Engine NOT IN ('INS')

--UPDATE ORIG_DISABILITY only if member is has and then Age >=65
UPDATE A
SET OriginallyDisabled = 'Y'
FROM #membership a
WHERE OREC IN (1, 2, 3) AND AGE >= 65 AND RAType_Engine IN ('CFA', 'CNA', 'CPA', 'INS', 'NE', 'SNPNE', 'INS')
---------------------------------------------------------------------------------------------
--Correct Incorrect Input--END
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--Apply Demographic Factor Based on Age and Sex
---------------------------------------------------------------------------------------------
UPDATE a
SET a.raf_demo = ISNULL(b.Factor, 0),
    a.AgeBand = b.AgeBand,
    a.ra_variable = b.Variable
FROM #membership a
LEFT JOIN #lookup_vw_ref_Medicare_PartC_Demographic_Factor b
ON a.Gender = b.Gender AND b.RAType = a.RAType_Engine AND a.Age BETWEEN Age_Start AND Age_End AND A.Hospice = 'N'
---------------------------------------------------------------------------------------------
--Apply Demographic Status Factor Based on Original Disability
---------------------------------------------------------------------------------------------
UPDATE a
SET a.raf_demo_status = b.Factor,
    a.ra_variable = ISNULL(ra_variable, '') + ', ' + b.Variable,
    a.AgeBand = b.AgeBand
FROM #membership a
JOIN #lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b
ON b.RAType = a.RAType_Engine AND a.OriginallyDisabled = b.OriginallyDisabled
WHERE a.OriginallyDisabled = 'Y' AND (a.RAType_Engine = 'INS' OR (a.RAType_Engine <> 'INS' AND ISNULL(a.Gender, '') = ISNULL(b.Gender, '')))
AND A.Hospice = 'N'
---------------------------------------------------------------------------------------------
--Apply Demographic Status Factor Based on Medicaid
---------------------------------------------------------------------------------------------
UPDATE a
SET a.raf_demo_status = a.raf_demo_status + b.Factor,
    a.ra_variable = a.ra_variable + ', ' + b.Variable,
    a.AgeBand = b.AgeBand
FROM #membership a
JOIN #lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b
ON a.LTIMCAID = b.Medicaid
WHERE b.RAType = a.RAType_Engine AND a.RAType_Engine = 'INS' AND A.Hospice = 'N'
---------------------------------------------------------------------------------------------
--New Enrollee
UPDATE a
SET a.raf_demo_status = b.Factor,
    a.ra_variable = b.Variable,
    a.AgeBand = b.AgeBand
FROM #membership a
JOIN #lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b
ON ISNULL(a.Gender, '') = ISNULL(b.Gender, '') AND b.RAType = a.RAType_Engine AND a.Age BETWEEN Age_Start AND Age_End AND a.NEMCAID = b.Medicaid AND a.OriginallyDisabled = b.OriginallyDisabled
WHERE b.Variable LIKE '%MCAID%ORIGDIS%' AND b.RAtype IN ('NE', 'SNPNE') AND A.Hospice = 'N'
---------------------------------------------------------------------------------------------
--APPLICATION OF DISEASE FACTOR
---------------------------------------------------------------------------------------------
--Get Disease level list
DROP TABLE IF EXISTS #disease_detail
SELECT DISTINCT 
    d.MemberID,	
	d.FromDos,
	d.ThruDos,
	d.QualificationFlag,
	d.UnqualificationReason,
	d.DxCode,
	l.Category,
    l.ClinicalVersion
INTO #disease_detail
FROM @d d
JOIN #lookup_ICDMapping l
ON d.DxCode = l.DxCode
--WHERE YEAR(d.ThruDOS) = @dosyear
---------------------------------------------------------------------------------------------
--delete lower hierarchy when upper hierarchy is present
DELETE b
FROM #disease_detail a
JOIN #disease_detail b
ON a.MemberID = b.MemberID
JOIN #lookup_vw_ref_Medicare_PartC_Hierarchy c
ON a.Category = c.category AND b.Category = c.categoryoverride
---------------------------------------------------------------------------------------------
--Map Category to Disease Category Factor, and obtain a member level csv list and member level factor
DROP TABLE IF EXISTS #disease_detail_With_factor
;WITH my_cte AS (
    SELECT 
        a.*, b.RAType_Engine, l.Factor, l.Variable
    FROM #disease_detail a
    JOIN #membership b
    ON a.MemberID = b.MemberID
    JOIN #lookup_vw_ref_Medicare_PartC_Disease_Factor l
    ON a.Category = l.Category AND l.RAType = b.RAType_Engine
)
SELECT 
    MemberID,
    SUM(Factor) AS Factor,
    COUNT(DISTINCT Category) AS DiseaseCount,
    STRING_AGG(Category, ', ') WITHIN GROUP (ORDER BY CAST(REPLACE(Category, 'HCC', '') AS NUMERIC(19, 4))) AS Categories
INTO #disease_detail_With_factor
FROM my_cte
GROUP BY MemberID
---------------------------------------------------------------------------------------------
--Update Factor to main result table
UPDATE a
SET a.raf_dis = ISNULL(b.Factor, 0),
    a.dis_list_category = b.Categories,
    a.dis_count = 'D' + CASE WHEN b.DiseaseCount >= 10 THEN '10P' ELSE CAST(b.DiseaseCount AS VARCHAR(5)) END,
    a.ra_variable = ra_variable + ', ' + b.Categories
FROM #membership a
JOIN #disease_detail_With_factor b
ON a.MemberID = b.MemberID AND A.Hospice = 'N'
---------------------------------------------------------------------------------------------
--APPLICATION OF DISEASE COUNT FACTOR
---------------------------------------------------------------------------------------------
UPDATE a
SET a.raf_dis_count = b.factor,
    a.dis_count = CASE WHEN b.factor = 0 THEN '' ELSE dis_count END,
    a.ra_variable = ra_variable + CASE WHEN b.factor = 0 THEN '' ELSE ', DISEASE COUNT ' + dis_count END
FROM #membership a
JOIN #lookup_vw_ref_Medicare_PartC_Disease_Count_Factor b
ON a.dis_count = b.DiseaseCountCategory AND b.RAType = a.RAType_Engine AND A.Hospice = 'N'
---------------------------------------------------------------------------------------------
--Obtain Disease Interaction
DROP TABLE IF EXISTS #Disease_Interaction_detail_With_factor
;WITH my_cte AS (
    SELECT 
        a.*,
        ISNULL(b.diseasecategory, a.Category) AS diseasecategory,
        c.Interactionvariable,
        c.interactioncategory
    FROM #disease_detail a
    LEFT JOIN #lookup_vw_ref_Medicare_PartC_Disease_Group_Map b
    ON a.Category = b.HCC
    LEFT JOIN (SELECT * FROM #lookup_vw_ref_Medicare_PartC_Interaction_Map WHERE interactioncategory NOT LIKE 'Disabled%' AND interactioncategory NOT LIKE 'nonaged%') c
    ON ISNULL(b.diseasecategory, a.Category) = c.Interactionvariable
)
SELECT DISTINCT 
    m.MemberID,
    m.interactioncategory,
    n.ratype,
    n.Factor
INTO #Disease_Interaction_detail_With_factor
FROM my_cte m
LEFT JOIN #lookup_vw_ref_Medicare_PartC_Disease_Interaction_Factor n
ON m.interactioncategory = n.Interaction
WHERE MemberID + interactioncategory IN (
    SELECT MemberID + ISNULL(interactioncategory, '') FROM my_cte
    GROUP BY MemberID + ISNULL(interactioncategory, '')
    HAVING COUNT(DISTINCT Interactionvariable) > 1
)
---------------------------------------------------------------------------------------------
--UPDATE disease interaction factor to the main table by matching on RATYPE
;WITH my_cte AS (
    SELECT 
        MemberID,
        ratype,
        SUM(Factor) AS Factor,
        COUNT(DISTINCT interactioncategory) AS DiseaseInteraction_Count,
        STRING_AGG(interactioncategory, ', ') WITHIN GROUP (ORDER BY interactioncategory) AS interactioncategory
    FROM #Disease_Interaction_detail_With_factor
    GROUP BY MemberID, ratype
)
UPDATE a
SET a.dis_int_dis = b.interactioncategory,
    a.raf_dis_int_dis = b.Factor,
    a.ra_variable = ra_variable + ', ' + interactioncategory
FROM #membership a
JOIN my_cte b
ON a.MemberID = b.MemberID AND a.RAType_Engine = b.ratype AND A.Hospice = 'N'
---------------------------------------------------------------------------------------------
--OBTAIN DISABLED DISEASE INTERACTION
DROP TABLE IF EXISTS #disabled_disease_Interaction
;WITH my_cte AS (
    SELECT 
        a.*,
        ISNULL(b.diseasecategory, a.Category) AS diseasecategory,
        c.Interactionvariable,
        c.interactioncategory
    FROM #disease_detail a
    JOIN #lookup_vw_ref_Medicare_PartC_Disease_Group_Map b
    ON a.Category = b.HCC
    JOIN (SELECT * FROM #lookup_vw_ref_Medicare_PartC_Interaction_Map WHERE interactioncategory LIKE 'Disabled%') c
    ON ISNULL(b.diseasecategory, a.Category) = c.Interactionvariable
)
SELECT DISTINCT 
    a.MemberId, 
    b.RAType_Engine AS RAType,
    interactioncategory,    
    c.Factor
INTO #disabled_disease_Interaction
FROM my_cte a
JOIN #membership b
ON a.MemberID = b.MemberID
JOIN #lookup_vw_ref_Medicare_PartC_Disease_Disability_Factor c
ON 'DISABLED_' + a.Interactionvariable = c.Interaction AND c.RAType = b.RAType_Engine
---------------------------------------------------------------------------------------------
--UPDATE disabled disease interaction factor to the main table
;WITH my_cte3 AS (
    SELECT 
        MemberID,
        ratype,
        SUM(Factor) AS Factor,
        COUNT(DISTINCT interactioncategory) AS DiseaseInteraction_Count,
        STRING_AGG(interactioncategory, ', ') WITHIN GROUP (ORDER BY interactioncategory) AS interactioncategory
    FROM #disabled_disease_Interaction
    GROUP BY MemberID, ratype
)
UPDATE a
SET a.dis_int_disab = b.interactioncategory,
    a.raf_dis_int_disab = b.Factor,
    a.ra_variable = ra_variable + ', ' + interactioncategory
FROM #membership a
JOIN my_cte3 b
ON a.MemberID = b.MemberID AND a.RAType_Engine = b.RAType AND A.Hospice = 'N'
---------------------------------------------------------------------------------------------
--SET @Model=(SELECT DISTINCT Model FROM [MasterReferenceDB].[dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
--WHERE PmtYear = @PmtYear AND ClinicalVersion = @ClinicalVersion AND Model LIKE '%HCC Model%Regular%')
---------------------------------------------------------------------------------------------
UPDATE a
SET a.Model = CASE 
                WHEN a.RAType_Engine IN ('CFA', 'CNA', 'CPA', 'NE', 'SNPNE', 'CFD', 'CND', 'CPD', 'INS') AND m.Model LIKE '%HCC Model%Regular%' THEN m.model 
                ELSE 'Unknown' 
              END,
    a.raf_total = a.raf_demo + a.raf_demo_status + a.raf_dis + a.raf_dis_count + a.raf_dis_int_dis + a.raf_dis_int_disab
FROM #membership a
OUTER APPLY (SELECT DISTINCT Model FROM [MasterReferenceDB].[dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
WHERE PmtYear = @PmtYear AND ClinicalVersion = @ClinicalVersion AND model NOT LIKE '%pace%') m
-------------------------------------------------------------------------------------------------------------
IF @ENGINEType = 1
BEGIN
	select 
		PmtYear,
		MemberID,
		BirthDate_Org,
		BirthDate,
		Age,
		ISNULL(AgeBand,Age) AgeBand,
		Gender_Org,
		Gender,
		RAType_Org,
		RAType,
		ISNULL(RAType_Engine, RAType_Org) AS RAType_Engine,
		Hospice_Org,
		Hospice,
		LTIMCAID_Org,
		LTIMCAID,
		NEMCAID_Org,
		NEMCAID,
		OREC_Org,
		OREC,
		OriginallyDisabled,
		0 OriginallyESRD,
		ISNULL(ra_variable,'') ra_variable,
		 ROUND(raf_demo, 3, 1) AS raf_demo,
		ROUND(raf_demo_status, 3, 1) AS raf_demo_status,
		ROUND(raf_dis, 3, 1) AS raf_dis,
		ROUND(raf_dis_count, 3, 1) AS raf_dis_count,
		ROUND(raf_dis_int_dis, 3, 1) AS raf_dis_int_dis,
		ROUND(raf_dis_int_disab, 3, 1) AS raf_dis_int_disab,
		ROUND(raf_total, 3, 1) AS raf_total,
		ISNULL(Model,'Unknown') Model,
		@ClinicalVersion  as ClinicalVersion ,
		
	[MessageCode],
	IsError
	from 
		#membership
--UNION
--SELECT PmtYear,
--    MemberID,
--    BirthDate_Org,
--    BirthDate,
--    Age,
--    ISNULL(AgeBand, Age) AS AgeBand,
--    Gender_Org,
--    Gender,
--    RAType_Org,
--    RAType,
--    ISNULL(RAType_Engine, RAType_Org) AS RAType_Engine,
--    Hospice_Org,
--    Hospice,
--    LTIMCAID_Org,
--    LTIMCAID,
--    NEMCAID_Org,
--    NEMCAID,
--    OREC_Org,
--    OREC,
--    OriginallyDisabled,
--    0 AS OriginallyESRD,
--    ISNULL(ra_variable, '') AS ra_variable,
--    ROUND(raf_demo, 3, 1) AS raf_demo,
--    ROUND(raf_demo_status, 3, 1) AS raf_demo_status,
--    ROUND(raf_dis, 3, 1) AS raf_dis,
--    ROUND(raf_dis_count, 3, 1) AS raf_dis_count,
--    ROUND(raf_dis_int_dis, 3, 1) AS raf_dis_int_dis,
--    ROUND(raf_dis_int_disab, 3, 1) AS raf_dis_int_disab,
--    ROUND(raf_total, 3, 1) AS raf_total,
--    ISNULL(Model, 'Unknown') AS Model,
--    @ClinicalVersion AS ClinicalVersion,
--	[MessageCode],
--	IsError
--FROM #ErrorMembership
END
ELSE IF @ENGINEType = 2
BEGIN
	select 
		m.PmtYear,
		m.MemberID,
		d.FromDOS,
		d.ThruDOS,
		d.DxCode ICD,
		ROUND(ISNULL(l.Factor,0), 3, 1) CategoryFactor ,
		d.Category,			
		@ClinicalVersion  as ClinicalVersion ,		
		m.Model,
		l.ModelDescription,
		d.QualificationFlag,
		d.UnqualificationReason,
		[MessageCode],
		IsError
	from 
		#membership m
	LEFT JOIN 
		#disease_detail d 
				ON m.MemberID = d.MemberID
	LEFT JOIN #lookup_vw_ref_Medicare_PartC_Disease_Factor l
				on d.Category=l.Category
					AND	 l.RAType = m.RAType_Engine 
					AND	 l.PmtYear = m.PmtYear 
					AND	 l.ClinicalVersion = @ClinicalVersion



END
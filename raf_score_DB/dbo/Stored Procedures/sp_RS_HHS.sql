 
create   procedure [dbo].[sp_RS_HHS](@PaymentYear as int, @Membership as [InputMembership_HHS] READONLY, @DxTable as [InputDiagnosis_HHS] READONLY,@NDC [InputNDC_HHS] READONLY ,@HCPCS [InputHCPCS_HHS] READONLY)
as
--DECLARE 
--	@PaymentYear as int=2025,

--	@Membership as [InputMembership_HHS] , 
--	@DxTable as [InputDiagnosis_HHS] ,
--	@NDC as [InputNDC_HHS] ,
--	@HCPCS as [InputHCPCS_HHS] 
  

 
--insert into @Membership
--select 'M00912',	'M',		'1985-10-13',	'40',	'Gold',		2,12
--UNION 
--SELECT 'M00913',	'M',		'1930-06-16',	'95',	'Silver',		3,12
--UNION 
--SELECT 'M00914',	'M',		'1930-06-16',	'95',	'Platinum',		1,5
--UNION 
--SELECT 'M00915',	'M',		'2025-06-16',	'1',	'Platinum',		1,5

--insert into @DxTable
--select		 'M00912','F13229' ,'2024-06-03'
--UNION select 'M00913','S062X6S' ,'2024-06-03'
--UNION select 'M00913','B9735' ,'2024-06-03'
--UNION select 'M00914','L97413' ,'2024-06-03' 
--UNION select 'M00914','Z95811' ,'2024-06-03'
--UNION select 'M00914','T8620' ,'2024-06-03'
--UNION select 'M00914','A880' ,'2024-06-03' 
--UNION select 'M00914','B020' ,'2024-06-03'
--UNION select 'M00914','B459' ,'2024-06-03'
--UNION select 'M00914','C168' ,'2024-06-03' 
--UNION select 'M00914','C12' ,'2024-06-03'
--UNION select 'M00914','G2119' ,'2024-06-03' 
--UNION select 'M00914','I479' ,'2024-06-03' 
--UNION select 'M00915','L97413' ,'2024-06-03' 
--UNION select 'M00915','Z95811' ,'2024-06-03'
--UNION select 'M00915','T8620' ,'2024-06-03'
--UNION select 'M00915','A880' ,'2024-06-03' 
--UNION select 'M00915','B020' ,'2024-06-03'
--UNION select 'M00915','B459' ,'2024-06-03'
--UNION select 'M00915','C168' ,'2024-06-03' 
--UNION select 'M00915','C12' ,'2024-06-03'
--UNION select 'M00915','B9735' ,'2024-06-03'

--insert into @NDC
--select		 'M00912','00597004660'  
--UNION select 'M00913','00597004660'  
--UNION select 'M00914','00597004660'  
--UNION select 'M00914','00003196601' 
--insert into @HCPCS
--select		 'M00912','J0741'  
--UNION select 'M00913','J0741'  
--UNION select 'M00914','J0741'  

declare @Dosyear as int=@PaymentYear 
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
	[dbo].[vw_ref_HHS_ICD_Category_Mapping]
where 
	PaymentYear=@PaymentYear

delete from #lookup_ICDMapping where category = 0 -- Need to delete later 
---------------------------------------------------------------------------------------------
--CSR adjustment factors
drop table if exists #lookup_vw_ref_HHS_CSR_Adjustments
select * 
into 
	#lookup_vw_ref_HHS_CSR_Adjustments
from 
	[dbo].[vw_ref_HHS_CSR_Adjustments]
where 1=1
---------------------------------------------------------------------------------------------
--demographic factor lookup table
drop table if exists #lookup_vw_ref_HHS_Demographic_Factor
select * 
into 
	#lookup_vw_ref_HHS_Demographic_Factor
from 
	[dbo].[vw_ref_HHS_Demographic_Factor]
where 1=1 
AND
	PaymentYear=@PaymentYear

---------------------------------------------------------------------------------------------
--disease factor
drop table if exists #lookup_vw_ref_HHS_Disease_Factor
select * 
into
	#lookup_vw_ref_HHS_Disease_Factor
	 
FROM 
	[dbo].[vw_ref_HHS_Disease_Factor]
where 1=1
AND 
	PaymentYear=@PaymentYear 

 

---------------------------------------------------------------------------------------------
--disease count factor
drop table if exists #lookup_vw_ref_HHS_EnrolDuration_HCCCount
select * 
into
	#lookup_vw_ref_HHS_EnrolDuration_HCCCount
FROM 
	[dbo].[vw_ref_HHS_EnrolDuration_HCCCount]
where 1=1
AND
	PaymentYear=@PaymentYear 

 

---------------------------------------------------------------------------------------------
--disease hierarchy
drop table if exists #lookup_vw_ref_HHS_Hierarchy
select * 
into
	#lookup_vw_ref_HHS_Hierarchy
FROM 
	[dbo].[vw_ref_HHS_HCC_Heirarchy] 
where 1=1
AND
	PaymentYear=@PaymentYear 

---------------------------------------------------------------------------------------------
--RXC and HCPCS lookups
drop table if exists #lookup_vw_ref_HHS_RXC_NDC
select * 
into
	#lookup_vw_ref_HHS_RXC_NDC 
FROM 
	[dbo].[vw_ref_HHS_RXC_NDC]
where 1=1
AND
	PaymentYear=@PaymentYear

drop table if exists #lookup_vw_ref_HHS_RXC_Heirarchy
select * 
into
	#lookup_vw_ref_HHS_RXC_Heirarchy 
FROM 
	[dbo].[vw_ref_HHS_RXC_Heirarchy]
where 1=1
AND
	PaymentYear=@PaymentYear

drop table if exists #lookup_vw_ref_HHS_HCPCS
select * 
into
	#lookup_vw_ref_HHS_HCPCS
FROM 
	[dbo].[vw_ref_HHS_RXC_HCPCS]
where 1=1
AND
	PaymentYear=@PaymentYear


--*******************************************
drop table if exists #lookup_vw_ref_HHS_disease_interaction

select * 
into
	#lookup_vw_ref_HHS_disease_interaction
FROM 
	[dbo].[vw_ref_HHS_Disease_Interactions]
where 1=1
AND
	PaymentYear=@PaymentYear



--*********************************************************************************************

Declare @M as [InputMembership_HHS] 
Declare @d as [InputDiagnosis_HHS]
Declare @n as [InputNDC_HHS] 
Declare @h as [InputHCPCS_HHS]

insert into @d
select * from @DxTable

insert into @M
select * from @Membership

insert into @n
select * from @ndc

insert into @h
select * from @hcpcs

---------------------------------------------------------------------------------------------
--RAF PROCESS
---------------------------------------------------------------------------------------------
 
drop table if exists #membership
select distinct
	@PaymentYear as PaymentYear,
	m.MemberID,
	m.DOB as DOB_org,
	CASE WHEN m.DOB IS NULL THEN GETDATE() ELSE m.DOB END AS DOB,
	--[dbo].[CalculateAge](case when m.DOB is null then getdate() else m.DOB end , CAST(cast(@PaymentYear as VARCHAR(10))+'/02/01' as DATE)) as Age
	Age ,
	CAST('' as VARCHAR(20)) as AgeBand,
	m.Gender as Gender_org,
	case when m.Gender in ('M','F') then m.Gender else 'M' end as Gender,
	[MetalLevel],
	CSRIndicator,
	EnrollDuration,
	0 Severe,
	0 Transplant,
	cast('' as VARCHAR(500)) as dis_list_category,
	cast('' as VARCHAR(500)) as dis_count,
	cast('' as VARCHAR(500)) as dis_int_dis,
	cast('' as VARCHAR(500)) as  ra_variable,
	cast (0.00 as decimal(7,3)) as raf_DEMO,
	cast (0.00 as decimal(7,3)) as raf_HCC,
	cast (0.00 as decimal(7,3)) as raf_RXC,
	cast (0.00 as decimal(7,3)) as raf_RXC_Interaction,
	cast (0.00 as decimal(7,3)) as raf_HCC_Interaction,
	cast (0.00 as decimal(7,3)) as raf_HCC_RXC_Interaction,
	cast (0.00 as decimal(7,3)) as RAF_HCC_COUNT_ED_Interaction,
	cast (0.00 as decimal(7,3)) as raf_HCC_EnrollDuration,
	cast (0.00 as decimal(7,3)) as raf_total,
	cast('' as VARCHAR(200)) as Model 
INTO #membership
FROM @M m

--*****************************************************************************************
UPDATE M
SET Model = CASE WHEN Age > 21 THEN 'ADULT'	
				 WHEN Age BETWEEN 2 AND 20 THEN 'CHILD'	
				 WHEN Age < 2 THEN 'INFANT'	END 
		
FROM #membership M

---------------------------------------------------------------------------------------------
--Apply Demographic Factor Based on Age and Sex
---------------------------------------------------------------------------------------------
UPDATE a
SET a.raf_demo = ISNULL(b.Weight, 0),
    --a.AgeBand = b.AgeBand,
    a.ra_variable = b.Variable

FROM #membership a
LEFT JOIN #lookup_vw_ref_HHS_Demographic_Factor b
ON a.Gender = b.Gender AND a.Age BETWEEN Age_Start AND Age_End
WHERE a.[MetalLevel] = b.[MetalLevel]

---------------------------------------------------------------------------------------------
--APPLICATION OF DISEASE FACTOR
---------------------------------------------------------------------------------------------
--Get Disease level list
DROP TABLE IF EXISTS #disease_detail
SELECT DISTINCT 
    d.MemberID,		
	d.DxCode,
	CAST(l.Category AS VARCHAR) Category
INTO #disease_detail
FROM @d d
INNER JOIN @M m On d.MemberID = M.MemberId
INNER JOIN #lookup_ICDMapping l
ON d.DxCode = l.DxCode
Where ServiceDate Between DXCodeStartDate and DXCodeEndDate
AND
[dbo].[CalculateAge](m.DOB , CAST(d.ServiceDate as DATE)) Between l.FYStartAge and FYEndAge
AND
[dbo].[CalculateAge](m.DOB , CAST(d.ServiceDate as DATE)) Between l.CYStartAge and CYEndAge
AND 
Age Between CCStartAge AND CCEndAge
AND 
(
(ISNULL(FYSex,'') = '' OR (ISNULL(FYSex,'')  <> '' AND Gender = FYSex))
AND 
(ISNULL(CYSex,'') = '' OR (ISNULL(CYSex,'')  <> '' AND Gender = CYSex))
AND
(ISNULL(CCSexSplit,'') = '' OR (ISNULL(CCSexSplit,'')  <> '' AND Gender = CCSexSplit))
)

 
 
---------------------------------------------------------------------------------------------
--delete lower hierarchy when upper hierarchy is present
DELETE b
FROM #disease_detail a
INNER JOIN #disease_detail b
ON a.MemberID = b.MemberID
INNER JOIN #lookup_vw_ref_HHS_Hierarchy c
ON a.Category = c.category AND b.Category = c.categoryoverride

  
---------------------------------------------------------------------------------------------
--Map Category to Disease Category Factor, and obtain a member level csv list and member level factor
DROP TABLE IF EXISTS #disease_detail_With_factor
;WITH my_cte AS (
    SELECT 
        a.*, CAST(l.Weight AS DECIMAL(37,18)) Weight, l.Variable
    FROM 
		#disease_detail a
    INNER JOIN #lookup_vw_ref_HHS_Disease_Factor l
		ON a.Category =  LTRIM(REPLACE(l.Category, 'HCC', '')  ,'0')
	INNER JOIN 
		#membership M ON M.MemberId = a.MemberID AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
	where l.Category like ('HCC%')
)
 
SELECT 
    MemberID,
    SUM(Weight) AS Weight,
    COUNT(DISTINCT Category) AS DiseaseCount,
    STRING_AGG(cONCAT('HCC',format(CAST(Category AS INT),'000')), ', ') WITHIN GROUP (ORDER BY CategorY) AS Categories
INTO #disease_detail_With_factor
FROM my_cte
GROUP BY MemberID
  
---------------------------------------------------------------------------------------------
--Update Factor to main result table
UPDATE a
SET a.RAF_HCC = ISNULL(b.Weight, 0),
    a.dis_list_category = b.Categories,
    a.dis_count =   b.DiseaseCount ,
    a.ra_variable = ra_variable + ', ' + b.Categories
FROM #membership a
INNER JOIN #disease_detail_With_factor b
ON a.MemberID = b.MemberID
 


--*******************RXC FACTOR ***********************************************************
---------------------------------------------------------------------------------------------
--APPLICATION OF DISEASE FACTOR
---------------------------------------------------------------------------------------------
--Get Disease level list
DROP TABLE IF EXISTS #RXC_detail
SELECT DISTINCT 
    d.MemberID,		
	d.ndc,
	CAST(l.Rxc AS VARCHAR) Rxc
INTO #RXC_detail
FROM @n d
INNER JOIN #lookup_vw_ref_HHS_RXC_NDC l on  d.ndc = l.ndc
INNER JOIN  @h h on d.MemberId = h.MemberId
INNER JOIN #lookup_vw_ref_HHS_HCPCS LH on lH.HCPCS =h.HCPCS

 
 
---------------------------------------------------------------------------------------------
--delete lower hierarchy when upper hierarchy is present
DELETE b
FROM #RXC_detail a
INNER JOIN #RXC_detail b
ON a.MemberID = b.MemberID
INNER JOIN #lookup_vw_ref_HHS_RXC_Heirarchy c
ON a.Rxc = c.Rxc AND b.Rxc = c.Rxcoverride

  
---------------------------------------------------------------------------------------------
--Map Category to Disease Category Factor, and obtain a member level csv list and member level factor
DROP TABLE IF EXISTS #RXC_detail_With_factor
;WITH my_cte AS (
    SELECT 
        a.MemberId,CONCAT('RXC_',FORMAT(CAST(a.Rxc AS INT),'00')) Rxc , CAST(l.Weight AS DECIMAL(37,18)) Weight, l.Variable
    FROM 
		#RXC_detail a
    INNER JOIN #lookup_vw_ref_HHS_Disease_Factor l
		ON CONCAT('RXC_',FORMAT(CAST(a.Rxc AS INT),'00')) = l.category --cast(replace(l.category ,'RXC_','') as int)
	INNER JOIN 
		#membership M ON M.MemberId = a.MemberID AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
	where l.category like 'RXC_[0-9][0-9]' 
)
 
SELECT 
    MemberID,
    SUM(Weight) AS Weight,
   -- COUNT(DISTINCT Rxc) AS DiseaseCount,
    STRING_AGG(Rxc, ', ') WITHIN GROUP (ORDER BY Rxc) AS Categories
INTO #RXC_detail_With_factor
FROM my_cte
GROUP BY MemberID
 
---------------------------------------------------------------------------------------------
--Update Factor to main result table
UPDATE a
SET a.raf_rxc = ISNULL(b.Weight, 0),
    a.dis_list_category = dis_list_category +','+b.Categories,
   -- a.dis_count = 'D' + CASE WHEN b.DiseaseCount >= 8 THEN '8Plus' ELSE CAST(b.DiseaseCount AS VARCHAR(5)) END,
    a.ra_variable = ra_variable + ', ' + b.Categories
FROM #membership a
INNER JOIN #rxc_detail_With_factor b
ON a.MemberID = b.MemberID
 

---------------------------------------------------------------------------------------------
--Obtain Disease Interaction
DROP TABLE IF EXISTS #ref_HHS_disease_interaction
;WITH my_cte AS (
    SELECT DISTINCT
        a.*,m.Model,m.MetalLevel,
        b.variable AS diseasecategory,
        b.variable,
		0 Severe,
		0 Transplant
		 
    FROM #disease_detail a
	INNER JOIN #membership m on m.MemberID = a.memberId
    Cross Apply   (
        SELECT  [Variable], Severe,Transplant
        FROM #lookup_vw_ref_HHS_disease_interaction b 
		OUTER apply STRING_SPLIT(b.[Category], ',') AS split_cat 
        WHERE TRIM(split_cat.value) = a.Category
    ) b
	where  b.variable not like  'rxc%'
    UNION
	SELECT DISTINCT
        a.*,m.Model,m.MetalLevel,
        c.variable AS diseasecategory,
        c.variable,
		case when  c.variable like '%SEVERE%' THEN 1 ELSE 0 END SEVERE,
	    case when  c.variable like '%TRANSPLANT%' THEN 1 ELSE 0 END TRANSPLANT
		 
    FROM #disease_detail a
	INNER JOIN #membership m on m.MemberID = a.memberId
    OUTER Apply   (
        SELECT  [Variable], Severe,Transplant
        FROM #lookup_vw_ref_HHS_disease_interaction b 
		cross apply STRING_SPLIT(b.[Category], ',') AS split_cat 
        WHERE TRIM(split_cat.value) = a.Category
    ) b
    LEFT JOIN #lookup_vw_ref_HHS_disease_interaction c on b.variable = c.category
	where  b.variable not like  'rxc%'
     
)
 

SELECT DISTINCT 
    m.MemberID,
	MAX(Severe) Severe ,
	MAX(TRANSPLANT) TRANSPLANT,
    STRING_AGG(m.diseasecategory, ', ') WITHIN GROUP (ORDER BY diseasecategory) AS interactioncategory ,
    SUM(cast(l.Weight as numeric(19,4))) Factor
	

INTO #ref_HHS_disease_interaction
FROM my_cte m
LEFT JOIN #lookup_vw_ref_HHS_Disease_Factor  l  
     ON  m.diseasecategory = l.Category AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
Group By memberId
   
 

UPDATE a
SET a.RAF_HCC_Interaction = b.Factor,
    Severe = b.severe,
	Transplant = b.Transplant,
    a.ra_variable = ra_variable + ', ' + interactioncategory,
	dis_count = case when model = 'ADULT' AND a.SEVERE = 1 and dis_count >= 10 then '10Plus' 
					 when model = 'ADULT' AND a.Transplant = 1 and dis_count >= 8 then '8Plus'
					 when model = 'CHILD' AND a.SEVERE = 1 and dis_count IN (6,7) then '6_7'
					 when model = 'CHILD' AND a.SEVERE = 1 and dis_count >= 8 then '8Plus' 
					 when model = 'ADULT' AND a.Transplant = 1 and dis_count >= 4 then '4Plus'
					 else dis_count end
FROM #membership a
INNER JOIN #ref_HHS_disease_interaction b
			ON a.MemberID = b.MemberID


---------------------------------------------------------------------------------------------
--APPLICATION OF DISEASE COUNT FACTOR
---------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #ref_HHS_HCCCount
;WITH HccCountCTE
AS(
SELECT 

	A.MemberID,
	A.Model,
	A.MetalLevel,
	A.PaymentYear,
	B.Variable category
  

FROM #membership a
INNER JOIN #lookup_vw_ref_HHS_EnrolDuration_HCCCount b
	ON a.MODEL = b.MODEL and a.dis_count = b.HccCount
	 
	AND ISNULL(A.TRANSPLANT,0) = ISNULL(B.TRANSPLANT,0)
WHERE b.HccCount IS NOT NULL
UNION
SELECT 

	A.MemberID,
	A.Model,
	A.MetalLevel,
	A.PaymentYear,
	B.Variable category
  

FROM #membership a
INNER JOIN #lookup_vw_ref_HHS_EnrolDuration_HCCCount b
	ON a.MODEL = b.MODEL and a.dis_count = b.HccCount
	AND  ISNULL(A.SEVERE,0) = ISNULL(B.SEVERE,0)
	 
WHERE b.HccCount IS NOT NULL
UNION
SELECT 

	A.MemberID,
	A.Model,
	A.MetalLevel,
	A.PaymentYear,
	B.Variable category
  

FROM #membership a
INNER JOIN #lookup_vw_ref_HHS_EnrolDuration_HCCCount b
	ON a.MODEL = b.MODEL and a.ENROlLDURATION = B.EnrollDuration
	 
WHERE b.EnrollDuration IS NOT NULL
)

SELECT MemberId,
 STRING_AGG(m.category, ', ') WITHIN GROUP (ORDER BY m.category) AS category,
 SUM(cast(l.Weight as numeric(19,4))) Factor
INTO #ref_HHS_HCCCount
FROM HccCountCTE m
LEFT JOIN  #lookup_vw_ref_HHS_Disease_Factor  l  
     ON  m.category = l.Category AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
GROUP BY memberid

 

UPDATE a
SET a.RAF_HCC_COUNT_ED_Interaction = b.Factor,
     
    a.ra_variable = ra_variable + ','+ B.category
FROM #membership a
INNER JOIN #ref_HHS_HCCCount b on a.MemberID=b.MemberID

--*************RXC Interaction*******************************
DROP TABLE IF EXISTS #ref_RXC_disease_interaction
;WITH my_cte AS (
   
	SELECT DISTINCT
        a.*,
		m.Model,
		m.MetalLevel,
        b.variable AS diseasecategory 
	   
    FROM #disease_detail a
	INNER JOIN #membership m on m.MemberID = a.memberId
	INNER JOIn  #RXC_Detail r on r.memberid = a.memberid
    CROSS Apply   (
        SELECT  [Variable]   
        FROM #lookup_vw_ref_HHS_disease_interaction b 
		outer apply STRING_SPLIT(b.[Category], ',') AS split_cat 
        WHERE 1=1
		and TRIM(LEADING '0' FROM split_cat.value) = a.Category
		and b.variable like 'RXC_'+FORMAT(CAST(RXC AS INT),'00')+'%'
    ) b
	 
     
)
 

SELECT DISTINCT 
    m.MemberID,
	 STRING_AGG(m.diseasecategory, ', ') WITHIN GROUP (ORDER BY diseasecategory) AS interactioncategory ,
    SUM(cast(l.Weight as numeric(19,4))) Factor	

INTO #ref_RXC_disease_interaction
FROM my_cte m
LEFT JOIN #lookup_vw_ref_HHS_Disease_Factor  l  
     ON  m.diseasecategory = l.Category AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
Group By memberId
 
UPDATE a
SET a.RAF_RXC_Interaction = b.Factor,    
    a.ra_variable = ra_variable + ', ' + interactioncategory 
FROM #membership a
INNER JOIN #ref_RXC_disease_interaction b
			ON a.MemberID = b.MemberID

-----------------------------------------------------------------------------------------------
----UPDATE disease interaction factor to the main table
--;WITH my_cte AS (
--    SELECT 
--        MemberID,
--        SUM(Factor) AS Factor,
--        COUNT(DISTINCT interactioncategory) AS DiseaseInteraction_Count,
--        STRING_AGG(interactioncategory, ', ') WITHIN GROUP (ORDER BY interactioncategory) AS interactioncategory
--    FROM #Disease_Interaction_detail_With_factor
--    GROUP BY MemberID
--)


---------------------------------------------------------------------------------------------
UPDATE a
SET A.RAF_TOTAL = A.RAF_DEMO + A.RAF_HCC + A.RAF_RXC  + A.RAF_HCC_Interaction + RAF_HCC_COUNT_ED_Interaction+RAF_RXC_Interaction
FROM #membership a

---------------------------------------------------------------------------------------------
--Apply CSR Adjustment
---------------------------------------------------------------------------------------------
 
UPDATE a
SET a.raf_total = a.raf_total * ISNULL(b.csr_Factor, 1)
FROM #membership a
LEFT JOIN #lookup_vw_ref_HHS_CSR_Adjustments b
    ON a.CSRIndicator = b.CSRIndicator
    AND a.MetalLevel = b.MetalLevel
    --AND a.Model = b.Model

-------------------------------------------------------------------------------------------------------------
 
	select 
		PaymentYear,
		MemberID,
		DOB_Org,
		DOB,
		Age,
		ISNULL(AgeBand,Age) AgeBand,
		Gender_Org,
		Gender,
		
		ISNULL(Model,'Unknown') Model ,
		MetalLevel,
		ISNULL(ra_variable,'') RA_VARIABLE,
		ROUND(raf_demo, 3, 1) AS RAF_DEMO,
		ROUND(RAF_HCC, 3, 1) AS RAF_HCC,
		ROUND(raf_rxc, 3, 1) AS RAF_RXC,
		ROUND(RAF_HCC_COUNT_ED_Interaction, 3, 1) AS RAF_HCC_COUNT_ED_Interaction,
		 ROUND(RAF_HCC_Interaction, 3, 1) AS RAF_HCC_Interaction ,
		ROUND(raf_RXC_Interaction, 3, 1) AS RAF_RXC_Interaction ,
	 
		ROUND(raf_total, 3, 1) AS RAF_TOTAL

	from 
		#membership
 

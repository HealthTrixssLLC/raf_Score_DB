/****** Object:  StoredProcedure [dbo].[sp_RS_Medicare_PartC_ESRD_Inner]    Script Date: 23-02-2025 22:34:35 ******/
  
 --select * from #membership
Create         procedure [dbo].[sp_RS_Medicare_PartC_ESRD_Inner](@PmtYear as int, @Membership as [Validated_InputMembership_PartC] READONLY, @DxTable as [InputDiagnosis_Inner] READONLY, @ClinicalVersion VARCHAR(20),@EngineType INT = 1  )
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
	Model = 'HCC Model-ESRD-Regular'
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
	Model like 'HCC Model-ESRD-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear
	--SELECT * FROM #lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor
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
	Model like 'HCC Model-ESRD-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 
	--select * from #lookup_vw_ref_Medicare_PartC_Disease_Factor
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
	Model like 'HCC Model-ESRD-Regular'
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
	Model like 'HCC Model-ESRD-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 

 --SELECT * FROM #lookup_vw_ref_Medicare_PartC_Disease_Group_Map
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
	Model like 'HCC Model-ESRD-Regular'
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
	Model like 'HCC Model-ESRD-Regular'
and
	ClinicalVersion=@ClinicalVersion
and
	PmtYear=@PmtYear 

 --SELECT * FROM #lookup_vw_ref_Medicare_PartC_Interaction_Map
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
	Model like 'HCC Model-ESRD-Regular'
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
	Model like 'HCC Model-ESRD-Regular'
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
	case when [dbo].[CalculateAge](case when m.BirthDate is null then getdate() else m.BirthDate end , CAST(cast(@PmtYear as VARCHAR(10))+'/02/01' as DATE))  >=65 then 1 else 0 end Aged,
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
	m.LTIMCAID_Org,
	--'n'
	m.LTIMCAID,
	 m.NEMCAID_Org NEMCAID_Org,
	m.NEMCAID NEMCAID,
	m.Hospice_org as Hospice_org,
	--case when ISNULL(m.Hospice,'') in ('Y','N') then m.Hospice else 'N' end as
	m.Hospice,

	CASE WHEN m.RAType LIKE 'I%' THEN 1 ELSE 0 END as LTI,

	CASE
		WHEN m.RAType IN ('C4','C7','D2','I4','I6','I9') THEN 1 
		WHEN m.RAType IN ('E1','E2','ED') AND m.NEMCAID = 'N' THEN 1 

		
		ELSE 0 END PBDUAL ,
	CASE
		WHEN m.RAType IN ('C3','C6','D1','I3','I5','I8') THEN 1 
		WHEN m.RAType IN ('E1','E2','ED') AND m.NEMCAID = 'Y' THEN 1 
		ELSE 0 END FBDUAL ,

	CASE
		WHEN m.RAType IN ('C3','C4','C5','E1','I5','I6','I7') THEN '4-9' 
		WHEN m.RAType IN ('C6','C7','C8','E2','I8','I9','IA') THEN '10+'
		WHEN m.RAType IN ('G1') THEN '1'
		WHEN m.RAType IN ('G2') THEN '2'
		ELSE '' END DURATION,
	m.OREC_org as OREC_org,
	--case when ISNULL(m.OREC,'') in (0,1,2,3) then m.OREC else 0 end as 
	m.OREC,
	'N' as OriginallyDisabled,
	'N' as OriginallyESRD,
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

--drop table if exists #Errormembership
--select distinct
--	@PmtYear as PmtYear,
--	m.MemberID,
--	m.BirthDate as BirthDate_org,
--	case when m.BirthDate is null then getdate() else m.BirthDate end as BirthDate,
--	[dbo].[CalculateAge](case when m.BirthDate is null then getdate() else m.BirthDate end , CAST(cast(@PmtYear as VARCHAR(10))+'/02/01' as DATE)) as Age,
--	case when [dbo].[CalculateAge](case when m.BirthDate is null then getdate() else m.BirthDate end , CAST(cast(@PmtYear as VARCHAR(10))+'/02/01' as DATE))  >=65 then 1 else 0 end Aged,
--	CAST('' as VARCHAR(20)) as AgeBand,
--	m.Gender as Gender_org,
--	case when m.Gender in ('M','F') then m.Gender else 'M' end as Gender,
--	M.RAType AS RAtype_org,
--    M.RAType AS RAType,
--    CASE 
--        WHEN R.AgedDisabled = 'Yes' AND [dbo].[CalculateAge](CASE WHEN m.BirthDate IS NULL THEN GETDATE() ELSE m.BirthDate END, CAST(CAST(@PmtYear AS VARCHAR(10)) + '/02/01' AS DATE)) < 65 THEN CONCAT(R.RAType_Engine, 'D')
--        WHEN R.AgedDisabled = 'Yes' AND [dbo].[CalculateAge](CASE WHEN m.BirthDate IS NULL THEN GETDATE() ELSE m.BirthDate END, CAST(CAST(@PmtYear AS VARCHAR(10)) + '/02/01' AS DATE)) >= 65 THEN CONCAT(R.RAType_Engine, 'A')
--        ELSE ISNULL(NULLIF(RAType_Engine, ''), m.RAType) END RAType_Engine,
--	--m.ESRD as ESRD_org,
--	--case when ISNULL(r.ESRD,'') in ('Yes') then 'Y' else 'N' end as ESRD,
--	m.LTIMCAID LTIMCAID_Org,
--	'N' LTIMCAID,
--	 m.NEMCAID NEMCAID_Org,
--	m.NEMCAID NEMCAID,
--	m.Hospice as Hospice_org,
--	case when ISNULL(m.Hospice,'') in ('Y','N') then m.Hospice else 'N' end as Hospice,

--	CASE WHEN m.RAType LIKE 'I%' THEN 1 ELSE 0 END as LTI,

--	CASE
--		WHEN m.RAType IN ('C4','C7','D2','I4','I6','I9') THEN 1 
--		WHEN m.RAType IN ('E1','E2','ED') AND m.NEMCAID = 'N' THEN 1 

		
--		ELSE 0 END PBDUAL ,
--	CASE
--		WHEN m.RAType IN ('C3','C6','D1','I3','I5','I8') THEN 1 
--		WHEN m.RAType IN ('E1','E2','ED') AND m.NEMCAID = 'Y' THEN 1 
--		ELSE 0 END FBDUAL ,

--	CASE
--		WHEN m.RAType IN ('C3','C4','C5','E1','I5','I6','I7') THEN '4-9' 
--		WHEN m.RAType IN ('C6','C7','C8','E2','I8','I9','IA') THEN '10+'
--		WHEN m.RAType IN ('G1') THEN '1'
--		WHEN m.RAType IN ('G2') THEN '2'
--		ELSE '' END DURATION,
--	m.OREC as OREC_org,
--	case when ISNULL(m.OREC,'') in (0,1,2,3) then m.OREC else 0 end as OREC,
--	'N' as OriginallyDisabled,
--	'N' as OriginallyESRD,
--	--cast('' as VARCHAR(500)) as dis_list_diagnosis,
--	cast('' as VARCHAR(500)) as dis_list_category,
--	cast('' as VARCHAR(500)) as dis_count,
--	cast('' as VARCHAR(500)) as dis_int_dis,
--	cast('' as VARCHAR(500)) as dis_int_disab,
--	cast('' as VARCHAR(500)) as ra_variable,
--	cast (0.00 as decimal(7,3)) as raf_demo,
--	cast (0.00 as decimal(7,3)) as raf_demo_status,
--	cast (0.00 as decimal(7,3)) as raf_dis,
--	cast (0.00 as decimal(7,3)) as raf_dis_count,
--	cast (0.00 as decimal(7,3)) as raf_dis_int_dis,
--	cast (0.00 as decimal(7,3)) as raf_dis_int_disab,
--	cast (0.00 as decimal(7,3)) as raf_total,
--	cast('' as VARCHAR(200)) as Model,
--	IsError,
--	[MessageCode]
--INTO #Errormembership
--FROM @M m
--LEFT JOIN [dbo].[vw_ref_Medicare_PartC_RATypeMapping] R ON m.RAType = r.RAType 
--WHERE R.PaymentYear = @PmtYear
--AND IsError=1
--select * from #membership
-------------------------------------------------------------------------------------------------------------
--*********************************************************************************************************--
--Correct Incorrect Input--START
--*********************************************************************************************************--
-------------------------------------------------------------------------------------------------------------
--Member must have OREC=1 and disabled=Y if they are less than 65 years old
-------------------------------------------------------------------------------------------------------------
--XX
--select * from #membership

--UPDATE a
--SET
--	a.OREC=2
--from 
--	#membership a
--where 
--	Age<65 and OREC=0
--AND  
--	RAType   IN ('GFN', 'GNPN', 'DI','GI')

--UPDATE a
--SET
--	a.OREC=2
--from 
--	#membership a
--where 
--	Age<65 AND OREC=0
--AND  
--	RAType   IN ('GFA', 'GFN', 'GNPA', 'GNPN','DI','GI')
-------------------------------------------------------------------------------------------------------------
--if Member is younger that 65, the member has to be disabled. i.e Right(RATYPE,1) should be A 
--and in this case OREC should be set to 1 as well. last part is already taken care above. 
-------------------------------------------------------------------------------------------------------------
--UPDATE A
--SET 
--	a.RATYPE=STUFF(RAType, Len(RAType), 1, 'D') 
--	--select *
--from 
--	#membership a
--where
--	age<65
--AND 
--   RAType   IN ('CF', 'CN', 'CP','INS')

--UPDATE A
--SET 
--	a.RATYPE=STUFF(RAType, Len(RAType), 1, 'N') 
--	--select *
--from 
--	#membership a
--where
--	age<65
--AND  
--	RAType   IN ('GFA', 'GFN', 'GNPA', 'GNPN')
-------------------------------------------------------------------------------------------------------------
--if Member is 65 or more the member cannot be disabled. i.e Right(RATYPE,1) should be A.- Change the RATYPE
-------------------------------------------------------------------------------------------------------------
--UPDATE A
--SET 
--	a.RATYPE=STUFF(RAType,  Len(RAType), 1, 'A') 
--from 
--	#membership a
--where
--	age>=65 and RIGHT(RAType,1)='D'
--AND 
--	RAType   IN ('CFA', 'CFD', 'CNA', 'CND', 'CPA', 'CPD')

----UPDATE A
----SET 
----	a.RATYPE=STUFF(RAType,  Len(RAType), 1, 'A') 
----from 
----	#membership a
----where
----	age>=65 and RIGHT(RAType,1)='N'
----AND 
----	RAType   IN ('GFA', 'GFN', 'GNPA', 'GNPN')
-------------------------------------------------------------------------------------------------------------
--If Disabled flag is N but the RAType indicates the member is disabled, we will priortize the RAType
--and update disability flag to Y
-------------------------------------------------------------------------------------------------------------
--UPDATE A
--SET 
--	Disabled='Y' 
--from 
--	#membership a
--where
--	RIGHT(RAType,1)='D'
--AND
--	Disabled='N'
--AND 
--	RAType   IN ('CFA', 'CFD', 'CNA', 'CND', 'CPA', 'CPD')

----UPDATE A
----SET 
----	ESRD='Y' 
----from 
----	#membership a
----where
----	1=1
----AND
----	ESRD='N'
----AND 
----	RAType   IN ('GFA', 'GFN', 'GNPA', 'GNPN','GI','DI')
-------------------------------------------------------------------------------------------------------------
--If Disabled flag is Y but the RAType indicates the member is NOT disabled, we will priortize the RAType
--and update disability flag to N
--UPDATE A
--SET 
--	Disabled='N' 
--from 
--	#membership a
--where
--	RIGHT(RAType,1)='A'
--AND
--	Disabled='Y' 
--AND 
--	RAType   IN ('CFA', 'CFD', 'CNA', 'CND', 'CPA', 'CPD')
-------------------------------------------------------------------------------------------------------------
--If Medicaid flag is N but the RAType indicates the member is Medicaid, we will priortize the RAType
--and update Medicaid flag to Y
-------------------------------------------------------------------------------------------------------------
--UPDATE A
--SET 
--	Medicaid='Y' 
--from 
--	#membership a
--where
--	 LEFT(RAType,2) in ('CF','CP')
--AND
--	Medicaid='N'
--AND 
--	RAType   IN ('CFA', 'CFD', 'CNA', 'CND', 'CPA', 'CPD')

--UPDATE A
--SET 
--	Medicaid='Y' 
--from 
--	#membership a
--where
--	 (LEFT(RAType,2) in ('GF') OR LEFT(RAType,3) in ('GNP'))
--AND
--	Medicaid='N'
--AND 
--	RAType   IN ('GFA', 'GFN', 'GNPA', 'GNPN','GI','DI')



-------------------------------------------------------------------------------------------------------------
--If Medicaid flag is Y but the RAType indicates the member is NOT Medicaid, we will priortize the RAType
--and update Medicaid flag to N
-------------------------------------------------------------------------------------------------------------
--UPDATE A
--SET 
--	Medicaid='N' 
--from 
--	#membership a
--where
--	 LEFT(RAType,2) not in ('CF','CP')
--AND
--	Medicaid='Y' 
--AND 
--	RAType   IN ('CFA', 'CFD', 'CNA', 'CND', 'CPA', 'CPD')

--UPDATE A
--SET 
--	Medicaid='N' 
--from 
--	#membership a
--where
--	(LEFT(RAType,2) not in ('GF') AND LEFT(RAType,3) not in ('GNP'))
--AND
--	Medicaid='Y' 
--AND 
--	RAType   IN ('GFA', 'GFN', 'GNPA', 'GNPN')

------------------------------------------------------------------------------------------------------------
--UPDATE A
--SET 
--	NEMCAID='N' 
--from 
--	#membership a
--where
--	 1=1
--AND
--	NEMCAID='Y' 
--AND 
--	RAType  NOT  IN ('DNE', 'GNE')

--UPDATE A
--SET 
--	LTIMCAID='N' 
--from 
--	#membership a
--where
--	 1=1
--AND
--	LTIMCAID='Y' 
--AND 
--	RAType  NOT  IN ('INS')
-------------------------------------------------------------------------------------------------------------
--UPDATE ORIG_DISABILITY only of member is has and then Age >=65
-------------------------------------------------------------------------------------------------------------
UPDATE A
SET 
	OriginallyESRD='Y' 
from 
	#membership a
where
	OREC in (2,3) AND AGE>=65
	AND  RAType   IN ('GFA', 'GNPA', 'DI','GI')

UPDATE A
SET 
	OriginallyDisabled='Y' 
from 
	#membership a
where
	OREC in (1,3) AND AGE>=65
	AND  RAType   IN ('GFA', 'GNPA', 'DI','GI','DNE','GNE')
-------------------------------------------------------------------------------------------------------------
--*********************************************************************************************************--
--Correct Incorrect Input--END
--*********************************************************************************************************--
-------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------
--*********************************************************************************************************--
--Apply Demographic Factor Based on Age and Sex
--*********************************************************************************************************--
-------------------------------------------------------------------------------------------------------------
UPDATE a
set 
	a.raf_demo=ISNULL(b.Factor,0),
	a.AgeBand=b.AgeBand,
	a.ra_variable=b.Variable
--select 	a.*, 	b.Variable,Factor
from 
	#membership a
LEFT JOIN
	#lookup_vw_ref_Medicare_PartC_Demographic_Factor b
ON
	a.Gender=b.Gender
ANd
	b.RAType = a.RAType_Engine 
AND
	a.Age between Age_Start and Age_End
AND A.Hospice = 'N'
--*********************************************************************************************************--
--Apply Demographic Status Factor Based on Transplant -
--*********************************************************************************************************--
-------------------------------------------------------------------------------------------------------------
UPDATE a
set 
	a.raf_demo_status=b.Factor,
	a.ra_variable= 'TRANSPLANT',
	a.AgeBand=b.AgeBand
from 
	#membership a
JOIN
	#lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b
ON b.RAType = a.RAType_Engine 
	AND B.DURATION = A.DURATION
where 1=1
	 
AND
	a.RAType_Engine = 'TRANSPLANT'
AND A.Hospice = 'N'
-------------------------------------------------------------------------------------------------------------
--*********************************************************************************************************--
--Apply Demographic Status  Factor Based on Original ESRD -
--*********************************************************************************************************--
-------------------------------------------------------------------------------------------------------------
UPDATE a
set 
	a.raf_demo_status=b.Factor,
	a.ra_variable=ISNULL(ra_variable,'') +', '+b.Variable--+'-ORIGINALLY_DISABLED',
	--a.AgeBand=b.AgeBand
--select 	a.*, 	b.Variable, b.Factor
from 
	#membership a
JOIN
	#lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b
ON
	b.RAType = a.RAType_Engine 
AND
	a.OriginallyESRD=b.OriginallyESRD
where
	a.OriginallyESRD='Y'
AND 
	(
		(  ISNULL(a.Gender,'')=ISNULL(b.Gender,'') )
	)
AND A.Hospice = 'N'
--*********************************************************************************************************--
--Apply Demographic Status  Factor Based on Original Disability -
--*********************************************************************************************************--
-------------------------------------------------------------------------------------------------------------
UPDATE a
set 
	a.raf_demo_status=a.raf_demo_status+b.Factor,
	a.ra_variable=ISNULL(ra_variable,'') +', '+b.Variable--+'-ORIGINALLY_DISABLED',
	--a.AgeBand=b.AgeBand
--select 	a.*, 	b.Variable, b.Factor
from 
	#membership a
JOIN
	#lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b
ON
	b.RAType = a.RAType_Engine 
AND
	a.OriginallyDisabled=b.OriginallyDisabled
where
	a.OriginallyDisabled='Y'
AND 
	(
		( ISNULL(a.Gender,'')=ISNULL(b.Gender,'') )
	)
AND a.RAType_Engine NOT IN ('DNE','GNE')
AND A.Hospice = 'N'

--***********New Enrollee+
UPDATE a
set 
	a.raf_demo_status=b.Factor,
	a.ra_variable= b.Variable,
	a.AgeBand=b.AgeBand
--select 	a.*, 	b.*
from 
	#membership a
JOIN --select * from 
	#lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b
ON
	ISNULL(a.Gender,'')=ISNULL(b.Gender,'')
ANd
	b.RAType = a.RAType_Engine 
AND
	a.Age between Age_Start and Age_End
AND
	a.PBDual = b.PBDual
AND
	a.FBDual = b.FBDual
AND
	a.OriginallyDisabled=b.OriginallyDisabled
WHERE  1=1
	--b.Variable like '%MCAID%ORIGDIS%'
AND  
	b.RAtype IN ('DNE','GNE')
AND A.Hospice = 'N'

--*********************************************************************************************************--
--Apply Demographic Status  Factor Based related to FGC \FGI
--*********************************************************************************************************--
-------------------------------------------------------------------------------------------------------------
UPDATE a
set 
	a.raf_demo_status=ISNULL(a.raf_demo_status,0)+(b.Factor),
	a.ra_variable=ISNULL(ra_variable,'') +', '+b.Variable--+'-ORIGINALLY_DISABLED',
--	a.AgeBand=b.AgeBand
--select 	a.*, 	b.*
from 
	#membership a
JOIN  
	#lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b   
ON
	b.PBDual = a.PBDual 
AND
	a.FBDual = b.FBDual
where
	a.Duration=b.Duration
AND 
	a.aged = b.aged
AND A.Hospice = 'N'
AND 
(
	(b.RAType = 'FGC' AND  a.RAType_Engine   IN ('GFA', 'GNPA','GFN', 'GNPN'))
	OR
	(b.RAType = 'FGI' AND  a.RAType_Engine   IN ('GI'))
	OR
	(b.RAType = 'DI' AND  a.RAType_Engine   IN ('DI') AND a.RAtype_org NOT IN ('I3','I4'))
)

--*********************************************************************************************************--
--Apply Demographic Status  Factor Based related to LTI
--*********************************************************************************************************--
-------------------------------------------------------------------------------------------------------------
UPDATE a
set 
	a.raf_demo_status=a.raf_demo_status+b.Factor,
	a.ra_variable=ISNULL(ra_variable,'') +', '+b.Variable--+'-ORIGINALLY_DISABLED',
--	a.AgeBand=b.AgeBand
--select 	a.*, 	b.*
from 
	#membership a
JOIN  
	#lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b   
ON
	a.aged = b.aged
where
	 
	A.Hospice = 'N'
AND
	b.Variable LIKE '%LTI%'
AND 
	(
		(b.RAType = 'LTI' AND a.RAType_Engine = 'GI' )
		OR
		(b.RAType = 'DI' AND a.RAType_Engine = 'DI' AND a.RAtype_org IN ('I3','I4')  )

	)
	--select * from #lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor
-------------------------------------------------------------------------------------------------------------
 


--***********New Enrollee+adjustment
--UPDATE a
--set 
--	a.raf_demo_status=a.raf_demo_status+b.Factor,
--	a.ra_variable= a.ra_variable+','+b.Variable,
--	a.AgeBand=b.AgeBand
----select 	a.*, 	b.*
--from 
--	#membership a
--JOIN --select * from 
--	#lookup_vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor b
--ON	 
--	a.Duration=b.Duration
 
--WHERE 1=1
 
--AND  
--	a.RAtype IN ('GNE') AND b.RaType = 'ActAdj'
--AND A.Hospice = 'N'

-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
--APPLICATION OF DISEASE FACTOR
--***********************************************************************************************************
-------------------------------------------------------------------------------------------------------------
--Get Disease level list
-------------------------------------------------------------------------------------------------------------
drop table if exists #disease_detail
-------------------------------------------------------------------------------------------------------------
select distinct 
	d.MemberID,
	d.FromDos,
	d.ThruDos,
	d.QualificationFlag,
	d.UnqualificationReason,
	d.DxCode,
	l.Category,
	l.ClinicalVersion
into
	#disease_detail
from 
	@d d
JOIN
	#lookup_ICDMapping l
On
	d.DxCode=l.DxCode
--where
--	(@EngineType = 2 AND YEAR(d.ThruDOS)<=@dosyear)
--	OR 
--	(@EngineType = 1 AND YEAR(d.ThruDOS)=@dosyear)

	--select * from #disease_detail
-------------------------------------------------------------------------------------------------------------
--delete lower hierarcy when upper hierarchy is present
-------------------------------------------------------------------------------------------------------------
delete b
--select a.MemberID, a.Category, b.Category 
from 
	#disease_detail a
JOIN
	#disease_detail b
ON
	a.MemberID=b.MemberID
JOIN	
	#lookup_vw_ref_Medicare_PartC_Hierarchy c
ON
	a.Category=c.category
ANd
	b.Category=c.categoryoverride
-------------------------------------------------------------------------------------------------------------
--Map Category to Disease Category Factor, and obtain a member level csv list and member level factor
-------------------------------------------------------------------------------------------------------------
drop table if exists #disease_detail_With_factor;

with my_cte as
(
	select 
		a.*,b.RAType_Engine RAType, l.Factor,l.Variable
	from 
		#disease_detail a
	JOIN
		#membership b
	ON
		a.MemberID=b.MemberID
	LEFT join

		#lookup_vw_ref_Medicare_PartC_Disease_Factor l
	on
		a.Category=l.Category
	AND	
		l.RAType = b.RAType_Engine 
)
SELECT 
    MemberID,
	SUM(Factor) as Factor,
	Count(distinct Category) as DiseaseCount,
    STRING_AGG(Category, ', ') WITHIN GROUP (ORDER BY CAST(REPLACE(Category,'HCC','') as NUMERIC(19,4))) AS Categories
into 	
	#disease_detail_With_factor
FROM 
    my_cte
GROUP BY 
    MemberID
--select * from #disease_detail_With_factor
-------------------------------------------------------------------------------------------------------------
--Update Factor to main result table
-------------------------------------------------------------------------------------------------------------
UPDATE a
SET
	a.raf_dis=isnull(b.Factor,0),
	a.dis_list_category=b.Categories,
	a.dis_count='D'+case when b.DiseaseCount>=10 then '10P' else cast(b.DiseaseCount as VARCHAR(5)) end,
	a.ra_variable=ra_variable+', ' + b.Categories
FROM
	#membership a
JOIN
	#disease_detail_With_factor b
ON
	a.MemberID=b.MemberID
AND A.Hospice = 'N'
and a.RAType_Engine NOT IN ( 'Transplant','DNE','GNE','NE','SNPNE')
	
-------------------------------------------------------------------------------------------------------------
--***********************************************************************************************************
--APPLICATION OF DISEASE COUNT FACTOR
--***********************************************************************************************************
-------------------------------------------------------------------------------------------------------------
--UPDATE a
--SET
--	a.raf_dis_count=b.factor,
--	a.dis_count=case when b.factor=0 then '' else dis_count end,
--	a.ra_variable=ra_variable+ case when b.factor=0 then '' else ', DISEASE COUNT '+dis_count end
----select a.*, b.*
--from 
--	#membership a
--JOIN
--	#lookup_vw_ref_Medicare_PartC_Disease_Count_Factor b
--ON
--	a.dis_count=b.DiseaseCountCategory
--AND
--	b.RAType = a.RAType 
--AND A.Hospice = 'N'
-------------------------------------------------------------------------------------------------------------
--Obtain Disease Interaction; (don't worry about RATYPE)
-------------------------------------------------------------------------------------------------------------
drop table if exists #Disease_Interaction_detail_With_factor
--
;with my_cte as
(
SELECT 
	a.*,
	ISNULL(b.diseasecategory,a.Category)  as  diseasecategory,
	c.Interactionvariable,
	c.interactioncategory
 	
FROM 
	#disease_detail a
LEFT JOIN 
	#lookup_vw_ref_Medicare_PartC_Disease_Group_Map b
ON
	a.Category=b.HCC
LEFT JOIN
	(select * from #lookup_vw_ref_Medicare_PartC_Interaction_Map  where interactioncategory not like 'Disabled%' and interactioncategory not like 'nonaged%' ) c
ON
	ISNULL(b.diseasecategory,a.Category)  =c.Interactionvariable
UNION 
SELECT 
	a.*,
	a.Category  diseasecategory,
	c.Interactionvariable,
	c.interactioncategory
 	
from 
	#disease_detail a
 LEFT JOIN
	(select * from #lookup_vw_ref_Medicare_PartC_Interaction_Map  where interactioncategory not like 'Disabled%' and interactioncategory not like 'nonaged%' ) c
ON
	 a.Category =c.Interactionvariable
)
 
select distinct 
	m.MemberID,
	m.interactioncategory,
	n.ratype,
	n.Factor
into
	#Disease_Interaction_detail_With_factor
from 
	my_cte m
LEFT JOIN  
	#lookup_vw_ref_Medicare_PartC_Disease_Interaction_Factor n
ON
	m.interactioncategory=n.Interaction
where 
	MemberID+interactioncategory in 
(
	select MemberID+ ISNULL(interactioncategory,'') from my_cte
	GROUP BY MemberID+ISNULL(interactioncategory,'')
	HAVING COUNT(distinct Interactionvariable)>1
)

--select * from #Disease_Interaction_detail_With_factor
-------------------------------------------------------------------------------------------------------------
--UPDATE disease interaction factor to the main table by matching on RATYPE
-------------------------------------------------------------------------------------------------------------
;with my_cte as
(SELECT 
    MemberID,
	ratype,
	SUM(Factor) as Factor,
	Count(distinct interactioncategory) as DiseaseInteraction_Count,
    STRING_AGG(interactioncategory, ', ') WITHIN GROUP (ORDER BY interactioncategory) AS interactioncategory
FROM 
    #Disease_Interaction_detail_With_factor
GROUP BY 
    MemberID,
	ratype
)

UPDATE a
SET
	a.dis_int_dis=b.interactioncategory,
	a.raf_dis_int_dis=b.Factor,
	a.ra_variable=ra_variable+', '+interactioncategory
FROM
	#membership a
JOIN
	my_cte b
ON
	a.MemberID=b.MemberID
AND
	a.RAType_Engine=b.ratype
AND A.Hospice = 'N'
-------------------------------------------------------------------------------------------------------------
--OBTAIN DISABLED DISEASE INTERACTION
-------------------------------------------------------------------------------------------------------------
drop table if exists #disabled_disease_Interaction
--
;with my_cte as
(
select 
	a.*,
	ISNULL(b.diseasecategory,a.Category) as  diseasecategory,
	c.Interactionvariable,
	c.interactioncategory
--SELECT *	 
FROM 
	#disease_detail a
JOIN
	#lookup_vw_ref_Medicare_PartC_Disease_Group_Map b
ON
	a.Category=b.HCC
INNER JOIN
	(select * from #lookup_vw_ref_Medicare_PartC_Interaction_Map  where interactioncategory like 'DISABLED%'  ) c
ON
	--ISNULL(b.diseasecategory,a.Category)=c.Interactionvariable
	a.Category=c.Interactionvariable
)

select distinct 
	a.MemberId, 
	b.RAType_Engine RAType,
	--'DISABLED_'+a.Interactionvariable  as 
	interactioncategory,	
	c.Factor
into
	#disabled_disease_Interaction
--select * 
from 
	my_cte a
INNER JOIN
	#membership b
ON
	a.MemberID=b.MemberID
INNER JOIN
	#lookup_vw_ref_Medicare_PartC_Disease_Disability_Factor c
ON
	'DISABLED_'+a.Interactionvariable=c.Interaction
AND	
	c.RAType = b.RAType_Engine 
	

-------------------------------------------------------------------------------------------------------------
--OBTAIN DISABLED DISEASE INTERACTION
-------------------------------------------------------------------------------------------------------------
drop table if exists #NonAged_disease_Interaction
--
;with my_cte_NA as
(
select 
	a.*,
	a.Category as  diseasecategory,
	c.Interactionvariable,
	c.interactioncategory 
	 
from 
	#disease_detail a
 
Inner JOIN
	(select * from #lookup_vw_ref_Medicare_PartC_Interaction_Map  where   interactioncategory like '%NonAged%' ) c
ON
	a.Category =c.Interactionvariable
UNION
select 
	a.*,
	a.Category as  diseasecategory,
	c.Interactionvariable,
	c.interactioncategory 
--select *	 
from 
	#disease_detail a
INNER JOIN
	 #lookup_vw_ref_Medicare_PartC_Disease_Group_Map b  
on b.HCC = a.Category
INNER JOIN
	(select * from #lookup_vw_ref_Medicare_PartC_Interaction_Map  ) d
ON
	b.diseaseCategory =d.Interactionvariable	
INNER JOIN
	(select * from #lookup_vw_ref_Medicare_PartC_Interaction_Map  where   interactioncategory like '%NonAged%' ) c
ON
	d.interactioncategory =c.Interactionvariable
UNION
select 
	a.*,
	a.Category as  diseasecategory,
	c.Interactionvariable,
	c.interactioncategory 
--select *	 
from 
	#disease_detail a
INNER JOIN
	 #lookup_vw_ref_Medicare_PartC_Disease_Group_Map b  
on b.HCC = a.Category
INNER JOIN
	(select * from #lookup_vw_ref_Medicare_PartC_Interaction_Map  ) d
ON
	b.diseaseCategory =d.Interactionvariable	
INNER JOIN
	(select * from #lookup_vw_ref_Medicare_PartC_Interaction_Map  where   interactioncategory like '%NonAged%' ) c
ON
	d.Interactionvariable =c.Interactionvariable
 
 
)
  
select distinct 
	a.MemberId, 
	b.RAType_Engine RAType,
	a.interactioncategory,	
	c.Factor Factor
into
	#NonAged_disease_Interaction
from 
	my_cte_NA a
JOIN
	#membership b
ON
	a.MemberID=b.MemberID
JOIN --select * from 
	#lookup_vw_ref_Medicare_PartC_Disease_Disability_Factor c
ON
	a.interactioncategory=c.Interaction
AND	
	c.RAType = b.RAType_Engine 
 Where b.Age < 65

 --select * from #NonAged_disease_Interaction
-------------------------------------------------------------------------------------------------------------
;with my_cte3 as
(
	SELECT 
		MemberID,
		ratype,
		SUM(Factor) as Factor,
		Count(distinct interactioncategory) as DiseaseInteraction_Count,
		STRING_AGG(interactioncategory, ', ') WITHIN GROUP (ORDER BY interactioncategory) AS interactioncategory
	FROM 
		#disabled_disease_Interaction
	GROUP BY 
		MemberID,
		ratype
)

UPDATE a
SET
	a.dis_int_disab=b.interactioncategory,
	a.raf_dis_int_disab=b.Factor,
	a.ra_variable=ra_variable+', '+interactioncategory
FROM
	#membership a
JOIN
	my_cte3 b
ON
	a.MemberID=b.MemberID
AND
	a.RAType_Engine=b.RAType
AND A.Hospice = 'N'
-----------------------------------------------------------------------------------------------------------
;with my_cte4 as
(
	SELECT 
		MemberID,
		ratype,
		SUM(Factor) as Factor,
		Count(distinct interactioncategory) as DiseaseInteraction_Count,
		STRING_AGG(interactioncategory, ', ') WITHIN GROUP (ORDER BY interactioncategory) AS interactioncategory
	FROM 
		#NonAged_disease_Interaction
	GROUP BY 
		MemberID,
		ratype
)

UPDATE a
SET
	a.dis_int_disab=b.interactioncategory,
	a.raf_dis_int_disab=b.Factor,
	a.ra_variable=ra_variable+', '+interactioncategory
FROM
	#membership a
JOIN
	my_cte4 b
ON
	a.MemberID=b.MemberID
AND
	a.RAType_Engine=b.RAType
AND A.Hospice = 'N'
-------------------------------------------------------------------------------------------------------------
--SET @Model=(select distinct Model from [MasterReferenceDB].[dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
--where PmtYear=@PmtYear and ClinicalVersion=@ClinicalVersion -- and Model like 'HCC Model-ESRD-Regular')
-------------------------------------------------------------------------------------------------------------
UPDATE a
SET
	a.Model=case --when a.RAtype IN ('CFA', 'CNA', 'CPA','NE','SNPNE','CFD', 'CND', 'CPD','INS') and  m.Model like 'HCC Model-ESRD-Regular' then m.model 
				  when a.RAType_Engine IN ('GFA', 'GFN', 'GNPA', 'GNPN','GI','DI','DNE','GNE','Transplant') and  m.Model like '%ESRD%' then m.model 	
				  Else 'Unknown' end	,
	a.raf_total=a.raf_demo+a.raf_demo_status+a.raf_dis+a.raf_dis_count+a.raf_dis_int_dis+a.raf_dis_int_disab
FROM
	#membership a
	outer Apply (select distinct Model from [MasterReferenceDB].[dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
where PmtYear=@PmtYear and ClinicalVersion=@ClinicalVersion  and model not like '%pace%') m
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
	OriginallyESRD,
	ISNULL(ra_variable,'') ra_variable,
	ROUND(raf_demo, 3, 1) raf_demo,
	ROUND(raf_demo_status, 3, 1) raf_demo_status,
	ROUND(raf_dis, 3, 1) raf_dis,
	ROUND(raf_dis_count, 3, 1) raf_dis_count,
	ROUND(raf_dis_int_dis, 3, 1) raf_dis_int_dis,
	ROUND(raf_dis_int_disab, 3, 1) raf_dis_int_disab,
	ROUND(raf_total, 3, 1) raf_total,
	ISNULL(Model,'Unknown') Model,
	@ClinicalVersion  as ClinicalVersion ,
		
	[MessageCode],
	IsError
from 
	#membership
--UNION
--select 
--	PmtYear,
--	MemberID,
--	BirthDate_Org,
--	BirthDate,
--	Age,
--	ISNULL(AgeBand,Age) AgeBand,
--	Gender_Org,
--	Gender,
--	RAType_Org,
--	RAType,
--	ISNULL(RAType_Engine, RAType_Org) AS RAType_Engine,
--	Hospice_Org,
--	Hospice,
--	LTIMCAID_Org,
--	LTIMCAID,
--	 NEMCAID_Org,
--	NEMCAID,
--	OREC_Org,
--	OREC,
--	OriginallyDisabled,
--	OriginallyESRD,
--	ISNULL(ra_variable,'') ra_variable,
--	raf_demo,
--	raf_demo_status,
--	raf_dis,
--	raf_dis_count,
--	raf_dis_int_dis,
--	raf_dis_int_disab,
--	raf_total,
--	ISNULL(Model,'Unknown') Model,
--	@ClinicalVersion  as ClinicalVersion ,
		
--	[MessageCode],
--	IsError
--from 
--	#Errormembership
END
ELSE IF @ENGINEType = 2
BEGIN
	SELECT 
		m.PmtYear,
		m.MemberID,
		d.FromDOS,
		d.ThruDOS,
		d.DxCode ICD,
		ISNULL(l.Factor,0) CategoryFactor,	
		d.Category,			
		@ClinicalVersion  as ClinicalVersion ,		
		m.Model,
		l.ModelDescription,
		d.QualificationFlag,
		d.UnqualificationReason,
		
	m.[MessageCode],
	m.IsError
	FROM  #membership m
	LEFT JOIN  #disease_detail d  ON m.MemberID = d.MemberID
	LEFT JOIN #lookup_vw_ref_Medicare_PartC_Disease_Factor l
				ON d.Category=l.Category
					AND	 l.RAType = m.RAType_Engine 
					AND	 l.PmtYear = m.PmtYear 
					AND	 l.ClinicalVersion = @ClinicalVersion
END

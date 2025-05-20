
 
CREATE   PROCEDURE [dbo].[sp_RS_HHS_Inner](@PaymentYear as int, @Membership as [Validated_InputMembership_HHS] READONLY, @DxTable as [InputDiagnosis_HHS] READONLY,@NDC [InputNDC_HHS] READONLY ,@HCPCS [InputHCPCS_HHS] READONLY)
AS
--DECLARE 
--	@PaymentYear as int=2024,

--	@Membership as [Validated_InputMembership_HHS] , 
--	@DxTable as [InputDiagnosis_HHS] ,
--	@NDC as [InputNDC_HHS] ,
--	@HCPCS as [InputHCPCS_HHS] 
  

 
--insert into @Membership
--select 'M00912',	'M',		'2023-03-13',	'1',	'Gold',		2,12,0,''
--UNION 
--SELECT 'M00913',	'M',		'2023-03-13',	'1',	'catastrophic',		1,12,0,''
--UNION 
--SELECT 'M00914',	'F',		'2024-03-13',	'0',	'Platinum',		1,12,0,''
--UNION 
--select 'M00915',	'M',		'2024-03-13',	'0',	'Silver',		2,12,0,''
--UNION 
--SELECT 'M00916',	'F',		'2023-03-13',	'1',	'Bronze',		1,12,0,''
----UNION 
----SELECT 'M00917',	'F',		'1930-06-16',	'95',	'Platinum',		1,12,0,''
----UNION 
----select 'M00918',	'M',		'1985-10-13',	'40',	'Silver',		2,12,0,''
----UNION 
----SELECT 'M00919',	'F',		'1985-06-16',	'50',	'catastrophic',		1,12,0,''
----UNION 
----SELECT 'M00911',	'M',		'1930-06-16',	'95',	'Silver',		1,12,0,''

--INSERT INTO @DxTable
--		SELECT 'M00912', 'N186', '2024-06-03'  -- HCC 184: ESRD				      Severe 5
--UNION SELECT 'M00912', 'A419', '2024-06-03' -- HCC 2: Septicemia				Severe 4
--UNION SELECT 'M00912', 'B20', '2024-06-03'  -- HCC 1: HIV/AIDS					Severe 3
--UNION SELECT 'M00912', 'A879', '2024-06-03' -- HCC 4: Viral Meningitis			Severe 2
--UNION SELECT 'M00912', 'D561', '2024-06-03'  -- HCC 71: Thalassemia				Severe 1

--UNION SELECT 'M00912', 'P0701', '2024-06-03'  -- HCC 242: Immature Newborn <500g		IHCC_EXTREMELY_IMMATURE
--UNION SELECT 'M00912', 'P0715', '2024-06-03'  -- HCC 245: Premature Newborn 1000-1499g	IHCC_IMMATURE
--UNION SELECT 'M00912', 'P0735', '2024-06-03'  -- HCC 247: Premature Newborn 2000-2499g	IHCC_PREMATURE_MULTIPLES
--UNION SELECT 'M00912', 'Z3800', '2024-06-03'  -- HCC 249: Term Newborn					IHCC_TERM 


--UNION SELECT 'M00913', 'A419', '2024-06-03' -- HCC 2: Septicemia				Severe 4
--UNION SELECT 'M00913', 'B20', '2024-06-03'  -- HCC 1: HIV/AIDS					Severe 3
--UNION SELECT 'M00913', 'A879', '2024-06-03' -- HCC 4: Viral Meningitis			Severe 2
--UNION SELECT 'M00913', 'D561', '2024-06-03'  -- HCC 71: Thalassemia				Severe 1

--UNION SELECT 'M00913', 'P0701', '2024-06-03'  -- HCC 242: Immature Newborn <500g		IHCC_EXTREMELY_IMMATURE
--UNION SELECT 'M00913', 'P0715', '2024-06-03'  -- HCC 245: Premature Newborn 1000-1499g	IHCC_IMMATURE
--UNION SELECT 'M00913', 'P0735', '2024-06-03'  -- HCC 247: Premature Newborn 2000-2499g	IHCC_PREMATURE_MULTIPLES
--UNION SELECT 'M00913', 'Z3800', '2024-06-03'  -- HCC 249: Term Newborn					IHCC_TERM 
 
--UNION SELECT 'M00914', 'B20', '2024-06-03'  -- HCC 1: HIV/AIDS					Severe 3
--UNION SELECT 'M00914', 'A879', '2024-06-03' -- HCC 4: Viral Meningitis			Severe 2
--UNION SELECT 'M00914', 'D561', '2024-06-03'  -- HCC 71: Thalassemia				Severe 1
 
--UNION SELECT 'M00914', 'P0715', '2024-06-03'  -- HCC 245: Premature Newborn 1000-1499g	IHCC_IMMATURE
--UNION SELECT 'M00914', 'P0735', '2024-06-03'  -- HCC 247: Premature Newborn 2000-2499g	IHCC_PREMATURE_MULTIPLES
--UNION SELECT 'M00914', 'Z3800', '2024-06-03'  -- HCC 249: Term Newborn					IHCC_TERM 

--UNION SELECT 'M00915', 'A879', '2024-06-03' -- HCC 4: Viral Meningitis			Severe 2
--UNION SELECT 'M00915', 'D561', '2024-06-03'  -- HCC 71: Thalassemia				Severe 1
 
--UNION SELECT 'M00915', 'P0735', '2024-06-03'  -- HCC 247: Premature Newborn 2000-2499g	IHCC_PREMATURE_MULTIPLES
--UNION SELECT 'M00915', 'Z3800', '2024-06-03'  -- HCC 249: Term Newborn					IHCC_TERM 

--UNION SELECT 'M00916', 'D561', '2024-06-03'  -- HCC 71: Thalassemia				Severe 1

--UNION SELECT 'M00916', 'Z3800', '2024-06-03'  -- HCC 249: Term Newborn					IHCC_TERM 
----insert into @NDC
----select		 'M00912','00597004660'  
----UNION select 'M00913','00597004660'  
----UNION select 'M00914','00597004660'  
----UNION select 'M00914','00003196601' 
----insert into @HCPCS
----select		 'M00912','J0741'  
----UNION select 'M00913','J0741'  
----UNION select 'M00914','J0741'  

DECLARE @Dosyear AS INT=@PaymentYear 
DECLARE @Model as VARCHAR(200)
---------------------------------------------------------------------------------------------
--Prepare Lookups
---------------------------------------------------------------------------------------------
--ICD Mapping
DROP TABLE IF EXISTS #lookup_ICDMapping
select * 
into 
	#lookup_ICDMapping 
from 
	[dbo].[vw_ref_HHS_ICD_Category_Mapping]
where 
	PaymentYear=@PaymentYear

--delete from #lookup_ICDMapping where category = 0 -- Need to delete later 
---------------------------------------------------------------------------------------------
--CSR adjustment factors
DROP TABLE IF EXISTS #lookup_vw_ref_HHS_CSR_Adjustments
SELECT * 
INTO 
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
	[dbo].vw_ref_HHS_Adult_Child_EnrolDuration_HCCCount
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

drop table if exists #lookup_vw_ref_HHS_RXC_HCPCS
select * 
into
	#lookup_vw_ref_HHS_RXC_HCPCS
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
	[dbo].vw_ref_HHS_Adult_Child_Variables
where 1=1
AND
	PaymentYear=@PaymentYear
	
--*******************************************
drop table if exists #lookup_vw_ref_HHS_Infant_Severity_Interactions

select * 
into
	#lookup_vw_ref_HHS_Infant_Severity_Interactions
FROM 
	[dbo].vw_ref_HHS_Infant_Variables
where 1=1
AND
	PaymentYear=@PaymentYear

--*********************************************************************************************

Declare @M as [Validated_InputMembership_HHS] 
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
	CAST([MetalLevel] AS VARCHAR(500)) [MetalLevel],
	CSRIndicator,
	EnrollDuration,
	0 Severe,
	0 Transplant,
	cast('' as VARCHAR(500)) as dis_list_category,
	cast('' as VARCHAR(500)) as dis_count,
	cast('' as VARCHAR(500)) as dis_int_dis,
	cast('' as VARCHAR(8000)) as  ra_variable,
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
	CAST(l.Category AS VARCHAR) Category,
	[dbo].[CalculateAge](m.DOB , CAST(d.ServiceDate as DATE)) Age_ServiceDate
INTO #disease_detail
FROM @d d
INNER JOIN @M m On d.MemberID = M.MemberID
INNER JOIN #lookup_ICDMapping l
			ON d.DxCode = l.DxCode
WHERE ServiceDate BETWEEN DXCodeStartDate and DXCodeEndDate
AND
	[dbo].[CalculateAge](m.DOB , CAST(d.ServiceDate as DATE)) BETWEEN l.FYStartAge and FYEndAge
AND
	[dbo].[CalculateAge](m.DOB , CAST(d.ServiceDate as DATE)) BETWEEN l.CYStartAge and CYEndAge
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
		DISTINCT 
        a.MemberID,
		A.Category,
		CAST(l.Weight AS DECIMAL(37,18)) Weight, 
		l.Variable
    FROM 
		#disease_detail a
    INNER JOIN #lookup_vw_ref_HHS_Disease_Factor l
		ON a.Category =  LTRIM(REPLACE(l.Category, 'HCC', '')  ,'0')
	INNER JOIN 
		#membership M ON M.MemberID = a.MemberID AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
	where l.Category like ('HCC%')
)
 
SELECT 
    MemberID,
    SUM(Weight) AS Weight,
    COUNT(DISTINCT Category) AS DiseaseCount,
   -- STRING_AGG(CONCAT('HCC',format(CAST(Category AS INT),'000')), ', ') WITHIN GROUP (ORDER BY CategorY) AS Categories
   STRING_AGG(CONCAT('HCC',Category), ', ') WITHIN GROUP (ORDER BY CategorY) AS Categories
INTO #disease_detail_With_factor
FROM my_cte
GROUP BY MemberID
  
---------------------------------------------------------------------------------------------
--Update Factor to main result table
UPDATE a
SET a.RAF_HCC = ISNULL(b.Weight, 0),
    a.DIS_LIST_CATEGORY = b.Categories,
   -- a.DIS_COUNT =   b.DiseaseCount ,
    a.RA_VARIABLE = RA_VARIABLE + ', ' + b.Categories
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
	--d.ndc,
	CAST(l.Rxc AS VARCHAR) Rxc
INTO #RXC_detail
FROM @n d
LEFT JOIN #lookup_vw_ref_HHS_RXC_NDC l on  d.ndc = l.ndc
 
UNION
SELECT DISTINCT 
    H.MemberID,		
	--d.ndc,
	CAST(lH.Rxc AS VARCHAR) Rxc
 
FROM  @h h 
LEFT JOIN #lookup_vw_ref_HHS_RXC_HCPCS LH on lH.HCPCS =h.HCPCS
 
 
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
    SELECT Distinct 
        a.MemberID,
		CONCAT('RXC_',RIGHT('00'+Category ,2)) Rxc , 
		CAST(l.Weight AS DECIMAL(37,18)) Weight, 
		l.Variable
    FROM 
		#RXC_detail a
    INNER JOIN #lookup_vw_ref_HHS_Disease_Factor l
		ON CONCAT('RXC_',RIGHT('00'+a.Rxc ,2)) = l.category --cast(replace(l.category ,'RXC_','') as int)
	INNER JOIN 
		#membership M ON M.MemberID = a.MemberID AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
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
 
SELECT DISTINCT
    a.MemberID,
	a.Category,
	m.Model,
	m.MetalLevel,
    b.variable AS diseasecategory
INTO #ref_HHS_disease_interaction   	  
FROM #disease_detail a
INNER JOIN #membership m on m.MemberID = a.MemberID
OUTER APPLY   (
    SELECT  [Variable], Severe,Transplant
    FROM #lookup_vw_ref_HHS_disease_interaction b 
	CROSS apply STRING_SPLIT(b.[Category], ',') AS split_cat 
    WHERE TRIM(split_cat.value) = FORMAT(CAST(REPLACE(a.Category,'_','.') AS NUMERIC),'000')
		AND   b.variable NOT LIKE  'rxc%'
) b	
   
 
DROP TABLE IF EXISTS #COUNT 
SELECT DISTINCT 
		MemberID,
		(SELECT DISTINCT COUNT(diseasecategory) FROM #ref_HHS_disease_interaction WHERE diseasecategory IS NOT NULL AND MemberId = C.MemberId) GroupCount,
		(SELECT DISTINCT COUNT(Category) FROM #ref_HHS_disease_interaction WHERE diseasecategory IS NULL AND MemberId = C.MemberId) HCCCount
INTO #COUNT
FROM    #ref_HHS_disease_interaction   C

DROP TABLE IF EXISTS #ref_HHS_disease_interaction_Agg 
SELECT DISTINCT 
    m.MemberID,	 
    STRING_AGG(m.diseasecategory, ', ') WITHIN GROUP (ORDER BY diseasecategory) AS interactioncategory ,
    SUM(CAST(l.Weight as numeric(19,4))) Factor,
	(GroupCount+HCCCount) total_Count	

INTO #ref_HHS_disease_interaction_Agg
FROM #ref_HHS_disease_interaction m
INNER JOIN #COunt cnt on cnt.MemberID = m.MemberID
INNER JOIN #lookup_vw_ref_HHS_Disease_Factor  l  
     ON  m.diseasecategory = l.Category AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
Group By m.MemberID,(GroupCount+HCCCount)
 

UPDATE a
SET a.RAF_HCC_Interaction = b.Factor,
 
    a.ra_variable = ra_variable + ', ' + interactioncategory,
	a.dis_count =  b.total_Count  

FROM #membership a
INNER JOIN #ref_HHS_disease_interaction_Agg b
			ON a.MemberID = b.MemberID

 
---------------------------------------------------------------------------------------------
--APPLICATION OF DISEASE COUNT FACTOR
---------------------------------------------------------------------------------------------

 DROP TABLE If EXISTS #SevereTransplant
;WITH STCTE AS(	SELECT DISTINCT
        a.MemberID,		
		CASE WHEN  c.variable LIKE '%SEVERE%' THEN 1 ELSE 0 END SEVERE,
	    CASE WHEN  c.variable LIKE '%TRANSPLANT%' THEN 1 ELSE 0 END TRANSPLANT
		 
    FROM #disease_detail a
	INNER JOIN #membership m on m.MemberID = a.MemberID
    CROSS APPLY   (
        SELECT  [Variable]
        FROM #lookup_vw_ref_HHS_disease_interaction b 
		CROSS APPLY STRING_SPLIT(b.[Category], ',') AS split_cat 
        WHERE TRIM(split_cat.value) = a.Category
    
    ) b
    INNER JOIN #lookup_vw_ref_HHS_disease_interaction c on b.variable = c.category
	WHERE  b.variable NOT LIKE  'rxc%'
     )

SELECT MemberId, Max(Severe) SEVERE,Max(Transplant) Transplant
INTO #SevereTransplant
FROM  STCTE
GROUP BY MemberId


UPDATE a
SET 
    Severe = b.severe,
	Transplant = b.Transplant    

FROM #membership a
INNER JOIN #SevereTransplant b
			ON a.MemberID = b.MemberID

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
	ON a.MODEL = b.MODEL and b.HCCCount =  CASE 	     WHEN a.model = 'ADULT' AND  (a.dis_Count)>= 8 then '8Plus'
														 WHEN a.model = 'CHILD' AND  (a.dis_Count) >= 4 then '4Plus'
														 ELSE a.dis_Count end
	 
	AND ISNULL(A.TRANSPLANT,0) = ISNULL(B.TRANSPLANT,0)
WHERE b.HccCount IS NOT NULL
	AND A.TRANSPLANT = 1
UNION
SELECT 

	A.MemberID,
	A.Model,
	A.MetalLevel,
	A.PaymentYear,
	B.Variable category
  

FROM #membership a
INNER JOIN #lookup_vw_ref_HHS_EnrolDuration_HCCCount b
	ON a.MODEL = b.MODEL and b.HCCCount =  CASE 	     WHEN a.model = 'ADULT' AND  (a.dis_Count) >= 10 then '10Plus' 														 
														 WHEN a.model = 'CHILD' AND  (a.dis_Count) IN (6,7) then '6_7'
														 WHEN a.model = 'CHILD' AND  (a.dis_Count) >= 8 then '8Plus' 														  
														 ELSE a.dis_Count end
	 
	AND  ISNULL(A.SEVERE,0) = ISNULL(B.SEVERE,0)
	 
WHERE b.HccCount IS NOT NULL
		AND A.SEVERE =1
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

SELECT MemberID,
 STRING_AGG(m.category, ', ') WITHIN GROUP (ORDER BY m.category) AS category,
 SUM(cast(l.Weight as numeric(19,4))) Factor
INTO #ref_HHS_HCCCount
FROM HccCountCTE m
INNER JOIN  #lookup_vw_ref_HHS_Disease_Factor  l  
     ON  m.category = l.Category AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
GROUP BY MemberID

 

UPDATE a
SET a.RAF_HCC_COUNT_ED_Interaction = ISNULL(b.Factor,0),
     
    a.ra_variable = ra_variable + ','+ ISNULL(B.category,'')
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
	INNER JOIN #membership m ON m.MemberID = a.MemberID
	INNER JOIN  #RXC_Detail r ON r.MemberID = a.MemberID
    CROSS APPLY   (
        SELECT  [Variable] ,[Category]
        FROM #lookup_vw_ref_HHS_disease_interaction b 
		OUTER APPLY STRING_SPLIT(b.[Category], ',') AS split_cat 
        WHERE 1=1
		--and TRIM(LEADING '0' FROM split_cat.value) = a.Category
		AND  TRIM(split_cat.value) = FORMAT(CAST(REPLACE(a.Category,'_','.') AS NUMERIC),'000')
		and b.variable like 'RXC_'+FORMAT(CAST(RXC AS INT),'00')+'%'
    ) b
	 
     
)
 

SELECT DISTINCT 
    m.MemberID,
	STRING_AGG(trim(m.diseasecategory), ', ') WITHIN GROUP (ORDER BY diseasecategory) AS interactioncategory ,
    SUM(cast(l.Weight as numeric(19,4))) Factor	

INTO #ref_RXC_disease_interaction
FROM my_cte m
LEFT JOIN #lookup_vw_ref_HHS_Disease_Factor  l  
     ON  m.diseasecategory = l.Category AND m.Model = l.Model AND m.MetalLevel = l.MetalLevel
Group By MemberID
 
UPDATE a
SET a.RAF_RXC_Interaction = b.Factor,    
    a.ra_variable = ra_variable + ', ' + interactioncategory 
FROM #membership a
INNER JOIN #ref_RXC_disease_interaction b
			ON a.MemberID = b.MemberID

--*****************Infant Severity Interactions *******************************************
DROP TABLE IF EXISTS #severity_HIERARCHY
SELECT 'IHCC_SEVERITY5' Severity,'IHCC_SEVERITY4' SeverityOverride
INTO #severity_HIERARCHY
UNION Select 'IHCC_SEVERITY5' Severity,'IHCC_SEVERITY3' SeverityOverride
UNION Select 'IHCC_SEVERITY5' Severity,'IHCC_SEVERITY2' SeverityOverride
UNION Select 'IHCC_SEVERITY5' Severity,'IHCC_SEVERITY1' SeverityOverride
UNION Select 'IHCC_SEVERITY4' Severity,'IHCC_SEVERITY3' SeverityOverride
UNION Select 'IHCC_SEVERITY4' Severity,'IHCC_SEVERITY2' SeverityOverride
UNION Select 'IHCC_SEVERITY4' Severity,'IHCC_SEVERITY1' SeverityOverride
UNION Select 'IHCC_SEVERITY3' Severity,'IHCC_SEVERITY2' SeverityOverride
UNION Select 'IHCC_SEVERITY3' Severity,'IHCC_SEVERITY1' SeverityOverride
UNION Select 'IHCC_SEVERITY2' Severity,'IHCC_SEVERITY1' SeverityOverride

DROP TABLE IF EXISTS #Term_HIERARCHY
SELECT 'IHCC_EXTREMELY_IMMATURE' Term,'IHCC_IMMATURE' TermOverride
INTO #Term_HIERARCHY
UNION Select 'IHCC_EXTREMELY_IMMATURE' Term,'IHCC_PREMATURE_MULTIPLES' TermOverride
UNION Select 'IHCC_EXTREMELY_IMMATURE' Term,'IHCC_TERM' TermOverride
UNION Select 'IHCC_IMMATURE' Term,'IHCC_PREMATURE_MULTIPLES' TermOverride
UNION Select 'IHCC_IMMATURE' Term,'IHCC_TERM' TermOverride
UNION Select 'IHCC_PREMATURE_MULTIPLES' Term,'IHCC_TERM' TermOverride

DROP TABLE IF EXISTS #ref_HHS_Infant_Severity_Interactions
DROP TABLE IF EXISTS #SevereCTE
DROP TABLE IF EXISTS #TermCTE

 
   SELECT DISTINCT

        M.MemberID,
		m.Model,
		m.MetalLevel,
		b.Severity,
		b.Term,
        b.Variable AS diseasecategory  
	INTO #SevereCTE    --SELECT  *
    FROM   #disease_detail a
	INNER JOIN #membership m on m.MemberID = a.MemberID	 
    CROSS APPLY   (
						SELECT *
						FROM #lookup_vw_ref_HHS_Infant_Severity_Interactions b 
						CROSS APPLY
						(	SELECT * 
							FROM STRING_SPLIT(b.[Category], ',') AS split_cat 
							WHERE  FORMAT(CAST(REPLACE(a.Category,'_','.') AS NUMERIC),'000')= TRIM(split_cat.value)
							
						) x
						WHERE 1=1 
								AND b.Variable NOT LIKE '%X%'
								AND ISNULL(severity,'')  <> ''
		
					) b			
	WHERE m.Model = 'Infant'
	 
	SELECT DISTINCT
        M.MemberID,
		m.Model,
		m.MetalLevel,
		b.Severity,
		b.Term,
        b.Variable AS diseasecategory  ,b.age
	INTO #TermCTE
    FROM   #disease_detail a
	INNER JOIN #membership m on m.MemberID = a.MemberID	 
    CROSS APPLY   (
        SELECT Severity,Term,Variable ,age
        FROM #lookup_vw_ref_HHS_Infant_Severity_Interactions b 
		OUTER APPLY(SELECT * FROM STRING_SPLIT(b.[Category], ',') AS split_cat 
		WHERE  FORMAT(CAST(REPLACE(a.Category,'_','.') AS NUMERIC),'000')= TRIM(split_cat.value)
		) x
        WHERE 1=1 and ISNULL(severity ,'') = ''
			  AND (ISNULL(b.Age,'') = '' OR ( ISNULL(b.Age,'') <> '' AND  m.Age = b.Age))
			  AND b.Variable NOT LIKE '%X%'
			) b			
	WHERE m.Model = 'Infant'
 

--******************************************
 DELETE H
 --SELECT *
 FROM #SevereCTE C 
 INNER JOIN  #SevereCTE  H on C.MemberID=H.MemberID			  
 INNER JOIN #severity_HIERARCHY s on C.DISEASECATEGORY = s.Severity 
		AND H.DISEASECATEGORY = S.SeverityOverride 

--******************************************
 DELETE H
 --SELECT *
 FROM #TermCTE C 
 INNER JOIN  #TermCTE  H on C.MemberID=H.MemberID			  
 INNER JOIN #Term_Hierarchy s on C.DiseaseCategory = s.Term 
		AND H.DiseaseCategory = S.TermOverride

--*****************************************
 
 
DROP TABLE IF EXISTS #IS_CTE_Others
 
SELECT DISTINCT
    cM.MemberID,
	cm.Model,
	cm.MetalLevel,
	 
    X.Variable AS diseasecategory  
INTO #IS_CTE_Others    --SELECT  FORMAT(cast(a.Category as int),'000')
FROM    #SevereCTE cm 
INNER JOIN  #TermCTE bm on cm.MemberID = bm.MemberID 
CROSS APPLY   (
				SELECT *
				FROM #lookup_vw_ref_HHS_Infant_Severity_Interactions b 
				WHERE  1=1
						AND   cm.diseasecategory = b.Severity
						AND   bm.diseasecategory  = b.term
				) x
WHERE 1=1 
		AND cm.Model = 'Infant'
			 
--SELECT * FROM #IS_CTE_Others			
	 

SELECT DISTINCT 
    m.MemberID,
	STRING_AGG(trim(m.diseasecategory), ', ') WITHIN GROUP (ORDER BY diseasecategory) AS interactioncategory ,
    SUM(CAST(ISNULL(l.Weight,0) AS NUMERIC(19,4))) Factor	

INTO #ref_HHS_Infant_Severity_Interactions
 
FROM #IS_CTE_Others m
INNER JOIN  #lookup_vw_ref_HHS_Disease_Factor  l  
     ON  m.diseasecategory = l.Category AND m.Model = l.Model and m.metallevel = l.metallevel
	  
GROUP By MemberID
 

UPDATE a
SET a.RAF_HCC_Interaction = RAF_HCC_Interaction + b.Factor,    
    a.ra_variable = ra_variable + ', ' + interactioncategory 
FROM #membership a
INNER JOIN #ref_HHS_Infant_Severity_Interactions b
			ON a.MemberID = b.MemberID

 

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
 
	SELECT 
		PaymentYear,
		MemberID,
		DOB,
		Age,
		Gender,		
		ISNULL(Model,'Unknown') Model ,
		MetalLevel,
		EnrollDuration,
		ISNULL(RA_VARIABLE,'') RA_VARIABLE,
		ROUND(RAF_DEMO, 3, 1) AS RAF_DEMO,
		ROUND(RAF_HCC, 3, 1) AS RAF_HCC,
		ROUND(RAF_RXC, 3, 1) AS RAF_RXC,
		ROUND(RAF_HCC_COUNT_ED_Interaction, 3, 1) AS RAF_HCC_COUNT_ED_Interaction,
		ROUND(RAF_HCC_Interaction, 3, 1) AS RAF_HCC_Interaction ,
		ROUND(RAF_RXC_Interaction, 3, 1) AS RAF_RXC_Interaction ,	 
		ROUND(RAF_TOTAL, 3, 1) AS RAF_TOTAL 

	FROM 
		#membership
 

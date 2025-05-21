
CREATE         procedure [dbo].[sp_RS_Medicare_PartC_Suspect](@PmtYear as int, @Membership as [InputMembership_PartC] READONLY, @DxTable as [InputDiagnosis_Inner] READONLY )
as
 
BEGIN
--declare @PmtYear int = 2025
--Declare @Membership as InputMembership_PartC 
--Declare @DxTable as [InputDiagnosis]

--insert into @DxTable
--select		 'M00912','2024-08-18','2024-08-21','F13229'
--UNION select 'M00912','2024-01-06','2024-01-10','S062X6S'
--UNION select 'M00912','2024-03-15','2024-03-17','K55042'
--UNION select 'M00912','2024-05-08','2024-05-09','I63349'
--UNION select 'M00912','2024-08-15','2024-08-16','M488X1'
--UNION select 'M00912','2024-06-30','2024-07-02','L97413'
--UNION select 'M00912','2024-05-14','2024-05-17','S58012S'
--UNION select 'M00913','2024-07-14','2024-07-17','G903'
--UNION select 'M00913','2024-09-09','2024-09-13','I63233'
--UNION select 'M00913','2024-06-19','2024-06-23','X788XXS'
--UNION select 'M00913','2024-02-22','2024-02-23','E083533'
--UNION select 'M00913','2024-02-04','2024-02-07','S72479A'
--UNION select 'M00913','2024-11-19','2024-11-20','M05822'
--UNION select 'M00913','2024-01-21','2024-01-25','G8102'

--insert into @Membership
--select 'M00912',			'1985-10-13',	'M',	'C',		'N',	'N',	'N',		0
--UNION 
--SELECT 'M00913',			'1930-06-16',	'F',	'CN',		'N',	'N',	'N',		0
--UNION 
--SELECT 'M00914',			'1959-06-16',	'M',	'I',		'N',	'N',	'N',		0
--UNION 
--SELECT 'M00915',			'1969-06-16',	'M',	'GC',		'N',	'N',	'N',		0


	 DECLARE @MemberShipHCC [InputMembership_PartC]

	 INSERT INTO @MemberShipHCC
	 SELECT M.* FROM @Membership M 
	 INNER JOIN [vw_ref_Medicare_PartC_RATypeMapping] RTM ON M.RAType = RTM.RAType
	 WHERE RTM.ESRD = 'No'

	 DECLARE @MemberShipESRD [InputMembership_PartC]

	 INSERT INTO @MemberShipESRD
	 SELECT M.* FROM @Membership M 
	 INNER JOIN [vw_ref_Medicare_PartC_RATypeMapping] RTM ON M.RAType = RTM.RAType
	 WHERE RTM.ESRD = 'Yes'

if @PmtYear in (2024, 2025)
BEGIN
	 -----------------------------------------------------------------------------------------------------------------------------
	Declare @CI as numeric(19,4)=(select distinct (1-cast(CodingIntensity as float)*1.0/100) from [dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
	where Model LIKE '%HCC Model%Regular%' and PmtYear=@PmtYear) 

	Declare @Norm_V24 as numeric(19,4)=(select distinct [Normalization-NonESRD] from [dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
	where Model LIKE '%HCC Model%Regular%' and PmtYear=@PmtYear and ClinicalVersion='V24') 

	Declare @Norm_V28 as numeric(19,4)=(select distinct [Normalization-NonESRD] from [dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
	where Model LIKE '%HCC Model%Regular%' and PmtYear=@PmtYear and ClinicalVersion='V28') 

	Declare @BlendScore_V24 Numeric(19,4) = CASE WHEN @PmtYear = 2024 THEN 0.67  WHEN @PmtYear = 2025 then 0.33 ELSE 0 END
	Declare @BlendScore_V28 Numeric(19,4) = CASE WHEN @PmtYear = 2024 THEN 0.33  WHEN @PmtYear = 2025 then 0.67 ELSE 1 END

	-----------------------------------------------------------------------------------------------------------------------------
	-- Construct the dynamic SQL query
	DECLARE @HCCsql NVARCHAR(MAX)
	SET @HCCsql = N'EXEC [dbo].[sp_RS_Medicare_PartC_CMSHCC_Inner]     @year,     @Membership,     @Diagnosis,     @version'

	-----------------------------------------------------------------------------------------------------------------------------
	DECLARE @ESRDsql NVARCHAR(MAX)
	SET @ESRDsql = N'EXEC [dbo].[sp_RS_Medicare_PartC_ESRD_Inner]     @year,     @Membership,     @Diagnosis,     @version'


	-----------------------------------------------------------------------------------------------------------------------------
	-- Execute the dynamic SQL query for Model 1
	Declare @OutputFromInnerProcedure_V24 as [OutputMembership_PartC_Inner]
	insert into @OutputFromInnerProcedure_V24
	EXEC sp_executesql 
		@HCCsql, 
		N'@year INT, @Membership InputMembership_PartC READONLY, @Diagnosis InputDiagnosis READONLY, @version NVARCHAR(10)', 
		@PmtYear, 
		@MemberShipHCC, 
		@DxTable,
		@version='V24'
  
	drop table if exists #V24Run
	select * into #V24Run from @OutputFromInnerProcedure_V24
	-----------------------------------------------------------------------------------------------------------------------------
	-- Execute the dynamic SQL query for Model 2
	Declare @OutputFromInnerProcedure_V28 as [OutputMembership_PartC_Inner]
	insert into @OutputFromInnerProcedure_V28
	EXEC sp_executesql 
		@HCCsql, 
		N'@year INT, @Membership InputMembership_PartC READONLY, @Diagnosis InputDiagnosis READONLY, @version NVARCHAR(10)', 
		@PmtYear, 
		@MemberShipHCC, 
		@DxTable, 
		@version = 'V28'

	drop table if exists #V28Run
	select * into #V28Run from @OutputFromInnerProcedure_V28
	-----------------------------------------------------------------------------------------------------------------------------
	Declare @OutputFromInnerProcedure_E24 as [OutputMembership_PartC_Inner]
	   insert into @OutputFromInnerProcedure_E24
		EXEC sp_executesql 
		@ESRDsql, 
		N'@year INT, @Membership InputMembership_PartC READONLY, @Diagnosis InputDiagnosis READONLY, @version NVARCHAR(10)', 
		@PmtYear, 
		@MemberShipESRD, 
		@DxTable,
		@version='E24'

	drop table if exists #E24Run
	SELECT * INTO #E24Run from @OutputFromInnerProcedure_E24
	-----------------------------------------------------------------------------------------------------------------------------
	
	select 'SUSPECT' as Engine,*, 0 as ActiveScore from #V24Run
	UNION
	select 'SUSPECT' as Engine,*, 0 as ActiveScore from #V28Run
	UNION
	Select 
		'SUSPECT' as Engine,
		a.PmtYear,
		a.MemberID,
		a.BirthDate_Org,
		a.BirthDate,
		a.Age,
		a.AgeBand,
		a.Gender_Org,
		a.Gender,
		a.RAType_Org,
		a.RAType,
		a.Hospice_Org,
		a.Hospice,
		a.LTIMCAID_Org,
		a.LTIMCAID,
		a.NEMCAID_Org,
		a.NEMCAID,
		a.OREC_Org,
		a.OREC,
		a.OriginallyDisabled,
		a.OriginallyESRD,
		--a.dis_list_category,
		--a.dis_count,
		--a.dis_int_dis,
		--a.dis_int_disab,
		a.ClinicalVersion + ' ( '+a.ra_variable + ' ) and '	+ b.ClinicalVersion + ' ( '+b.ra_variable + ' )'		as ra_variable,
		@BlendScore_V24*(@CI*(a.raf_demo/@Norm_V24))					+	@BlendScore_V28*(@CI*(b.raf_demo/@Norm_V28))					as raf_demo,
		@BlendScore_V24*(@CI*(a.raf_demo_status/@Norm_V24))				+	@BlendScore_V28*(@CI*(b.raf_demo_status/@Norm_V28))			as raf_demo_status,
		@BlendScore_V24*(@CI*(a.raf_dis/@Norm_V24))						+	@BlendScore_V28*(@CI*(b.raf_dis/@Norm_V28))					as raf_dis,
		@BlendScore_V24*(@CI*(a.raf_dis_count/@Norm_V24))				+	@BlendScore_V28*(@CI*(b.raf_dis_count/@Norm_V28))				as raf_dis_count,
		@BlendScore_V24*(@CI*(a.raf_dis_int_dis/@Norm_V24))				+	@BlendScore_V28*(@CI*(b.raf_dis_int_dis/@Norm_V28))			as raf_dis_int_dis,
		@BlendScore_V24*(@CI*(a.raf_dis_int_disab/@Norm_V24))			+	@BlendScore_V28*(@CI*(b.raf_dis_int_disab/@Norm_V28))			as raf_dis_int_disab,
		@BlendScore_V24*(@CI*(a.raf_total/@Norm_V24))					+	@BlendScore_V28*(@CI*(b.raf_total/@Norm_V28))					as raf_dis_int_disab,
		 
		cast(@BlendScore_V28*100 as varchar)+'% of '+ b.Model+' '+b.ClinicalVersion+ ' / '+ cast(@BlendScore_V24*100 as varchar)+'% of '+ a.Model+' '+a.ClinicalVersion as Model,
		b.ClinicalVersion+' / '+a.ClinicalVersion,
		1
	FROM
		#V24Run a
	JOIN
		#V28Run b
	ON	
		a.MemberId=b.MemberId
	UNION
	select 'SUSPECT',*, 1 as ActiveScore from #E24Run
		----------------------------------------------------------------------------------------------------------------------
		
  
	 /*

	-----------------------------------------------------------------------------------------------------------------------------
	-- Construct the dynamic SQL query
	DECLARE @HCCsql NVARCHAR(MAX)
	SET @HCCsql = N'EXEC [sp_RS_Medicare_PartC_CMSHCC_Middle]     @year,     @MemberShip,     @Diagnosis'

	DECLARE @ESRDsql NVARCHAR(MAX)
	SET @ESRDsql = N'EXEC [sp_RS_Medicare_PartC_ESRD_Middle]     @year,     @MemberShip,     @Diagnosis'
	-----------------------------------------------------------------------------------------------------------------------------
	---- Execute the dynamic SQL query for Model 1
	--Declare @OutputFromInnerProcedure_HCC  as [OutputMembership_PartC_Inner]
	--DROP TABLE IF EXISTS #OutputFromInnerProcedure_HCC
	--select * into #OutputFromInnerProcedure_HCC from @OutputFromInnerProcedure_HCC

	--INSERT INTO #OutputFromInnerProcedure_HCC
	EXEC sp_executesql 
		@HCCsql, 
		N'@year INT, @MemberShip InputMembership_PartC READONLY, @Diagnosis InputDiagnosis READONLY', 
		@PmtYear, 
		@MemberShipHCC, 
		@DxTable 
	

	--DROP TABLE IF EXISTS #OutputFromInnerProcedure_ESRD
	--Declare @OutputFromInnerProcedure_ESRD as [OutputMembership_PartC_Inner]
	--select * into #OutputFromInnerProcedure_ESRD from @OutputFromInnerProcedure_ESRD
	--insert into #OutputFromInnerProcedure_ESRD 
	EXEC sp_executesql 
    @ESRDsql, 
    N'@year INT, @MemberShip InputMembership_PartC READONLY, @Diagnosis InputDiagnosis READONLY', 
    @PmtYear, 
    @MemberShipESRD, 
    @DxTable;
	 
	-- SELECT * FROM #OutputFromInnerProcedure_HCC
	-- UNION
	-- SELECT * FROM #OutputFromInnerProcedure_ESRD
	*/
	 END
END

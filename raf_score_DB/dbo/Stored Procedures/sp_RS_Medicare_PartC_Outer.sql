




Create           procedure [dbo].[sp_RS_Medicare_PartC_Outer](@PmtYear as int, @Membership as [InputMembership_PartC] READONLY, @DxTableRA as [InputDiagnosisRA] READONLY , @EngineType INT= 1)
as
 
BEGIN
 

--************************************************************************************************
	 
	 DECLARE @ValidatedMembership [Validated_InputMembership_PartC]

	 INSERT INTO @ValidatedMembership
	 EXECUTE [sp_RS_Medicare_PartC_Validate_Membership] @PmtYear,@Membership

--*************************************************************************************************

	 DECLARE @MemberShipHCC [Validated_InputMembership_PartC]

	 INSERT INTO @MemberShipHCC
	 SELECT M.* FROM @ValidatedMembership M 
	 LEFT JOIN [vw_ref_Medicare_PartC_RATypeMapping] RTM ON M.RAType = RTM.RAType 
	 WHERE RTM.ESRD = 'No'
	 AND IsError = 0

	 DECLARE @MemberShipESRD [Validated_InputMembership_PartC]

	 INSERT INTO @MemberShipESRD
	 SELECT M.* FROM @ValidatedMembership M 
	 LEFT JOIN [vw_ref_Medicare_PartC_RATypeMapping] RTM ON M.RAType = RTM.RAType 
	 WHERE RTM.ESRD = 'Yes'
	  AND IsError = 0


	--******************************************************************************************

	DECLARE @DxTable [InputDiagnosis_Inner]

	INSERT INTO @DxTable
	SELECT [MemberID],
	'',
	'',
	[DxCode],
	1,
	''
	FROM @DxTableRA

	--------------------------------------------------------------------------------------------
if @PmtYear in (2024, 2025)
BEGIN
	 -----------------------------------------------------------------------------------------------------------------------------
	Declare @CI as numeric(19,3)=(select distinct (1-cast(CodingIntensity as float)*1.0/100) from [dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
	where Model LIKE '%HCC Model%Regular%' and PmtYear=@PmtYear) 

	Declare @Norm_V24 as numeric(19,3)=(select distinct [Normalization-NonESRD] from [dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
	where Model LIKE '%HCC Model%Regular%' and PmtYear=@PmtYear and ClinicalVersion='V24') 

	Declare @Norm_V28 as numeric(19,3)=(select distinct [Normalization-NonESRD] from [dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
	where Model LIKE '%HCC Model%Regular%' and PmtYear=@PmtYear and ClinicalVersion='V28') 

	Declare @BlendScore_V24 Numeric(19,3) = CASE WHEN @PmtYear = 2024 THEN 0.67  WHEN @PmtYear = 2025 then 0.33 ELSE 0 END
	Declare @BlendScore_V28 Numeric(19,3) = CASE WHEN @PmtYear = 2024 THEN 0.33  WHEN @PmtYear = 2025 then 0.67 ELSE 1 END
	
	Declare @Normalization_ESRD_Dialysis Numeric(19,3) , @Normalization_ESRD_FunctioningGraft Numeric(19,3) 
	SELECT @Normalization_ESRD_Dialysis= [Normalization-ESRD-Dialysis], @Normalization_ESRD_FunctioningGraft = [Normalization-ESRD-FunctioningGraft] 
	from [dbo].[vw_ref_Medicare_PartC_Model_Inventory] 
	where Model LIKE '%ESRD%Regular%' and PmtYear=@PmtYear and ClinicalVersion='E24' 

 
	-----------------------------------------------------------------------------------------------------------------------------
	-- Construct the dynamic SQL query
	DECLARE @HCCsql NVARCHAR(MAX)
	SET @HCCsql = N'EXEC [dbo].[sp_RS_Medicare_PartC_CMSHCC_Inner]     @year,     @Membership,     @Diagnosis,     @version , @EngineType'

	-----------------------------------------------------------------------------------------------------------------------------
	DECLARE @ESRDsql NVARCHAR(MAX)
	SET @ESRDsql = N'EXEC [dbo].[sp_RS_Medicare_PartC_ESRD_Inner]     @year,     @Membership,     @Diagnosis,     @version , @EngineType'

	-----------------------------------------------------------------------------------------------------------------------------

	DECLARE @version VARCHAR(50) = 'V24'
	-----------------------------------------------------------------------------------------------------------------------------
	IF @EngineType = 1
	BEGIN
	-- Execute the dynamic SQL query for Model 1
	SET @version  = 'V24'
	Declare @OutputFromInnerProcedure_V24 as OutputMembership_PartC_EngineType1
	insert into @OutputFromInnerProcedure_V24
	EXEC sp_executesql 
		@HCCsql, 
		N'@year INT, @Membership [Validated_InputMembership_PartC] READONLY, @Diagnosis InputDiagnosis_Inner READONLY, @version NVARCHAR(10),@EngineType INT', 
		@PmtYear, 
		@MemberShipHCC, 
		@DxTable,
		@version,
		@EngineType
  
	drop table if exists #V24Run
	select * into #V24Run from @OutputFromInnerProcedure_V24
	-----------------------------------------------------------------------------------------------------------------------------
	-- Execute the dynamic SQL query for Model 2
	SET @version = 'V28'
	Declare @OutputFromInnerProcedure_V28 as OutputMembership_PartC_EngineType1
	insert into @OutputFromInnerProcedure_V28
	EXEC sp_executesql 
		@HCCsql, 
		N'@year INT, @Membership Validated_InputMembership_PartC READONLY, @Diagnosis InputDiagnosis_Inner READONLY, @version NVARCHAR(10),@EngineType int', 
		@PmtYear, 
		@MemberShipHCC, 
		@DxTable, 
		@version ,
		@EngineType

	drop table if exists #V28Run
	select * into #V28Run from @OutputFromInnerProcedure_V28
	-------------------------------------------------------------------------------------------------------------------------------
	SET @version = 'E24'
	Declare @OutputFromInnerProcedure_E24 as OutputMembership_PartC_EngineType1
	   insert into @OutputFromInnerProcedure_E24
		EXEC sp_executesql 
		@ESRDsql, 
		N'@year INT, @Membership Validated_InputMembership_PartC READONLY, @Diagnosis InputDiagnosis_Inner READONLY, @version NVARCHAR(10),@EngineType INT', 
		@PmtYear, 
		@MemberShipESRD, 
		@DxTable,
		@version,
		@EngineType

	DROP TABLE IF EXISTS #E24Run
	SELECT * INTO #E24Run from @OutputFromInnerProcedure_E24
	-----------------------------------------------------------------------------------------------------------------------------
	
	select PmtYear		Payment_Year,
		MemberID		Member_Id,
		BirthDate_Org,
		BirthDate,
		Age,
		AgeBand			Age_Band,
		Gender_Org,
		Gender,
		RAType_Org,
		RAType,
		RAType_Engine,
		Hospice_Org,
		Hospice,
		LTIMCAID_Org,
		LTIMCAID,
		NEMCAID_Org,
		NEMCAID,
		OREC_Org,
		OREC,
		OriginallyDisabled		Originally_Disabled,
		OriginallyESRD			Originally_ESRD,
		ra_variable				RA_Variable,
		raf_demo				RAF_Demographic,
		raf_demo_status			RAF_Demographic_Interaction_With_Medicaid_Or_OREC,
		raf_dis					RAF_Disease,
		raf_dis_count			RAF_Disease_Count,
		raf_dis_int_dis			RAF_Disease_Interaction_With_Disease,
		raf_dis_int_disab		RAF_Disease_Interaction_With_Disability_Or_NonAged,
		raf_total				RAF_Total,
		Model,
		ClinicalVersion			Clinical_Version,
		CASE WHEN IsError = 1 THEN -1 ELSE 0 END as Active_Score ,
		[MessageCode]
		from #V24Run
	UNION
	select 
		PmtYear		Payment_Year,
		MemberID		Member_Id,
		BirthDate_Org,
		BirthDate,
		Age,
		AgeBand			Age_Band,
		Gender_Org,
		Gender,
		RAType_Org,
		RAType,
		RAType_Engine,
		Hospice_Org,
		Hospice,
		LTIMCAID_Org,
		LTIMCAID,
		NEMCAID_Org,
		NEMCAID,
		OREC_Org,
		OREC,
		OriginallyDisabled		Originally_Disabled,
		OriginallyESRD			Originally_ESRD,
		ra_variable				RA_Variable,
		ROUND(raf_demo,4,1)				RAF_Demographic,
		ROUND(raf_demo_status,4,1)			RAF_Demographic_Interaction_With_Medicaid_Or_OREC,
		ROUND(raf_dis,4,1)					RAF_Disease,
		ROUND(raf_dis_count	,4,1)		RAF_Disease_Count,
		ROUND(raf_dis_int_dis,4,1)			RAF_Disease_Interaction_With_Disease,
		ROUND(raf_dis_int_disab	,4,1)	RAF_Disease_Interaction_With_Disability_Or_NonAged,
		ROUND(raf_total	,4,1)			RAF_Total,
		Model,
		ClinicalVersion			Clinical_Version,
		CASE WHEN IsError = 1 THEN -1 ELSE 0 END as Active_Score ,
		[MessageCode]
	from #V28Run
	UNION
	Select 
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
		a.RAType_Engine,
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
		CAST(@BlendScore_V24*(@CI*(a.raf_demo/@Norm_V24))					+	@BlendScore_V28*(@CI*(b.raf_demo/@Norm_V28))	as numeric(19,4))				as raf_demo,
		CAST(@BlendScore_V24*(@CI*(a.raf_demo_status/@Norm_V24))				+	@BlendScore_V28*(@CI*(b.raf_demo_status/@Norm_V28))	as numeric(19,4))			as raf_demo_status,
		CAST(@BlendScore_V24*(@CI*(a.raf_dis/@Norm_V24))						+	@BlendScore_V28*(@CI*(b.raf_dis/@Norm_V28))		as numeric(19,4))				as raf_dis,
		CAST(@BlendScore_V24*(@CI*(a.raf_dis_count/@Norm_V24))				+	@BlendScore_V28*(@CI*(b.raf_dis_count/@Norm_V28))	as numeric(19,4))				as raf_dis_count,
		CAST(@BlendScore_V24*(@CI*(a.raf_dis_int_dis/@Norm_V24))				+	@BlendScore_V28*(@CI*(b.raf_dis_int_dis/@Norm_V28))	as numeric(19,4))			as raf_dis_int_dis,
		CAST(@BlendScore_V24*(@CI*(a.raf_dis_int_disab/@Norm_V24))			+	@BlendScore_V28*(@CI*(b.raf_dis_int_disab/@Norm_V28))	as numeric(19,4))			as raf_dis_int_disab,
		CAST(@BlendScore_V24*(@CI*(a.raf_total/@Norm_V24))					+	@BlendScore_V28*(@CI*(b.raf_total/@Norm_V28))	as numeric(19,4))					as raf_dis_int_disab,
		 
		cast(@BlendScore_V28*100 as varchar)+'% of '+ b.Model+' '+b.ClinicalVersion+ ' / '+ cast(@BlendScore_V24*100 as varchar)+'% of '+ a.Model+' '+a.ClinicalVersion as Model,
		b.ClinicalVersion+' / '+a.ClinicalVersion,
		1,
		a.[MessageCode]
	FROM
		#V24Run a
	INNER JOIN
		#V28Run b
	ON	
		a.MemberId=b.MemberId-- AND a.[MessageCode] = b.[MessageCode]
	WHERE a.IsError = 0 AND b.IsError = 0 
	UNION
	select 
		PmtYear,
		MemberID,
		BirthDate_Org,
		BirthDate,
		Age,
		AgeBand,
		Gender_Org,
		Gender,
		RAType_Org,
		RAType,
		RAType_Engine,
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
		ra_variable										as ra_variable,
		raf_demo 										as raf_demo,
		raf_demo_status									as raf_demo_status,
		raf_dis											as raf_dis,
		raf_dis_count									as raf_dis_count,
		raf_dis_int_dis									as raf_dis_int_dis,
		raf_dis_int_disab								as raf_dis_int_disab,
		raf_total										as raf_total,
		 
		Model+' '+ClinicalVersion						as Model,
		ClinicalVersion,
		CASE WHEN IsError = 1 THEN -1 ELSE 0 END as ActiveScore ,
		[MessageCode]
		from #E24Run
	UNION
	SELECT 
		PmtYear,
		MemberID,
		BirthDate_Org,
		BirthDate,
		Age,
		AgeBand,
		Gender_Org,
		Gender,
		RAType_Org,
		RAType,
		RAType_Engine,
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
		ra_variable		as ra_variable,
		CASE WHEN RAType LIKE 'D%' THEN @Normalization_ESRD_Dialysis*raf_demo 	
			 WHEN RAType LIKE 'G%' THEN @Normalization_ESRD_FunctioningGraft*raf_demo ELSE 	raf_demo END							as raf_demo,
		CASE WHEN RAType LIKE 'D%' THEN @Normalization_ESRD_Dialysis*raf_demo_status 	
			 WHEN RAType LIKE 'G%' THEN @Normalization_ESRD_FunctioningGraft*raf_demo_status ELSE 	raf_demo_status END									as raf_demo_status,
		CASE WHEN RAType LIKE 'D%' THEN @Normalization_ESRD_Dialysis*raf_dis	 	
			 WHEN RAType LIKE 'G%' THEN @Normalization_ESRD_FunctioningGraft*raf_dis	 ELSE 	raf_dis	 END										as raf_dis,
		CASE WHEN RAType LIKE 'D%' THEN @Normalization_ESRD_Dialysis*raf_dis_count	 	
			 WHEN RAType LIKE 'G%' THEN @Normalization_ESRD_FunctioningGraft*raf_dis_count	 ELSE 	raf_dis_count	 END								as raf_dis_count,
		CASE WHEN RAType LIKE 'D%' THEN @Normalization_ESRD_Dialysis*raf_dis_int_dis	 	
			 WHEN RAType LIKE 'G%' THEN @Normalization_ESRD_FunctioningGraft*raf_dis_int_dis	 ELSE 	raf_dis_int_dis	 END								as raf_dis_int_dis,
		CASE WHEN RAType LIKE 'D%' THEN @Normalization_ESRD_Dialysis*raf_dis_int_disab 	
			 WHEN RAType LIKE 'G%' THEN @Normalization_ESRD_FunctioningGraft*raf_dis_int_disab ELSE 	raf_dis_int_disab END								as raf_dis_int_disab,
		CASE WHEN RAType LIKE 'D%' THEN @Normalization_ESRD_Dialysis*raf_total	 	
			 WHEN RAType LIKE 'G%' THEN @Normalization_ESRD_FunctioningGraft*raf_total	 ELSE 	raf_total	 END									as raf_total,
		 
		Model 						as Model,
		ClinicalVersion,
		1
		as ActiveScore ,
		[MessageCode]

		from #E24Run
		WHERE IsError = 0 

		UNION

		SELECT
		@PmtYear,
		MemberID,
		BirthDate BirthDate_Org,
		BirthDate,
		'' Age,
		'' AgeBand,
		Gender Gender_Org,
		Gender,
		RAType RAType_Org,
		RAType,
		'' RAType_Engine,
		Hospice_Org,
		Hospice,
		LTIMCAID_Org,
		LTIMCAID,
		NEMCAID NEMCAID_Org,
		NEMCAID,
		OREC_Org,
		OREC,
		'' OriginallyDisabled,
		'' OriginallyESRD,
		'' ra_variable,
		0.000 raf_demo,
		0.000 raf_demo_status,
		0.000 raf_dis,
		0.000 raf_dis_count,
		0.000 raf_dis_int_dis,
		0.000 raf_dis_int_disab,
		0.000 raf_total,		 
		''  Model,
		'' ClinicalVersion,
		-1 ActiveScore ,
		[MessageCode]

		FROM @ValidatedMembership 
		WHERE IsError = 1
	--	----------------------------------------------------------------------------------------------------------------------
		END

	ELSE IF @EngineType = 2
	BEGIN
	SET @version  = 'V24'
		-- Execute the dynamic SQL query for Model 2
	Declare @OutputFromInnerProcedure_EngineType2_v24 as [OutputMembership_PartC_EngineType2]
	insert into @OutputFromInnerProcedure_EngineType2_v24
	EXEC sp_executesql 
		@HCCsql, 
		N'@year INT, @Membership Validated_InputMembership_PartC READONLY, @Diagnosis InputDiagnosis_Inner READONLY, @version NVARCHAR(10),@EngineType int', 
		@PmtYear, 
		@MemberShipHCC, 
		@DxTable, 
		@version ,
		@EngineType

	drop table if exists #EngineType2_v24
	select * into #EngineType2_v24 from @OutputFromInnerProcedure_EngineType2_v24

	SET @version  = 'V28'
		-- Execute the dynamic SQL query for Model 2
	Declare @OutputFromInnerProcedure_EngineType2_v28 as [OutputMembership_PartC_EngineType2]
	insert into @OutputFromInnerProcedure_EngineType2_v28
	EXEC sp_executesql 
		@HCCsql, 
		N'@year INT, @Membership Validated_InputMembership_PartC READONLY, @Diagnosis InputDiagnosis_Inner READONLY, @version NVARCHAR(10),@EngineType int', 
		@PmtYear, 
		@MemberShipHCC, 
		@DxTable, 
		@version ,
		@EngineType

	drop table if exists #EngineType2_v28
	select * into #EngineType2_v28 from @OutputFromInnerProcedure_EngineType2_v28

	SET @version  = 'E24'
		-- Execute the dynamic SQL query for Model 2
	Declare @OutputFromInnerProcedure_EngineType2_E24 as [OutputMembership_PartC_EngineType2]
	insert into @OutputFromInnerProcedure_EngineType2_E24
	EXEC sp_executesql 
		@ESRDsql, 
		N'@year INT, @Membership Validated_InputMembership_PartC READONLY, @Diagnosis InputDiagnosis_Inner READONLY, @version NVARCHAR(10),@EngineType int', 
		@PmtYear, 
		@MemberShipESRD, 
		@DxTable, 
		@version ,
		@EngineType

	drop table if exists #EngineType2_E24
	select * into #EngineType2_E24 from @OutputFromInnerProcedure_EngineType2_E24

	 
-----------------------------------------------------------------------------------------------------------------
		select 
			PmtYear,
			MemberID,
			FromDOS,
			ThruDOS,
			ICD,
			CategoryFactor,	
			Category,			
			ClinicalVersion ,		
			Model,
			ModelDescription,
			QualificationFlag,
		    UnqualificationReason,
			[MessageCode]
		FROM #EngineType2_v24
		UNION
		SELECT 
			PmtYear,
			MemberID,
			FromDOS,
			ThruDOS,
			ICD,
			CategoryFactor,	
			Category,			
			ClinicalVersion ,		
			Model,
			ModelDescription,
			QualificationFlag,
		    UnqualificationReason,
			[MessageCode]
		FROM #EngineType2_v28
		UNION
		SELECT 
			PmtYear,
			MemberID,
			FromDOS,
			ThruDOS,
			ICD,
			CategoryFactor,	
			Category,			
			ClinicalVersion ,		
			Model,
			ModelDescription,
			QualificationFlag,
		    UnqualificationReason,
			[MessageCode]
		FROM #EngineType2_E24
		UNION
		SELECT 
			@PmtYear,
			m.MemberID,
			FromDOS,
			ThruDOS,
			DxCode ICD,
			0.00 CategoryFactor,	
			'' Category,			
			'' ClinicalVersion ,		
			'' Model,
			'' ModelDescription,
			QualificationFlag,
		    UnqualificationReason,
			[MessageCode]
		FROM @ValidatedMembership M
		LEFT JOIN @DxTable D ON M.MemberId = D.MemberId
		WHERE IsError = 1
		ORDER BY MemberId,ClinicalVersion
	END 
  
	 
	 END
END

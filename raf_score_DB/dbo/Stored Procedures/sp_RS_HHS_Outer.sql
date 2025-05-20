/****** Object:  StoredProcedure [dbo].[sp_RS_HHS_Outer]    Script Date: 22-04-2025 19:35:49 ******/

CREATE     procedure [dbo].[sp_RS_HHS_Outer](@PaymentYear INT, @Membership as [InputMembership_HHS] READONLY, @DxTable as [InputDiagnosis_HHS] READONLY,@NDC [InputNDC_HHS] READONLY ,@HCPCS [InputHCPCS_HHS] READONLY)
as

  --************************************************************************************************
	 
	 DECLARE @ValidatedMembership [Validated_InputMembership_HHS]

	 INSERT INTO @ValidatedMembership
	 EXECUTE [sp_RS_HHS_Validate_Membership] @PaymentYear,@Membership

--*************************************************************************************************

	 DECLARE @MemberShipHHS [Validated_InputMembership_HHS]

	 INSERT INTO @MemberShipHHS
	 SELECT M.* FROM @ValidatedMembership M 	
	 WHERE  IsError = 0
 
	-- Declare table variable using the table type
	DECLARE @HHS_Results [OutputMembership_HHS]

	-- Construct the dynamic SQL query
	DECLARE @HHSsql NVARCHAR(MAX)
	SET @HHSsql = N'	
	EXEC [dbo].[sp_RS_HHS_Inner] @PaymentYear, @MemberShipHHS, @Diagnosis, @NDC, @HCPCS'

	PRINT 'Inserting from Inner SP'
	INSERT INTO @HHS_Results
	EXEC sp_executesql 
			@HHSsql, 
			N'@PaymentYear INT, @MemberShipHHS [Validated_InputMembership_HHS] READONLY, @Diagnosis [InputDiagnosis_HHS] READONLY, @NDC [InputNDC_HHS] READONLY, @HCPCS [InputHCPCS_HHS] READONLY', 
			@PaymentYear, 
			@MemberShipHHS, 
			@DxTable,
			@NDC ,
			@HCPCS
    
	PRINT 'Retreiving data'
	-- Return the results from the table variable with explicit column names
	SELECT 
		PaymentYear,
		MemberID,
		 
		DOB,
		Age,
		 
		 
		Gender,
		Model,
		MetalLevel,
		EnrollDuration,
		RA_VARIABLE,
		RAF_DEMO,
		RAF_HCC,
		RAF_RXC,
		RAF_HCC_COUNT_ED_Interaction,
		RAF_HCC_Interaction,
		RAF_RXC_Interaction,
		RAF_TOTAL, 
		'' MessageCode
	FROM @HHS_Results
    UNION
    SELECT 
		@PaymentYear PaymentYear,
		MemberID,		 
		DOB,
		Age,	 
		 
		Gender,
		'' Model,
		MetalLevel,
		EnrollDuration,
		'' RA_VARIABLE,
		0.000 RAF_DEMO,
		0.000 RAF_HCC,
		0.000 RAF_RXC,
		0.000 RAF_HCC_COUNT_ED_Interaction,
		0.000 RAF_HCC_Interaction,
		0.000 RAF_RXC_Interaction,
		0.000 RAF_TOTAL, 
		MessageCode
	FROM @ValidatedMembership M 	
	WHERE  IsError = 1

	 
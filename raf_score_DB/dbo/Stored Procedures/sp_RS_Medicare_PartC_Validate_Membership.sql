create         PROCEDURE [dbo].[sp_RS_Medicare_PartC_Validate_Membership](@PmtYear INT,  @Membership as [InputMembership_PartC] READONLY )
AS
 
BEGIN
 

	 DECLARE @ValidatedMemberShip as [Validated_InputMembership_PartC]  

	 INSERT INTO @ValidatedMemberShip( [MemberID],
			[BirthDate],
			 Gender_Org,
			[Gender],
			[RAType_Org],
			 [RAType],
			[Hospice_Org],
			[Hospice],
			[LTIMCAID_Org],
			[LTIMCAID],
			[NEMCAID_Org],
			[NEMCAID],
			[OREC_Org],
			[OREC],
			MessageCode,
			 IsError  )
	 SELECT [MemberID],
			[BirthDate],
			[Gender] Gender_Org,
			[Gender],
			[RAType] [RAType_Org],
			 [RAType],
			 [Hospice] [Hospice_Org],
			[Hospice],
			[LTIMCAID] [LTIMCAID_Org],
			[LTIMCAID],
			[NEMCAID] [NEMCAID_Org],
			[NEMCAID],
			[OREC] [OREC_Org],
			[OREC],
			CAST('' AS VARCHAR(4000)) MessageCode,
			0 IsError  
	 FROM @Membership M 

	 

	 --*************Validation************
	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-001') VM
	 WHERE ISNULL(M.MemberId,'') = ''

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-002') VM
	 WHERE ISNULL(M.Birthdate,'')  IN ('','1900-01-01')

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-003') VM
	 WHERE ISNULL(M.Gender,'') = ''

	 --UPDATE M
	 --SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 --FROM @ValidatedMemberShip M
	 --CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-004') VM
	 --LEFT JOIN @DxTable d ON m.memberId = d.MemberId
	 --WHERE d.MemberId IS NULL

	 -- UPDATE M
	 --SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 --FROM @ValidatedMemberShip M
	 --CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-004') VM
	 --RIGHT JOIN @DxTable d ON m.memberId = d.MemberId
	 --WHERE m.MemberId IS NULL

	  UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-006') VM
	 WHERE ISNULL(M.OREC,'') = ''
	  

	  UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-008') VM
	 WHERE ISDATE(CAST(M.Birthdate AS VARCHAR)) = 0
	 

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-009') VM
	 WHERE Gender NOT IN ('M','F')

	 --UPDATE M
	 --SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 --FROM @ValidatedMemberShip M
	 --CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-010') VM
	 --INNER JOIN @DxTable d ON m.memberId = d.MemberId
	 --WHERE NOT EXISTS 
		--	(
		--	 SELECT 1
		--	 FROM [dbo].[vw_ref_Medicare_PartC_ICD_Category_Mapping] m
		--	 WHERE M.DxCode = d.DxCode
		--	)

	 -- UPDATE M
	 --SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 --FROM @ValidatedMemberShip M
	 --CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-011') VM
	 --INNER JOIN @DxTable d ON m.memberId = d.MemberId
	 --WHERE Year(d.ThruDos) <> @PmtYear -1



	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-012') VM
	 LEFT JOIN [dbo].[ref_Medicare_PartC_RAType_Mapping] T ON M.RAType = T.RAType
	 WHERE T.RAType IS NULL AND T.PaymentYear = @PmtYear

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-013') VM
	 INNER JOIN [dbo].[ref_Medicare_PartC_RAType_Mapping] T ON M.RAType = T.RAType
	 WHERE ISNULL(T.RAType_Engine,'') = '' AND T.PaymentYear = @PmtYear

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-014') VM
	 WHERE OREC NOT IN (0,1,2,3)
	  
	  UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-017') VM
	 WHERE @Pmtyear NOT IN (2024,2025)

	UPDATE M SET MessageCode = CONCAT(M.MessageCode, ',', VM.MessageCode), IsError = 1
	FROM @ValidatedMemberShip M
	CROSS APPLY (SELECT MessageCode FROM ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-018') VM
	WHERE EXISTS (
		SELECT 1 FROM @ValidatedMemberShip M2
		WHERE M2.MemberId = M.MemberId
		GROUP BY M2.MemberId
		HAVING COUNT(1) > 1
	);

	UPDATE M SET MessageCode = CONCAT(M.MessageCode, ',', VM.MessageCode), IsError = 1
	FROM @ValidatedMemberShip M
	CROSS APPLY (SELECT MessageCode FROM ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-020') VM
	WHERE EXISTS (
		SELECT 1 FROM @ValidatedMemberShip M2
		WHERE M2.MemberId = M.MemberId
		GROUP BY M2.MemberId
		HAVING COUNT(DISTINCT CAST(Birthdate AS VARCHAR) + CAST(Gender AS VARCHAR) + CAST(OREC AS VARCHAR)) > 1
	);

		UPDATE M
		SET MessageCode = CONCAT(M.MessageCode, ',' , VM.MessageCode) 
		FROM @ValidatedMemberShip M
		 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-021') VM
		WHERE  [dbo].[CalculateAge](case when M.BirthDate is null then getdate() else M.BirthDate end , CAST(cast(@PmtYear as VARCHAR(10))+'/02/01' as DATE))  > 100  




	  --************Defaults********************
		 UPDATE M
		SET Hospice = 'N',MessageCode = CONCAT(M.MessageCode, ',' , VM.MessageCode) 
		FROM @ValidatedMemberShip M
		 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-022') VM
		WHERE ISNULL(Hospice,'')  =''

	  --***HCC*****---------------------------------------------
		
		UPDATE M
		SET LTIMCAID = 'N',MessageCode = CONCAT(M.MessageCode, ',' , VM.MessageCode) 
		FROM @ValidatedMemberShip M
		 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-023') VM
		WHERE LTIMCAID = 'Y' AND RAType NOT IN ('I')

		UPDATE M
		SET NEMCAID = 'N',MessageCode = CONCAT(M.MessageCode, ',', VM.MessageCode) 
		FROM @ValidatedMemberShip M
		CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-024') VM
		WHERE NEMCAID = 'Y' AND RAType NOT IN ('E', 'SE','ED','E1','E2')

		
		--UPDATE M
		--SET OREC = 1,MessageCode = CONCAT(M.MessageCode, ',' , VM.MessageCode) 
		--FROM @ValidatedMemberShip M
		-- CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-025') VM
		--WHERE  [dbo].[CalculateAge](case when M.BirthDate is null then getdate() else M.BirthDate end , CAST(cast(@PmtYear as VARCHAR(10))+'/02/01' as DATE))  < 65 AND OREC = 0 AND RAType IN ('CF', 'CN', 'CP')


		--***ESRD**-------------------------------------------------
	  	UPDATE M
		SET
			OREC=2,MessageCode = CONCAT(M.MessageCode, ',' , VM.MessageCode)  
		from 
			@ValidatedMemberShip M
		 CROSS APPLY(SELECT MessageCode FROM  ref_Medicare_PartC_CMSHCC_ValidationMessage WHERE MessageCode = 'MSG-025') VM
		where 
			 [dbo].[CalculateAge](case when M.BirthDate is null then getdate() else M.BirthDate end , CAST(cast(@PmtYear as VARCHAR(10))+'/02/01' as DATE)) <65 and OREC=0
		AND  
			RAType   IN ('C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'D1', 'D2', 'I3', 'I4', 'I5', 'I6', 'I7', 'I8', 'I9', 'IA')


		


		--*****************************************
		 UPDATE @ValidatedMemberShip
		 SET MessageCode = Stuff(MessageCode,1,1,'')
		   

	  --******************************************
	 SELECT *
	 FROM @ValidatedMemberShip
END
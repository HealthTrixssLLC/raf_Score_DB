create PROCEDURE [dbo].[sp_RS_HHS_Validate_Membership](@PaymentYear INT,  @Membership as [InputMembership_HHS] READONLY )
AS
 
BEGIN
 

	 DECLARE @ValidatedMemberShip as [Validated_InputMembership_HHS]  
	 
	 INSERT INTO @ValidatedMemberShip( 
			[MemberID],
			[Gender],
			DOB,
			Age,
			MetalLevel,
			CSRIndicator,
			EnrollDuration,
			IsError ,
			MessageCode
			 )
	 SELECT [MemberID],
			[Gender],
			DOB,
			Age,
			MetalLevel,
			CSRIndicator,
			EnrollDuration,
			0 IsError , 
			 
			CAST('' AS VARCHAR(4000)) MessageCode
			
	 FROM @Membership M 

	 

	 --*************Validation************
	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-001') VM
	 WHERE ISNULL(M.MemberId,'') = ''

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-002') VM
	 WHERE ISNULL(M.DOB,'')  IN ('','1900-01-01')

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-003') VM
	 WHERE ISNULL(M.Gender,'') = ''

	 

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-005') VM
	 WHERE ISNULL(M.CSRIndicator,'') = ''

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-006') VM
	 WHERE ISNULL(M.CSRIndicator,'') <> '' AND M.CSRIndicator NOT IN ('1','2','3','4')

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-008') VM
	 WHERE ISDATE(CAST(M.DOB AS VARCHAR)) = 0
	 

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-009') VM
	 WHERE Gender NOT IN ('M','F')

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-010') VM
	 WHERE ISNULL(M.MetalLevel,'') = ''

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-011') VM
	 WHERE ISNULL(M.MetalLevel,'') <> '' AND M.MetalLevel NOT IN ('Platinum','Gold','Silver','Bronze','Catastrophic')

	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-017') VM
	 WHERE @PaymentYear NOT IN (2024,2025)

	UPDATE M SET MessageCode = CONCAT(M.MessageCode, ',', VM.MessageCode), IsError = 1
	FROM @ValidatedMemberShip M
	CROSS APPLY (SELECT MessageCode FROM ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-018') VM
	WHERE EXISTS (
		SELECT 1 FROM @ValidatedMemberShip M2
		WHERE M2.MemberId = M.MemberId
		GROUP BY M2.MemberId
		HAVING COUNT(1) > 1
	);

	--UPDATE M SET MessageCode = CONCAT(M.MessageCode, ',', VM.MessageCode), IsError = 1
	--FROM @ValidatedMemberShip M
	--CROSS APPLY (SELECT MessageCode FROM ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-020') VM
	--WHERE EXISTS (
	--	SELECT 1 FROM @ValidatedMemberShip M2
	--	WHERE M2.MemberId = M.MemberId
	--	GROUP BY M2.MemberId
	--	HAVING COUNT(DISTINCT CAST(DOB AS VARCHAR) + CAST(Gender AS VARCHAR) + CAST(OREC AS VARCHAR)) > 1
	--);

		UPDATE M
		SET MessageCode = CONCAT(M.MessageCode, ',' , VM.MessageCode) 
		FROM @ValidatedMemberShip M
		 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-021') VM
		WHERE  [dbo].[CalculateAge](case when M.DOB is null then getdate() else M.DOB end , CAST(cast(@PaymentYear as VARCHAR(10))+'/02/01' as DATE))  > 100  

	 

	 -- Add validation for EnrollDuration: Invalid
	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,IsError = 1
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-027') VM
	 WHERE ISNULL(M.EnrollDuration,'') <> '' AND M.EnrollDuration NOT between 1 and 12

	 -- --************Defaults********************
	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,Age  = [dbo].[CalculateAge](case when m.DOB is null then getdate() else m.DOB end , CAST(cast(@PaymentYear as VARCHAR(10))+'/02/01' as DATE)) 
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-004') VM
	 WHERE ISNULL(M.Age,'') = ''

	  
	-- Add validation for EnrollDuration: Mandatory
	 UPDATE M
	 SET MessageCode = M.MessageCode + ',' +VM.MessageCode,EnrollDuration = 12
	 FROM @ValidatedMemberShip M
	 CROSS APPLY(SELECT MessageCode FROM  ref_HHS_ValidationMessage WHERE MessageCode = 'MSG-026') VM
	 WHERE ISNULL(M.EnrollDuration,'') = ''
		


--*****************************************
	UPDATE @ValidatedMemberShip
	SET MessageCode = Stuff(MessageCode,1,1,'')
		   

--******************************************

	 SELECT *
	 FROM @ValidatedMemberShip
END

 
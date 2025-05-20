

--Server:10.10.1.4

CREATE       procedure [dbo].[demo_RAFCall_HHS]
as
-----------------------------------------------------------------------
--OPTION 1- MANUAL ROWS
-----------------------------------------------------------------------
DECLARE 
--	@PaymentYear as int=2025,

	@Membership as [InputMembership_HHS] , 
	@DxTable as [InputDiagnosis_HHS] ,
	@NDC as [InputNDC_HHS] ,
	@HCPCS as [InputHCPCS_HHS] 
  

 
INSERT INTO @Membership
SELECT 'M00912',	'M',		'1985-10-13',	'40',	'Gold',		2,12
UNION 
SELECT 'M00913',	'M',		'1930-06-16',	'95',	'Silver',		3,12
UNION 
SELECT 'M00914',	'M',		'1930-06-16',	'95',	'Platinum',		1,5
UNION 
SELECT 'M00915',	'M',		'2025-06-16',	'1',	'Platinum',		1,5

INSERT INTO @DxTable
SELECT		 'M00912','F13229' ,'2024-06-03'
UNION select 'M00913','S062X6S' ,'2024-06-03'
UNION select 'M00913','B9735' ,'2024-06-03'
UNION select 'M00914','L97413' ,'2024-06-03' 
UNION select 'M00914','Z95811' ,'2024-06-03'
UNION select 'M00914','T8620' ,'2024-06-03'
UNION select 'M00914','A880' ,'2024-06-03' 
UNION select 'M00914','B020' ,'2024-06-03'
UNION select 'M00914','B459' ,'2024-06-03'
UNION select 'M00914','C168' ,'2024-06-03' 
UNION select 'M00914','C12' ,'2024-06-03'
UNION select 'M00914','G2119' ,'2024-06-03' 
UNION select 'M00914','I479' ,'2024-06-03' 
UNION select 'M00915','L97413' ,'2024-06-03' 
UNION select 'M00915','Z95811' ,'2024-06-03'
UNION select 'M00915','T8620' ,'2024-06-03'
UNION select 'M00915','A880' ,'2024-06-03' 
UNION select 'M00915','B020' ,'2024-06-03'
UNION select 'M00915','B459' ,'2024-06-03'
UNION select 'M00915','C168' ,'2024-06-03' 
UNION select 'M00915','C12' ,'2024-06-03'
UNION select 'M00915','B9735' ,'2024-06-03'

INSERT INTO @NDC
SELECT		 'M00912','00597004660'  
UNION select 'M00913','00597004660'  
UNION select 'M00914','00597004660'  
UNION select 'M00914','00003196601' 
insert into @HCPCS
select		 'M00912','J0741'  
UNION select 'M00913','J0741'  
UNION select 'M00914','J0741' 

EXEC [dbo].[sp_RS_HHS_Outer] 2024,  @Membership, @DxTable,@NDC,@HCPCS

 
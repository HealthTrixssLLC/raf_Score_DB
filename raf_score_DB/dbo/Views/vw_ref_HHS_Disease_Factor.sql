



CREATE       View 
 [dbo].[vw_ref_HHS_Disease_Factor]

 as 

 SELECT
	PaymentYear,
	Model,
	Variable,
	IsVariableValid,
	LevelName MetalLevel,
	[Weight],
	SourceFile,
	REPLACE(Variable,'HHS_','') Category
 --CASE WHEN Variable like 'Mage%' OR Variable like '%Male' then 'M'
 --WHEN Variable like 'Fage%'  OR Variable like '%FeMale' then 'F' END as Gender
  
 FROM [dbo].[vw_ref_HHS_Weights]

 --WHERE vARIABLE LIKE 'HHS%HCC%' OR 
 --vARIABLE LIKE 'RXC_[0-9][0-9]'

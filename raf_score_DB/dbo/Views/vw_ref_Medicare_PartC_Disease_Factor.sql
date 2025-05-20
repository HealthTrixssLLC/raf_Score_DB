
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Disease_Factor]    Script Date: 18-02-2025 19:51:35 ******/
 



 --select * from [vw_ref_Medicare_PartC_Weights]

CREATE             view [dbo].[vw_ref_Medicare_PartC_Disease_Factor]
AS
SELECT DISTINCT
    PmtYear,
	Sweep,
	ClinicalVersion,
	Model,
	ModelDescription,
	PACE,
	ESRD,
	Variable,
	LEFT(Variable, CHARINDEX('_', Variable) - 1) as RAtype,
	Replace(Variable,LEFT(Variable, CHARINDEX('_', Variable)),'' ) as Category,
	Weight as Factor,
	SourceArchive,
	SourceFile,
	LoadDate
	 
from 
	 [dbo].[vw_ref_Medicare_PartC_Weights]
where 
	Replace(Variable,LEFT(Variable, CHARINDEX('_', Variable)),'' )  like 'HCC%[0-9]'
	AND LEFT(Variable, CHARINDEX('_', Variable) - 1) NOT IN ('NE','SNPNE','DNE','GNE')

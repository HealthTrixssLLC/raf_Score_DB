



CREATE         view [dbo].[vw_ref_Medicare_PartC_Disease_Count_Factor]
as
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
	Replace(Variable,LEFT(Variable, CHARINDEX('_', Variable)),'' ) as DiseaseCountCategory,
	Weight as Factor,
	SourceArchive,
	SourceFile,
	LoadDate
--select *
from 
	[dbo].[vw_ref_Medicare_PartC_Weights]
where 
	SUBSTRING(Variable,5,2) like 'D%' and ISNUMERIC(SUBSTRING(Variable,6,1))=1

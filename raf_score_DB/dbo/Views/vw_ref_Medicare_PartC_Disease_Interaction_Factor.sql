



--select * from [vw_ref_Medicare_PartC_Disease_Interaction_Factor] where clinicalversion = 'e24'


CREATE     view [dbo].[vw_ref_Medicare_PartC_Disease_Interaction_Factor]
as
select 
    PmtYear,
	Sweep,
	ClinicalVersion,
	Model,
	ModelDescription,
	PACE,
	ESRD,
	Variable,
	LEFT(Variable, CHARINDEX('_', Variable) - 1) as RAType,
	Replace(Variable,LEFT(Variable, CHARINDEX('_', Variable)),'') as Interaction,
	CASE WHEN variable LIKE '%OriginallyDisabled%' THEN 'Y' else 'N' end as OriginallyDisabled,
	CASE WHEN variable LIKE '%INS_LTIMCAID%' THEN 'Y' else 'N' end as Medicaid,
	CASE
            WHEN variable LIKE '%_Female' THEN 'F'
            WHEN variable LIKE '%_Male' THEN 'M'
            ELSE NULL
        END AS Gender,

	Weight as Factor,
	SourceArchive,
	SourceFile,
	LoadDate
from
(
SELECT * FROM [dbo].[vw_ref_Medicare_PartC_Weights]
EXCEPT
	SELECT * FROM
	(
		SELECT * FROM [dbo].[vw_ref_Medicare_PartC_Weights]
		WHERE	 Variable like '%[MF][0-9]_%' AND Variable not like '%MCAID%' AND Variable not like '%ORIGDIS%' AND Variable not like '%FBDual%' AND Variable not like '%PBDual%'
		UNION
		SELECT * FROM  [dbo].[vw_ref_Medicare_PartC_Weights]
		WHERE 	(Variable  like '%INS_LTIMCAID%' OR Variable like '%OriginallyDisabled%'OR Variable like '%Originally_ESRD%')
		UNION
		select * from  [dbo].[vw_ref_Medicare_PartC_Weights]
		where SUBSTRING(Variable,5,2) like 'D%' and ISNUMERIC(SUBSTRING(Variable,6,1))=1
		UNION
		SELECT * FROM [dbo].[vw_ref_Medicare_PartC_Weights]
		WHERE Substring(Variable,CHARINDEX('_', Variable)+1,len(Variable)) like 'HCC[0-9]' OR Substring(Variable,CHARINDEX('_', Variable)+1,len(Variable)) like 'HCC[0-9][0-9]' OR Substring(Variable,CHARINDEX('_', Variable)+1,len(Variable)) like 'HCC[0-9][0-9][0-9]'
	) a
) b
WHERE
	 Variable NOT like '%Disabled%'
	 AND 
	 VARIABLE NOT LIKE '%_NORIGDIS_%'
	 AND 
	 VARIABLE NOT LIKE '%_ORIGDIS_%'

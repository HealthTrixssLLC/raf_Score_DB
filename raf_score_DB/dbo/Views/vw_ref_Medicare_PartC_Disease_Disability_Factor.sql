
--select * from [vw_ref_Medicare_PartC_Disease_Disability_Factor] where clinicalversion = 'E24'




CREATE             view [dbo].[vw_ref_Medicare_PartC_Disease_Disability_Factor]
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
	LEFT(Variable, CHARINDEX('_', Variable) - 1) as RAtype,
	Replace(Variable,LEFT(Variable, CHARINDEX('_', Variable)),'') as interaction,
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
select * FROM
(
	SELECT * FROM [dbo].[vw_ref_Medicare_PartC_Weights]
	WHERE	CASE 
			WHEN variable LIKE '%_F0_34' OR variable LIKE  '%_M0_34' THEN  '0-34'
			WHEN variable LIKE '%_F35_44' OR variable LIKE '%_M35_44' THEN '35_44'
			WHEN variable LIKE '%_F45_54' OR variable LIKE '%_M45_54' THEN '45_54'
			WHEN variable LIKE '%_F55_59' OR variable LIKE '%_M55_59' THEN '55_59'
			WHEN variable LIKE '%_F60_64' OR variable LIKE '%_M60_64' THEN '60_64'
			WHEN variable LIKE '%_F65_69' OR variable LIKE '%_M65_69' THEN '65-69'
			WHEN variable LIKE '%_F70_74' OR variable LIKE '%_M70_74' THEN '70-74'
			WHEN variable LIKE '%_F75_79' OR variable LIKE '%_M75_79' THEN '75-79'
			WHEN variable LIKE '%_F80_84' OR variable LIKE '%_M80_84' THEN '80-84'
			WHEN variable LIKE '%_F85_89' OR variable LIKE '%_M85_89' THEN '85-89'
			WHEN variable LIKE '%_F90_94' OR variable LIKE '%_M90_94' THEN '90-94'
			WHEN variable LIKE '%_F95_GT' OR variable LIKE '%_M95_GT' THEN '95+'        
			ELSE NULL
		END  is not null and Variable not like '%MCAID%' and Variable not like '%ORIGDIS%'
	UNION
	select * FROM [dbo].[vw_ref_Medicare_PartC_Weights]
	where 	(Variable  like '%INS_LTIMCAID%' OR Variable like '%OriginallyDisabled%' OR Variable like '%Originally_ESRD%')
	UNION
	SELECT * FROM [dbo].[vw_ref_Medicare_PartC_Weights]
	WHERE SUBSTRING(Variable,5,2) like 'D%' and ISNUMERIC(SUBSTRING(Variable,6,1))=1
	UNION
	SELECT * FROM [dbo].[vw_ref_Medicare_PartC_Weights]
	WHERE LEFT(Variable,7) like '%HCC%'
) a
) b
where
	 Variable like '%Disabled%'
	 OR
	 Variable like '%NonAged%'

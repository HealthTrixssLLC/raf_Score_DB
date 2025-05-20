
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Demographic_Factor]    Script Date: 09-03-2025 23:54:07 ******/
 
CREATE                   view [dbo].[vw_ref_Medicare_PartC_Demographic_Factor]
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
	LEFT(Variable, CHARINDEX('_', Variable) - 1) as RAType,
	CASE
            WHEN variable LIKE '%_M%'  OR variable LIKE '%NEM%' THEN 'M'
            WHEN variable LIKE '%_F%'  OR variable LIKE '%NEF%' THEN 'F'
            ELSE NULL
        END AS Gender,
    CASE 
        WHEN variable LIKE  '%[MF][0-9]%'  THEN REPLACE(variable,substring(variable,0,patINDEX('%[MF][0-9]%',variable)+1) ,'')
		ELSE NULL
    END AS AgeBand,
    CASE 
       WHEN variable LIKE  '%F0_34' OR variable LIKE   '%M0_34' THEN 0
		WHEN variable LIKE '%F35_44' OR variable LIKE '%M35_44' THEN 35		
		WHEN variable LIKE '%F45_54' OR variable LIKE '%M45_54' THEN 45
		WHEN variable LIKE '%F55_59' OR variable LIKE '%M55_59' THEN 55
		WHEN variable LIKE '%F60_64' OR variable LIKE '%M60_64' THEN 60
        WHEN variable LIKE '%F65_69' OR variable LIKE '%M65_69' OR variable LIKE '%F65' OR variable LIKE '%M65'  THEN 65		
		WHEN variable LIKE '%F66' OR variable LIKE '%M66' THEN 66
		WHEN variable LIKE '%F67' OR variable LIKE '%M67' THEN 67
		WHEN variable LIKE '%F68' OR variable LIKE '%M68' THEN 68
		WHEN variable LIKE '%F69' OR variable LIKE '%M69' THEN 69
        WHEN variable LIKE '%F70_74' OR variable LIKE '%M70_74' THEN 70
        WHEN variable LIKE '%F75_79' OR variable LIKE '%M75_79' THEN 75
        WHEN variable LIKE '%F80_84' OR variable LIKE '%M80_84' THEN 80
        WHEN variable LIKE '%F85_89' OR variable LIKE '%M85_89' OR variable LIKE '%85_GT'  THEN 85
        WHEN variable LIKE '%F90_94' OR variable LIKE '%M90_94' THEN 90
        WHEN variable LIKE '%F95_GT' OR variable LIKE '%M95_GT' THEN 95
        ELSE NULL
    END AS Age_Start,
    CASE 
        WHEN variable LIKE '%F0_34' OR variable LIKE  '%M0_34' THEN 34
		WHEN variable LIKE '%F35_44' OR variable LIKE '%M35_44' THEN 44
		WHEN variable LIKE '%F45_54' OR variable LIKE '%M45_54' THEN 54
		WHEN variable LIKE '%F55_59' OR variable LIKE '%M55_59' THEN 59
		WHEN variable LIKE '%F60_64' OR variable LIKE '%M60_64' THEN 64
		WHEN variable LIKE '%F65' OR variable LIKE '%M65' THEN 65
		WHEN variable LIKE '%F66' OR variable LIKE '%M66' THEN 66
		WHEN variable LIKE '%F67' OR variable LIKE '%M67' THEN 67
		WHEN variable LIKE '%F68' OR variable LIKE '%M68' THEN 68
        WHEN variable LIKE '%F65_69' OR variable LIKE '%_M65_69' OR variable LIKE '%F69' OR variable LIKE '%M69' THEN 69
        WHEN variable LIKE '%F70_74' OR variable LIKE '%M70_74' THEN 74
        WHEN variable LIKE '%F75_79' OR variable LIKE '%M75_79' THEN 79
        WHEN variable LIKE '%F80_84' OR variable LIKE '%M80_84' THEN 84
        WHEN variable LIKE '%F85_89' OR variable LIKE '%M85_89' THEN 89
        WHEN variable LIKE '%F90_94' OR variable LIKE '%M90_94' THEN 94
        WHEN variable LIKE '%F95_GT' OR variable LIKE '%M95_GT' OR variable LIKE '%85_GT' THEN 200
        ELSE NULL
    END AS Age_End,
	Weight as Factor,
	SourceArchive,
	SourceFile,
	LoadDate
	 
 FROM 
	 [dbo].[vw_ref_Medicare_PartC_Weights]    
where 
	(variable LIKE '%[MF][0-9]%' OR variable LIKE '%[MF][0-9][0-9]%')
		 
	and Variable not like '%MCAID%'
	and Variable not like '%ORIGDIS%'

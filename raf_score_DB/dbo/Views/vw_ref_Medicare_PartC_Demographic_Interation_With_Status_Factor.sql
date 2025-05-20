
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor]    Script Date: 21-02-2025 12:14:24 ******/
 


/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor]    Script Date: 18-02-2025 15:49:37 ******/
 



/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor]    Script Date: 05-02-2025 00:24:34 ******/
--select * from [vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor] where variable like '%lti%'

 


CREATE                                   view [dbo].[vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor]
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
	CASE WHEN variable LIKE '%OriginallyDisabled%' OR variable LIKE  '%[_]ORIGDIS%' OR variable LIKE  '%[_]ORIGDS%' OR  variable LIKE  '%[_]ORIGDS%' THEN 'Y' else 'N' end as OriginallyDisabled,
	CASE WHEN variable LIKE '%Originally_ESRD%'  THEN 'Y' else 'N' end as OriginallyESRD,
	CASE WHEN variable LIKE '%INS_LTIMCAID%' OR variable LIKE  '%[_]MCAID%' OR variable LIKE  'PBDUAL%'   OR variable LIKE  'FBDUAL%'  THEN 'Y' else 'N' end as Medicaid,
	CASE
            WHEN variable LIKE '%_Female%' OR variable LIKE '%NEF%' THEN 'F'
            WHEN variable LIKE '%_Male%' OR variable LIKE '%NEM%' THEN 'M'
            ELSE NULL
        END AS Gender,
	 CASE 
        WHEN variable LIKE  '%[MF][0-9]%'  THEN REPLACE(variable,substring(variable,0,patINDEX('%[MF][0-9]%',variable)+1) ,'')
		ELSE NULL
    END AS AgeBand,
      CASE 
        WHEN variable LIKE '%[MF][6][5]%' or variable LIKE '%[MF][7-9]%' or variable LIKE '%GE65%' or variable LIKE '%[\_]AGED'  THEN  1
		 ELSE 0
    END AS Aged,
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
	CASE	
		WHEN (variable LIKE  '%4_9%PBD%'   OR variable LIKE  '%4_9%FBD%' OR variable LIKE  '%_DUR4_9%') then '4-9'
		WHEN (variable LIKE  '%10%PBD%'   OR variable LIKE  '%10%fBD%'   OR variable LIKE  '%_DUR10PL%') then '10+' 
		WHEN variable LIKE  'TRANSPLANT%1%'  then '1'
		WHEN (variable LIKE  'TRANSPLANT%2%' ) then '2' 
		ELSE '' END Duration,
	CASE	
		WHEN variable LIKE  '%PBD%'   THEN 1
		ELSE 0 END PBDUAL,
	CASE	
		WHEN variable LIKE  '%FBD%'   THEN 1
		ELSE 0 END  FBDUAL,
	Weight as Factor,
	SourceArchive,
	SourceFile,
	LoadDate
 
FROM 
	[dbo].[vw_ref_Medicare_PartC_Weights]  
where  
	(Variable  like '%INS_LTIMCAID%')
	OR Variable like 'INS_ORIGDS'
	OR (Variable like '%OriginallyDisabled%')
	OR (Variable like '%Originally_ESRD%')
	OR  (Variable LIke 'NE%')
	OR (Variable LIke 'SNPNE%')
	OR  (Variable LIke 'DNE%')
	OR (Variable LIke 'GNE%')
	OR 	(Variable)  Like 'Transplant%'
	OR 	(Variable)  Like 'FGC%'
	OR 	(Variable)  Like 'FGI%'
	OR  (Variable)  Like 'DI%DUAL%'
	OR  (Variable)  Like 'LTI%'
	OR  (Variable)  Like 'DI_LTI%'
	OR  (Variable)  Like 'ActADj%'

	--(Variable LIke '%_ORIGDIS%')
	--OR (Variable LIke '%_MCAID%')

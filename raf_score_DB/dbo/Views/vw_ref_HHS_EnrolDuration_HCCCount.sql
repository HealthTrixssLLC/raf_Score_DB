
CREATE      VIEW [dbo].[vw_ref_HHS_EnrolDuration_HCCCount] AS
-- 
--SELECT * from [dbo].[ref_HHS_Weights] 

SELECT i.[Model]
      ,I.[Variable]
      ,I.[Description]
      ,I.[Variable_Used_in_Risk_Score_Formula?] IsVariableUse
      ,I.Definition
      ,CASE 
        WHEN CHARINDEX('HCC_ED', Variable) > 0 
        then REPLACE(VARIABLE,'HCC_ED','')    
        else null
        end EnrollDuration
      , CASE 
        WHEN CHARINDEX('COUNT', Variable) > 0 
        THEN 
          TRY_CAST(
            SUBSTRING(
              Variable, 
              CHARINDEX('Count', Variable)+5,
              6
            ) AS varchar
          )
        ELSE NULL
      END AS HCCCount ,
      CASE WHEN VARIABLE LIKE 'SEVERE%' THEN 1 ELSE 0 END SEVERE,
      CASE WHEN VARIABLE LIKE 'TRANSPLANT%' THEN 1 ELSE 0 END TRANSPLANT
      ,I.[source_table]
      ,I.[PaymentYear]
      ,I.[SourceFile]
  FROM [dbo].[ref_HHS_Interactions] i
  
  Where   VARIABLE LIKE 'HCC_ED%'
  OR VARIABLE LIKE '%COUNT%'
  
  
   

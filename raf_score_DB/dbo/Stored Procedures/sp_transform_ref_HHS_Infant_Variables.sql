Create   Procedure sp_transform_ref_HHS_Infant_Variables
  As
  
  Insert into ref_HHS_Infant_Variables
  (PaymentYear, Model, Variable, [Description], IsVariableUsed, Definition, Category, Severity, Age, Term, SourceTable, SourceFile)
  
  SELECT
  Paymentyear, [Model]  
      ,[Variable]  
      ,[Description]  
      ,[Variable_Used_in_Risk_Score_Formula?] IsVariableUsed  
      ,Definition  
      ,CASE   
        WHEN CHARINDEX('HHS_HCC', [Definition]) > 0   
        THEN (  
            SELECT STRING_AGG(value, ',') WITHIN GROUP (ORDER BY value)  
            FROM (  
                SELECT DISTINCT replace(TRIM(value),'HHS_HCC','') as value  
                FROM STRING_SPLIT(  
                    SUBSTRING(  
                        [Definition],  
                        CHARINDEX('HHS_HCC', [Definition]),  
                        LEN([Definition])  
                    ),  
                    ' '  
                )  
                WHERE value LIKE 'HHS_HCC%'  
            ) t  
        )  END AS Category,  
        CASE  
        WHEN CHARINDEX('IHCC_SEVERITY', [Definition]) > 0   
        THEN   
            CASE   
                WHEN [Definition] LIKE '%IHCC_SEVERITY1%=%1%' THEN 'IHCC_SEVERITY1'  
                 WHEN [Definition] LIKE '%IHCC_SEVERITY2%=%1%' THEN 'IHCC_SEVERITY2'  
                  WHEN [Definition] LIKE '%IHCC_SEVERITY3%=%1%' THEN 'IHCC_SEVERITY3'  
                   WHEN [Definition] LIKE '%IHCC_SEVERITY4%=%1%' THEN 'IHCC_SEVERITY4'  
                    WHEN [Definition] LIKE '%IHCC_SEVERITY5%=%1%' THEN 'IHCC_SEVERITY5'  
                ELSE ''  
            END  
        ELSE ''  
        END  
        as Severity,  
CASE   
        WHEN CHARINDEX('AGE_Last', [Definition]) > 0   
        THEN   
            CASE   
                WHEN [Definition] LIKE '%AGE_Last = 1%' THEN '1'  
                WHEN [Definition] LIKE '%AGE_Last = 0%' THEN '0'  
                ELSE ''  
            END  
        ELSE ''  
END AS Age,  
      CASE  
        WHEN CHARINDEX('IHCC_SEVERITY', [Definition]) > 0   
        THEN   
            CASE   
                WHEN [Definition] LIKE '%IHCC_EXTREMELY_IMMATURE%=%1%' THEN 'IHCC_EXTREMELY_IMMATURE'  
                 WHEN [Definition] LIKE '%IHCC_IMMATURE%=%1%' THEN 'IHCC_IMMATURE'  
                  WHEN [Definition] LIKE '%IHCC_PREMATURE_MULTIPLES%=%1%' THEN 'IHCC_PREMATURE_MULTIPLES'  
                   WHEN [Definition] LIKE '%IHCC_TERM%=%1%' THEN 'IHCC_TERM'  
                   WHEN [Definition] LIKE '%IHCC_AGE1%=%1%' THEN 'IHCC_AGE1'  
                       
                ELSE ''  
            END  
        ELSE ''  
        END  
        as Term  
  
      ,[source_table]  
         
      ,[SourceFile]  
         
  FROM [RAModuleDev].[dbo].[ref_HHS_Interactions]  
  WHere model like 'infant' --variable   like 'IHCC%' OR variable   like 'SEVERITY%'  
  And Variable not like 'Score%'  
  AND Description not Like '%hierarchy%'  


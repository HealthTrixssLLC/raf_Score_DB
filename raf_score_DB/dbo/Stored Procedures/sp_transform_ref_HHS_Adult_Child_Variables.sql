  Create   Procedure sp_transform_ref_HHS_Adult_Child_Variables
  as
  Insert into ref_HHS_Adult_Child_Variables(PaymentYear, Model, Variable, [Description], IsVariableUsed, Definition, Category, SourceFile)
  
  
SELECT [PaymentYear] ,
       [Model]  
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
        )  
        WHEN CHARINDEX('if G', [Definition]) > 0    
        THEN SUBSTRING([Definition],   
                      CHARINDEX('if G', [Definition]) + 3,  
                      CASE   
                        WHEN CHARINDEX('=', [Definition], CHARINDEX('if G', [Definition])) > 0  
                        THEN CHARINDEX('=', [Definition], CHARINDEX('if G', [Definition])) -   
                             (CHARINDEX('if G', [Definition]) + 3)  
                        ELSE LEN([Definition]) - (CHARINDEX('if G', [Definition]) + 3)  
                      END)  
        ELSE [Definition]  
      END AS Category  
  
       
      ,[SourceFile]  
        
  FROM [dbo].[ref_stg_HHS_cy2024diytables01072025_Table7_8_Adult_Child_Variables]  
  Where not(variable   like 'IHCC%' OR variable   like 'SEVERITY%')  

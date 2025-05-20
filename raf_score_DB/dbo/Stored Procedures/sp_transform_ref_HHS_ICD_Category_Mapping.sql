Create   proc [sp_transform_ref_HHS_ICD_Category_Mapping]
as
BEGIN
SET NOCOUNT ON;
Insert into [ref_HHS_ICD_Category_Mapping](PaymentYear,DXCode,ICD10Description,DxCodeStartDate,DXCodeEndDate,FYStartAge,FYEndAge,FYSex,CYStartAge,CYEndAge,CYSex,CCAgeLast,CCStartAge,CCEndAge,CCSexSplit,Category,Footnote,SourceFile)
SELECT PaymentYear
      ,[ICD10] DXCode
      ,[ICD10 Label] AS ICD10Description
      ,'2023-10-01' [DXCodeStartDate]
      ,'2024-09-30' [DXCodeEndDate]     
      ,TRY_CAST(
        CASE 
            WHEN [FY2024_AGE_AT_DIAGNOSIS] IS NULL OR [FY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([FY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS FYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [FY2024_AGE_AT_DIAGNOSIS] IS NULL OR [FY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([FY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([FY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS FYEndAge
      ,CASE WHEN [FY2024_Sex] = 'female' THEN 'f' 
            WHEN [FY2024_Sex] = 'male' THEN 'm' 
            ELSE [FY2024_Sex] END AS FYSex       
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS CYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([CY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS CYEndAge
      ,CASE WHEN [CY2024_Sex] = 'female' THEN 'f' 
            WHEN [CY2024_Sex] = 'male' THEN 'm' 
            ELSE [CY2024_Sex] END AS CYSex
      ,[CC_AGE_LAST] AS CCAgeLast
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 0
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN 0
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('>=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN 0
            ELSE 0
        END AS CCStartAge
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 200
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN 200
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT) - 1
            ELSE 200
        END AS CCEndAge
      ,CASE WHEN [CC_Sex_Split] = 'female' THEN 'f' 
            WHEN [CC_Sex_Split] = 'male' THEN 'm' 
       ELSE [CC_Sex_Split] END AS CCSexSplit
      ,REPLACE([CC],'.','_') AS Category
      ,[Footnote]
      ,SourceFile
  FROM  [dbo].[ref_stg_HHS_cy2024diytables01072025_Table3_HCC_Category_Mapping]
  WHERE ( CC <> 0 OR CC <> '')
   and FY2024 ='Y'
UNION
SELECT PaymentYear
      ,[ICD10] DXCode
      ,[ICD10 Label] AS ICD10Description
      ,'2023-10-01' [DXCodeStartDate]
      ,'2024-09-30' [DXCodeEndDate]     
      ,TRY_CAST(
        CASE 
            WHEN [FY2024_AGE_AT_DIAGNOSIS] IS NULL OR [FY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([FY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS FYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [FY2024_AGE_AT_DIAGNOSIS] IS NULL OR [FY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([FY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([FY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS FYEndAge
      ,CASE WHEN [FY2024_Sex] = 'female' THEN 'f' 
            WHEN [FY2024_Sex] = 'male' THEN 'm' 
            ELSE [FY2024_Sex] END AS FYSex       
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS CYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([CY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS CYEndAge
      ,CASE WHEN [CY2024_Sex] = 'female' THEN 'f' 
            WHEN [CY2024_Sex] = 'male' THEN 'm' 
            ELSE [CY2024_Sex] END AS CYSex
      ,[CC_AGE_LAST] AS CCAgeLast
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 0
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN 0
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('>=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN 0
            ELSE 0
        END AS CCStartAge
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 200
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN 200
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT) - 1
            ELSE 200
        END AS CCEndAge
      ,CASE WHEN [CC_Sex_Split] = 'female' THEN 'f' 
            WHEN [CC_Sex_Split] = 'male' THEN 'm' 
            ELSE [CC_Sex_Split] END AS CCSexSplit
      ,REPLACE([Second_CC] ,'.','_') AS CC
      ,[Footnote]
      ,SourceFile
  FROM  [dbo].[ref_stg_HHS_cy2024diytables01072025_Table3_HCC_Category_Mapping]
   WHERE ( [Second_CC] <> 0 OR [Second_CC] <> '')
   and FY2024 ='Y'
UNION
SELECT PaymentYear
      ,[ICD10] DXCode
      ,[ICD10 Label] AS ICD10Description
      ,'2023-10-01' [DXCodeStartDate]
      ,'2024-09-30' [DXCodeEndDate]     
      ,TRY_CAST(
        CASE 
            WHEN [FY2024_AGE_AT_DIAGNOSIS] IS NULL OR [FY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([FY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS FYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [FY2024_AGE_AT_DIAGNOSIS] IS NULL OR [FY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([FY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([FY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS FYEndAge
      ,CASE WHEN [FY2024_Sex] = 'female' THEN 'f' 
            WHEN [FY2024_Sex] = 'male' THEN 'm' 
            ELSE [FY2024_Sex] END AS FYSex       
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS CYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([CY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS CYEndAge
      ,CASE WHEN [CY2024_Sex] = 'female' THEN 'f' 
            WHEN [CY2024_Sex] = 'male' THEN 'm' 
            ELSE [CY2024_Sex] END AS CYSex
      ,[CC_AGE_LAST] AS CCAgeLast
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 0
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN 0
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('>=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN 0
            ELSE 0
        END AS CCStartAge
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 200
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN 200
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT) - 1
            ELSE 200
        END AS CCEndAge
      ,CASE WHEN [CC_Sex_Split] = 'female' THEN 'f' 
            WHEN [CC_Sex_Split] = 'male' THEN 'm' 
            ELSE [CC_Sex_Split] END AS CCSexSplit
      ,REPLACE([Third_CC] ,'.','_')  AS CC
      ,[Footnote]
      ,SourceFile
  FROM  [dbo].[ref_stg_HHS_cy2024diytables01072025_Table3_HCC_Category_Mapping]
   WHERE ( [Third_CC] <> 0 OR [Third_CC] <> '')
    and FY2024 ='Y'

UNION
SELECT PaymentYear
      ,[ICD10] DXCode
      ,[ICD10 Label] AS ICD10Description
      ,'2024-10-01' [DXCodeStartDate]
      ,'2025-09-30' [DXCodeEndDate]     
      ,TRY_CAST(
        CASE 
            WHEN [FY2025_AGE_AT_DIAGNOSIS] IS NULL OR [FY2025_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([FY2025_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS FYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [FY2025_AGE_AT_DIAGNOSIS] IS NULL OR [FY2025_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([FY2025_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([FY2025_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS FYEndAge
      ,CASE WHEN [FY2025_Sex] = 'female' THEN 'f' 
            WHEN [FY2025_Sex] = 'male' THEN 'm' 
            ELSE [FY2025_Sex] END AS FYSex       
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS CYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([CY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS CYEndAge
      ,CASE WHEN [CY2024_Sex] = 'female' THEN 'f' 
            WHEN [CY2024_Sex] = 'male' THEN 'm' 
            ELSE [CY2024_Sex] END AS CYSex
      ,[CC_AGE_LAST] AS CCAgeLast
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 0
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN 0
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('>=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN 0
            ELSE 0
        END AS CCStartAge
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 200
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN 200
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT) - 1
            ELSE 200
        END AS CCEndAge
      ,CASE WHEN [CC_Sex_Split] = 'female' THEN 'f' 
            WHEN [CC_Sex_Split] = 'male' THEN 'm' 
            ELSE [CC_Sex_Split] END AS CCSexSplit
      ,REPLACE([CC] ,'.','_') AS Category
      ,[Footnote]
      ,SourceFile
  FROM  [dbo].[ref_stg_HHS_cy2024diytables01072025_Table3_HCC_Category_Mapping]
  WHERE ( [CC] <> 0 OR [CC] <> '')
   and FY2025 ='Y'
UNION
SELECT PaymentYear
      ,[ICD10] DXCode
      ,[ICD10 Label] AS ICD10Description
      ,'2024-10-01' [DXCodeStartDate]
      ,'2025-09-30' [DXCodeEndDate]     
      ,TRY_CAST(
        CASE 
            WHEN [FY2025_AGE_AT_DIAGNOSIS] IS NULL OR [FY2025_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([FY2025_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS FYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [FY2025_AGE_AT_DIAGNOSIS] IS NULL OR [FY2025_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([FY2025_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([FY2025_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS FYEndAge
      ,CASE WHEN [FY2025_Sex] = 'female' THEN 'f' 
            WHEN [FY2025_Sex] = 'male' THEN 'm' 
            ELSE [FY2025_Sex] END AS FYSex       
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS CYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([CY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS CYEndAge
      ,CASE WHEN [CY2024_Sex] = 'female' THEN 'f' 
            WHEN [CY2024_Sex] = 'male' THEN 'm' 
            ELSE [CY2024_Sex] END AS CYSex
      ,[CC_AGE_LAST] AS CCAgeLast
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 0
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN 0
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('>=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN 0
            ELSE 0
        END AS CCStartAge
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 200
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN 200
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT) - 1
            ELSE 200
        END AS CCEndAge
      ,CASE WHEN [CC_Sex_Split] = 'female' THEN 'f' 
            WHEN [CC_Sex_Split] = 'male' THEN 'm' 
            ELSE [CC_Sex_Split] END AS CCSexSplit
      ,REPLACE([Second_CC] ,'.','_') AS CC
      ,[Footnote]
      ,SourceFile
  FROM  [dbo].[ref_stg_HHS_cy2024diytables01072025_Table3_HCC_Category_Mapping]
   WHERE  ( [Second_CC] <> 0 OR [Second_CC] <> '')
   and FY2025 ='Y'
UNION
SELECT PaymentYear
      ,[ICD10] DXCode
      ,[ICD10 Label] AS ICD10Description
      ,'2024-10-01' [DXCodeStartDate]
      ,'2025-09-30' [DXCodeEndDate]     
      ,TRY_CAST(
        CASE 
            WHEN [FY2025_AGE_AT_DIAGNOSIS] IS NULL OR [FY2025_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([FY2025_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS FYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [FY2025_AGE_AT_DIAGNOSIS] IS NULL OR [FY2025_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([FY2025_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([FY2025_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [FY2025_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS FYEndAge
      ,CASE WHEN [FY2025_Sex] = 'female' THEN 'f' 
            WHEN [FY2025_Sex] = 'male' THEN 'm' 
            ELSE [FY2025_Sex] END AS FYSex       
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 0
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 1 
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 1, CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) - 1)
            ELSE 0 
        END AS INT) AS CYStartAge
      ,TRY_CAST(
        CASE 
            WHEN [CY2024_AGE_AT_DIAGNOSIS] IS NULL OR [CY2024_AGE_AT_DIAGNOSIS] = '' THEN 200
            WHEN CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) > 0 
            AND CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) > 0
            THEN SUBSTRING([CY2024_AGE_AT_DIAGNOSIS], 
                          CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) + 2,
                          LEN([CY2024_AGE_AT_DIAGNOSIS]) - CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS], CHARINDEX('<=', [CY2024_AGE_AT_DIAGNOSIS]) + 2) - 1)
            ELSE 200
        END AS INT) AS CYEndAge
      ,CASE WHEN [CY2024_Sex] = 'female' THEN 'f' 
            WHEN [CY2024_Sex] = 'male' THEN 'm' 
            ELSE [CY2024_Sex] END AS CYSex
      ,[CC_AGE_LAST] AS CCAgeLast
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 0
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN 0
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('>=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN 0
            ELSE 0
        END AS CCStartAge
      ,CASE 
            WHEN [CC_AGE_LAST] IS NULL OR [CC_AGE_LAST] = '' THEN 200
            WHEN CHARINDEX('<=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<=', [CC_AGE_LAST]) + 2, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('>=', [CC_AGE_LAST]) > 0 THEN 200
            WHEN CHARINDEX('=', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('=', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT)
            WHEN CHARINDEX('<', [CC_AGE_LAST]) > 0 THEN TRY_CAST(SUBSTRING([CC_AGE_LAST], CHARINDEX('<', [CC_AGE_LAST]) + 1, LEN([CC_AGE_LAST])) AS INT) - 1
            ELSE 200
        END AS CCEndAge
      ,CASE WHEN [CC_Sex_Split] = 'female' THEN 'f' 
            WHEN [CC_Sex_Split] = 'male' THEN 'm' 
            ELSE [CC_Sex_Split] END AS CCSexSplit
      ,REPLACE([Third_CC] ,'.','_') AS CC
      ,[Footnote]
      ,SourceFile
  FROM  [dbo].[ref_stg_HHS_cy2024diytables01072025_Table3_HCC_Category_Mapping]
   WHERE ( [Third_CC] <> 0 OR [Third_CC] <> '')
    and FY2025 ='Y' 
    END

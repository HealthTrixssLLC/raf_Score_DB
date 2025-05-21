CREATE   proc [dbo].[sp_transform_ref_HHS_HCC_heirarchy]   
AS 
INSERT INTO [dbo].[ref_HHS_HCC_Heirarchy]   (PaymentYear , Category,CategoryOverride,HCCDescription,SourceFile)
SELECT  PaymentYear,  
        [HCC] Category,  
        value AS CategoryOverride, -- Split comma-separated values into rows  
        [HCC_Label] HCCDescription,  
        SourceFile  
FROM  ref_stg_HHS_cy2024diytables01072025_Table4_HCC_Heirarchy h
CROSS APPLY STRING_SPLIT([HCCOverride], ',')
WHERE NOT EXISTS (SELECT 1 from ref_HHS_HCC_Heirarchy where PaymentYear = h.PaymentYear)

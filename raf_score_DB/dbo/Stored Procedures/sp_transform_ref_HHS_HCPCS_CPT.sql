CREATE proc [dbo].[sp_transform_ref_HHS_HCPCS_CPT]
AS
INSERT INTO [dbo].[ref_HHS_HCPCS_CPT] (PaymentYear, HCPCS_CPT, Description, CY2023, CY2024, SourceFile)

SELECT [PaymentYear]
      ,[HCPCS_CPT_Code] HCPCS_CPT 
      ,[Description]
      ,[CY2023]
      ,[CY2024]
      ,[SourceFile]
  FROM  [dbo].[ref_stg_HHS_cy2024diytables01072025_Table2_HCPCS_CPT] h
WHERE NOT EXISTS (SELECT 1 from ref_HHS_HCPCS_CPT where PaymentYear = [PaymentYear])

Create   Procedure sp_transform_ref_HHS_RXC_NDC
As
Insert into ref_HHS_RXC_NDC(PaymentYear, RXC, Desciption, NDC, SourceFile)
select [PaymentYear]  
      ,[RXC]  
      ,[RXC_Label] Desciption  
      ,[NDC]  
       
      ,[SourceFile]
      From [dbo].[ref_stg_HHS_cy2024diytables01072025_Table10a_RXC_NDC]


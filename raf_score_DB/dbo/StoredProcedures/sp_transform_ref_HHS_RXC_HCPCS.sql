Create   Procedure sp_transform_ref_HHS_RXC_HCPCS
As  
Insert into ref_HHS_RXC_HCPCS(PaymentYear, RXC, Desciption, HCPCS, SourceFile)
Select [PaymentYear]  
      ,[RXC]  
      ,[RXC_Label] Desciption  
      ,[HCPCS]        
      ,[SourceFile]
      From [dbo].[ref_stg_HHS_cy2024diytables01072025_Table10b_RXC_HCPCS]


Create   Procedure sp_transform_ref_HHS_RXC_Heirarchy
As
Insert into ref_HHS_RXC_Heirarchy(PaymentYear, RXC, RXCOverride, RXCDescription, SourceFile)
select [PaymentYear],  
        [RXC],  
        [RXCOverride],  
        [RXC_Label] AS RXCDescription,  
        [SourceFile]
FROM  [dbo].[ref_stg_HHS_cy2024diytables01072025_Table11_RXC_Heirarchy]
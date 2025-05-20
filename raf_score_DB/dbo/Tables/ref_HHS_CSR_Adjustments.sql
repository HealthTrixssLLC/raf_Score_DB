CREATE TABLE [dbo].[ref_HHS_CSR_Adjustments] (
    [HIOS_Variant_ID]           INT            NULL,
    [CSR_Level]                 NVARCHAR (100) NULL,
    [RA_Software_CSR_Indicator] INT            NULL,
    [CSR_RA_Factor]             FLOAT (53)     NULL,
    [PaymentYear]               INT            NULL,
    [SourceFile]                VARCHAR (500)  NULL
);


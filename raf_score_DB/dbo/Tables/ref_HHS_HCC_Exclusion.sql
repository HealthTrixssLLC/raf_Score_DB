CREATE TABLE [dbo].[ref_HHS_HCC_Exclusion] (
    [HCC
]                     NVARCHAR (1000) NULL,
    [HCC_Label]                NVARCHAR (1000) NULL,
    [HCC_Excluded_AdultModel]  NVARCHAR (1000) NULL,
    [HCC_Excluded_ChildModel]  NVARCHAR (1000) NULL,
    [HCC_Excluded_InfantModel] NVARCHAR (1000) NULL,
    [PaymentYear]              INT             NULL,
    [SourceFile]               VARCHAR (100)   NULL
);


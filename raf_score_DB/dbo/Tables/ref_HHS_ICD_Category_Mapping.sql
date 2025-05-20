CREATE TABLE [dbo].[ref_HHS_ICD_Category_Mapping] (
    [PaymentYear]      INT           NULL,
    [DxCode]           VARCHAR (50)  NULL,
    [ICD10Description] VARCHAR (500) NULL,
    [DxCodeStartDate]  DATE          NULL,
    [DXCodeEndDate]    DATE          NULL,
    [FYStartAge]       INT           NULL,
    [FYEndAge]         INT           NULL,
    [FYSex]            VARCHAR (50)  NULL,
    [CYStartAge]       INT           NULL,
    [CYEndAge]         INT           NULL,
    [CYSex]            VARCHAR (50)  NULL,
    [CCAgeLast]        VARCHAR (50)  NULL,
    [CCStartAge]       INT           NULL,
    [CCEndAge]         INT           NULL,
    [CCSexSplit]       VARCHAR (50)  NULL,
    [Category]         VARCHAR (50)  NULL,
    [Footnote]         VARCHAR (50)  NULL,
    [SourceFile]       VARCHAR (50)  NULL
);


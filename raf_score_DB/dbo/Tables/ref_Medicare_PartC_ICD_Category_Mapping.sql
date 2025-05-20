CREATE TABLE [dbo].[ref_Medicare_PartC_ICD_Category_Mapping] (
    [PmtYear]          VARCHAR (50)  NULL,
    [ClinicalVersion]  VARCHAR (50)  NULL,
    [Sweep]            VARCHAR (50)  NULL,
    [Model]            VARCHAR (500) NULL,
    [ModelDescription] VARCHAR (500) NULL,
    [Pace]             VARCHAR (50)  NULL,
    [ESRD]             VARCHAR (50)  NULL,
    [DxCode]           VARCHAR (100) NULL,
    [Category]         BIGINT        NULL,
    [AdditionalDetail] VARCHAR (50)  NULL,
    [SourceArchive]    VARCHAR (100) NOT NULL,
    [SourceFile]       VARCHAR (50)  NOT NULL,
    [LoadDate]         DATE          NOT NULL
);


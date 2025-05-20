CREATE TABLE [dbo].[ref_Medicare_PartC_Hierarchy] (
    [PmtYear]             VARCHAR (50)  NULL,
    [ClinicalVersion]     VARCHAR (50)  NULL,
    [Sweep]               VARCHAR (50)  NULL,
    [Model]               VARCHAR (500) NULL,
    [ModelDescription]    VARCHAR (500) NULL,
    [Pace]                VARCHAR (50)  NULL,
    [ESRD]                VARCHAR (50)  NULL,
    [Category]            VARCHAR (20)  NULL,
    [CategoryDescription] VARCHAR (255) NULL,
    [CategoryOverride]    VARCHAR (20)  NULL,
    [LoadDate]            DATE          NOT NULL,
    [SourceArchive]       VARCHAR (100) NOT NULL,
    [SourceFile]          VARCHAR (50)  NOT NULL
);


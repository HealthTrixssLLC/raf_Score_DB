CREATE TABLE [dbo].[ref_Medicare_PartC_Interaction_Map] (
    [PmtYear]             VARCHAR (4)   NOT NULL,
    [ClinicalVersion]     VARCHAR (10)  NOT NULL,
    [Sweep]               VARCHAR (4)   NOT NULL,
    [Model]               VARCHAR (500) NULL,
    [ModelDescription]    VARCHAR (500) NULL,
    [Pace]                VARCHAR (50)  NULL,
    [ESRD]                VARCHAR (50)  NULL,
    [InteractionCategory] VARCHAR (100) NOT NULL,
    [InteractionVariable] VARCHAR (255) NULL,
    [SourceFile]          VARCHAR (50)  NOT NULL,
    [LoadDate]            DATE          NOT NULL,
    [SourceArchive]       VARCHAR (100) NULL
);


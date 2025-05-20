CREATE TABLE [dbo].[ref_Medicare_PartC_Weights] (
    [PmtYear]          VARCHAR (50)    NULL,
    [ClinicalVersion]  VARCHAR (50)    NULL,
    [Sweep]            VARCHAR (50)    NULL,
    [Model]            VARCHAR (500)   NULL,
    [ModelDescription] VARCHAR (500)   NULL,
    [Pace]             VARCHAR (50)    NULL,
    [ESRD]             VARCHAR (50)    NULL,
    [Variable]         VARCHAR (100)   NOT NULL,
    [Description]      VARCHAR (255)   NULL,
    [Weight]           DECIMAL (10, 5) NULL,
    [SourceArchive]    VARCHAR (100)   NOT NULL,
    [SourceFile]       VARCHAR (50)    NOT NULL,
    [LoadDate]         DATE            NOT NULL
);


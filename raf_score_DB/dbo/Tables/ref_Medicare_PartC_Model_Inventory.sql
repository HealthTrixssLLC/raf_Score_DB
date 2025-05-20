CREATE TABLE [dbo].[ref_Medicare_PartC_Model_Inventory] (
    [PmtYear]                             VARCHAR (50)  NULL,
    [ClinicalVersion]                     VARCHAR (50)  NULL,
    [Sweep]                               VARCHAR (50)  NULL,
    [Model]                               VARCHAR (500) NULL,
    [ModelDescription]                    VARCHAR (500) NULL,
    [Pace]                                VARCHAR (50)  NULL,
    [ESRD]                                VARCHAR (50)  NULL,
    [Normalization-NonESRD]               VARCHAR (50)  NULL,
    [CodingIntensity]                     VARCHAR (50)  NULL,
    [Normalization-ESRD-Dialysis]         VARCHAR (50)  NULL,
    [Normalization-ESRD-FunctioningGraft] VARCHAR (50)  NULL,
    [SourceArchive]                       VARCHAR (500) NULL
);


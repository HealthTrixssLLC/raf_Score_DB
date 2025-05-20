CREATE TYPE [dbo].[OutputMembership_PartC_EngineType2] AS TABLE (
    [PmtYear]               INT            NOT NULL,
    [MemberID]              VARCHAR (50)   NOT NULL,
    [FromDOS]               VARCHAR (50)   NULL,
    [ThruDOS]               VARCHAR (50)   NULL,
    [ICD]                   VARCHAR (50)   NULL,
    [CategoryFactor]        VARCHAR (50)   NULL,
    [Category]              VARCHAR (50)   NULL,
    [ClinicalVersion]       VARCHAR (50)   NULL,
    [Model]                 VARCHAR (100)  NULL,
    [ModelDescription]      VARCHAR (100)  NULL,
    [QualificationFlag]     BIT            NULL,
    [UnqualificationReason] VARCHAR (200)  NULL,
    [MessageCode]           VARCHAR (2000) NULL,
    [IsError]               BIT            NULL);


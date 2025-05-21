CREATE TYPE [dbo].[OutputHCCMapperSuspectInner] AS TABLE (
    [PmtYear]          INT           NULL,
    [MemberID]         VARCHAR (50)  NOT NULL,
    [FromDOS]          DATE          NOT NULL,
    [ThruDOS]          DATE          NOT NULL,
    [DxCode]           VARCHAR (20)  NOT NULL,
    [CategoryFactor]   FLOAT (53)    NULL,
    [Category]         VARCHAR (10)  NULL,
    [ClinicalVersion]  VARCHAR (10)  NULL,
    [Model]            VARCHAR (100) NULL,
    [ModelDescription] VARCHAR (100) NULL);


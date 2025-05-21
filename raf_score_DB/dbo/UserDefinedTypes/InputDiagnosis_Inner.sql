CREATE TYPE [dbo].[InputDiagnosis_Inner] AS TABLE (
    [MemberID]              VARCHAR (50)  NOT NULL,
    [FromDOS]               DATE          NULL,
    [ThruDOS]               DATE          NULL,
    [DxCode]                VARCHAR (20)  NOT NULL,
    [QualificationFlag]     INT           NULL,
    [UnqualificationReason] VARCHAR (200) NULL);


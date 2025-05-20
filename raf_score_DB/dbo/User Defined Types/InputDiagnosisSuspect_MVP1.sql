CREATE TYPE [dbo].[InputDiagnosisSuspect_MVP1] AS TABLE (
    [MemberID]              VARCHAR (50)  NOT NULL,
    [FromDOS]               DATE          NOT NULL,
    [ThruDOS]               DATE          NOT NULL,
    [DxCode]                VARCHAR (20)  NOT NULL,
    [QualificationFlag]     INT           NULL,
    [UnqualificationReason] VARCHAR (200) NULL);


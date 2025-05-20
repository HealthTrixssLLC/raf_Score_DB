CREATE TYPE [dbo].[InputDiagnosis_HHS] AS TABLE (
    [MemberID]    VARCHAR (50) NOT NULL,
    [DxCode]      VARCHAR (20) NOT NULL,
    [ServiceDate] VARCHAR (10) NULL);


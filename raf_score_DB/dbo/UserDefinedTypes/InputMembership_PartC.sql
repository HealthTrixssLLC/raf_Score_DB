CREATE TYPE [dbo].[InputMembership_PartC] AS TABLE (
    [MemberID]  VARCHAR (50) NOT NULL,
    [BirthDate] DATE         NOT NULL,
    [Gender]    VARCHAR (1)  NULL,
    [RAType]    VARCHAR (10) NULL,
    [Hospice]   VARCHAR (1)  NULL,
    [LTIMCAID]  VARCHAR (1)  NULL,
    [NEMCAID]   VARCHAR (1)  NULL,
    [OREC]      VARCHAR (1)  NULL);


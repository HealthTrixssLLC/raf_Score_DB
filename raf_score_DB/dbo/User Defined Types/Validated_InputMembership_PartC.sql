CREATE TYPE [dbo].[Validated_InputMembership_PartC] AS TABLE (
    [MemberID]     VARCHAR (50)   NOT NULL,
    [BirthDate]    DATE           NOT NULL,
    [Gender]       VARCHAR (1)    NULL,
    [RAType]       VARCHAR (10)   NULL,
    [Hospice]      VARCHAR (1)    NULL,
    [LTIMCAID]     VARCHAR (1)    NULL,
    [NEMCAID]      VARCHAR (1)    NULL,
    [OREC]         VARCHAR (1)    NULL,
    [Gender_Org]   VARCHAR (1)    NULL,
    [RAType_Org]   VARCHAR (10)   NULL,
    [Hospice_Org]  VARCHAR (1)    NULL,
    [LTIMCAID_Org] VARCHAR (1)    NULL,
    [NEMCAID_Org]  VARCHAR (1)    NULL,
    [OREC_Org]     VARCHAR (1)    NULL,
    [MessageCode]  VARCHAR (4000) NULL,
    [IsError]      BIT            NULL);


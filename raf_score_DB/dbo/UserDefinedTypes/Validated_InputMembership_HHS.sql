CREATE TYPE [dbo].[Validated_InputMembership_HHS] AS TABLE (
    [MemberID]       VARCHAR (50)   NOT NULL,
    [Gender]         VARCHAR (1)    NULL,
    [DOB]            DATE           NULL,
    [Age]            VARCHAR (50)   NULL,
    [MetalLevel]     VARCHAR (50)   NULL,
    [CSRIndicator]   VARCHAR (10)   NULL,
    [EnrollDuration] VARCHAR (50)   NULL,
    [IsError]        BIT            NULL,
    [MessageCode]    VARCHAR (4000) NULL);


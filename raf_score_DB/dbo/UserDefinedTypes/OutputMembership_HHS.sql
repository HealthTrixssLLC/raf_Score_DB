CREATE TYPE [dbo].[OutputMembership_HHS] AS TABLE (
    [PaymentYear]                  INT             NULL,
    [MemberID]                     VARCHAR (50)    NULL,
    [DOB]                          DATE            NULL,
    [Age]                          INT             NULL,
    [Gender]                       VARCHAR (1)     NULL,
    [Model]                        VARCHAR (200)   NULL,
    [MetalLevel]                   VARCHAR (50)    NULL,
    [EnrollDuration]               INT             NULL,
    [RA_VARIABLE]                  VARCHAR (8000)  NULL,
    [RAF_DEMO]                     NUMERIC (19, 4) NULL,
    [RAF_HCC]                      NUMERIC (19, 4) NULL,
    [RAF_RXC]                      NUMERIC (19, 4) NULL,
    [RAF_HCC_COUNT_ED_Interaction] NUMERIC (19, 4) NULL,
    [RAF_HCC_Interaction]          NUMERIC (19, 4) NULL,
    [RAF_RXC_Interaction]          NUMERIC (19, 4) NULL,
    [RAF_TOTAL]                    NUMERIC (19, 4) NULL);


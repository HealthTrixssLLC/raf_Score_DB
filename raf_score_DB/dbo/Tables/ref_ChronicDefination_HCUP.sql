CREATE TABLE [dbo].[ref_ChronicDefination_HCUP] (
    [ICD10]             NVARCHAR (50)  NOT NULL,
    [ICD10Desc]         NVARCHAR (500) NOT NULL,
    [CHRONIC_INDICATOR] INT            NOT NULL,
    [LookbackPeriod]    TINYINT        NOT NULL
);


CREATE TABLE [dbo].[ref_Medicare_PartC_CMSHCC_ValidationMessage] (
    [MessageCode]        VARCHAR (10)  NOT NULL,
    [MessageDescription] TEXT          NOT NULL,
    [MessageType]        VARCHAR (10)  NOT NULL,
    [Comments]           VARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([MessageCode] ASC)
);


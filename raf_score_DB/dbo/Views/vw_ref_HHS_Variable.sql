Create view [vw_ref_HHS_Variable] as
SELECT PaymentYear,
		[Model]
      ,[Variable]
      ,[Description]
      ,[IsVariableValid]
      ,[Definition],
	  SourceFile
  FROM  [dbo].[ref_HHS_Variable]


CREATE   view [dbo].[vw_ref_Medicare_PartC_ICD_Category_Mapping] as
select 
	a.PmtYear,
	a.ClinicalVersion,
	a.Sweep,
	a.Model,
	a.ModelDescription,
	a.Pace,
	a.ESRD,
	a.DxCode,
	'HCC'+cast(a.Category as VARCHAR(20)) as Category,
	a.AdditionalDetail,
	a.SourceArchive,
	a.SourceFile,
	a.LoadDate
from 
	 [dbo].[ref_Medicare_PartC_ICD_Category_Mapping] a
JOIN
	(select Pmtyear, MAX(Sweep) as Sweep from [dbo].[ref_Medicare_PartC_ICD_Category_Mapping]
	GROUP BY Pmtyear) b
ON
	a.PmtYear=b.PmtYear
AND
	a.Sweep=b.Sweep

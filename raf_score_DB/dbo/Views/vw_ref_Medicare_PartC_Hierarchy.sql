


CREATE     view [dbo].[vw_ref_Medicare_PartC_Hierarchy] as
select 
	a.PmtYear,
	a.ClinicalVersion,
	a.Sweep,
	a.Model,
	a.ModelDescription,
	a.Pace,
	a.ESRD,
	'HCC'+a.Category as Category,
	a.CategoryDescription,
	'HCC'+a.CategoryOverride as CategoryOverride,
	a.SourceArchive,
	a.SourceFile,
	a.LoadDate
from 
	 [dbo].ref_Medicare_PartC_Hierarchy a
JOIN
	(select Pmtyear, MAX(Sweep) as Sweep from [dbo].ref_Medicare_PartC_Hierarchy
	GROUP BY Pmtyear) b
ON
	a.PmtYear=b.PmtYear
AND
	a.Sweep=b.Sweep

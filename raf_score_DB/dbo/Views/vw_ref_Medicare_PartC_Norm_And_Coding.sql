
CREATE   view [dbo].[vw_ref_Medicare_PartC_Norm_And_Coding] as
select distinct
	a.PmtYear,
	a.ClinicalVersion, 
	a.Sweep, 
	a.Model, 
	a.ModelDescription,
	a.Pace,
	a.ESRD,
	a.[Normalization-NonESRD],
	a.[Normalization-ESRD-Dialysis],
	a.[Normalization-ESRD-FunctioningGraft],
	a.CodingIntensity,
	a.SourceArchive
from 
	 [dbo].[vw_ref_Medicare_PartC_Model_Inventory] a
JOIN
	(select Pmtyear, MAX(Sweep) as Sweep from [dbo].[vw_ref_Medicare_PartC_Model_Inventory]
	GROUP BY Pmtyear) b
ON
	a.PmtYear=b.PmtYear
AND
	a.Sweep=b.Sweep

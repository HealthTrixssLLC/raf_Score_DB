




/****** Object:  View [dbo].[archive_vw_ref_CMS_Medicare_PartC_Disease_Group_Map]    Script Date: 15-01-2025 15:21:45 ******/
 


CREATE            view [dbo].[vw_ref_Medicare_PartC_Disease_Group_Map]
as
SELECT 
	a.PmtYear,
	a.Sweep,
	a.ClinicalVersion,
	a.Model,
	a.ModelDescription,
	a.PACE,
	a.ESRD,
	a.DiseaseCategory,	 
	a.HCC,
	a.SourceArchive,
	a.SourceFile,
	a.LoadDate
	 
FROM 
	.ref_Medicare_PartC_disease_group_map a
INNER JOIN
	(SELECT PmtYear, MAX(Sweep) as Sweep from [dbo].ref_Medicare_PartC_disease_group_map
	GROUP BY PmtYear) b
ON
	a.PmtYear=b.PmtYear
AND
	a.Sweep=b.Sweep

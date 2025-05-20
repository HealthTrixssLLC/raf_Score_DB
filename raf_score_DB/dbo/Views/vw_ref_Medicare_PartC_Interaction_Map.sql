



/****** Object:  View [dbo].[archive_vw_ref_CMS_Medicare_PartC_Disease_Group_Map]    Script Date: 15-01-2025 15:21:45 ******/
 


CREATE        view [dbo].[vw_ref_Medicare_PartC_Interaction_Map]
as
select 
	a.PmtYear,
	a.Sweep,
	a.ClinicalVersion,
	a.Model,
	a.ModelDescription,
	a.PACE,
	a.ESRD,
	a.InteractionCategory,	 
	a.InteractionVariable,
	a.SourceArchive,
	a.SourceFile,
	a.LoadDate
 
FROM 
	[dbo].[ref_Medicare_PartC_Interaction_Map] a
INNER JOIN
	(SELECT PmtYear, MAX(Sweep) as Sweep from [dbo].[ref_Medicare_PartC_Interaction_Map]
	GROUP BY PmtYear) b
ON
	a.PmtYear=b.PmtYear
AND
	a.Sweep=b.Sweep

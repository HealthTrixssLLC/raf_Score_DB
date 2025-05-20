

CREATE     view [dbo].[vw_ref_Medicare_PartC_Weights] as
select 
	a.*
from 
	 [dbo].[ref_Medicare_PartC_Weights] a
JOIN
	(select Pmtyear, MAX(Sweep) as Sweep from [dbo].[ref_Medicare_PartC_Weights]
	GROUP BY Pmtyear) b
ON
	a.PmtYear=b.PmtYear
AND
	a.Sweep=b.Sweep

Create   procedure [dbo].[demo_SuspectCall] 
as
Declare @Membership as InputMembership_PartC 
Declare @DxTable as InputDiagnosisSuspect 

insert into @DxTable
select		 'M00912','2023-08-18','2023-08-21','F13229',1,NULL
UNION select 'M00912','2024-01-06','2023-01-10','S062X6S',1,NULL
UNION select 'M00912','2023-01-06','2024-01-10','S062X6S',1,NULL
UNION select 'M00912','2024-03-15','2024-03-17','K55042',1,NULL
UNION select 'M00912','2024-05-08','2024-05-09','I63349',1,NULL
UNION select 'M00912','2024-08-15','2024-08-16','M488X1',1,NULL
UNION select 'M00912','2024-06-30','2024-07-02','L97413',1,NULL
UNION select 'M00912','2024-05-14','2024-05-17','S58012S',1,NULL
UNION select 'M00913','2024-07-14','2024-07-17','G903',1,NULL
UNION select 'M00913','2024-09-09','2024-09-13','I63233',1,NULL
UNION select 'M00913','2024-06-19','2024-06-23','X788XXS',1,NULL
UNION select 'M00913','2024-02-22','2024-02-23','E083533',1,NULL
UNION select 'M00913','2024-02-04','2024-02-07','S72479A',1,NULL
UNION select 'M00913','2024-11-19','2024-11-20','M05822',1,NULL
UNION select 'M00913','2024-01-21','2024-01-25','G8102'  ,1,NULL

UNION select 'M00914','2024-08-15','2024-08-16','M488X1' ,1,NULL
UNION select 'M00914','2024-06-30','2024-07-02','L97413' ,1,NULL
UNION select 'M00914','2024-05-14','2024-05-17','S58012S',1,NULL
UNION select 'M00915','2024-07-14','2024-07-17','G903'	 ,1,NULL
UNION select 'M00915','2024-09-09','2024-09-13','I63233' ,1,NULL
UNION select 'M00915','2023-06-19','2023-06-23','X788XXS',1,NULL
UNION select 'M00915','2024-06-19','2024-06-23','I63233',1,NULL
  

insert into @Membership
select 'M00912',			'1985-10-13',	'M',	'CP',		'N',	'N',	'N',		0
UNION 
SELECT 'M00913',			'1930-06-16',	'F',	'CN',		'N',	'N',	'N',		1
UNION 
SELECT 'M00914',			'1930-06-16',	'F',	'CN',		'N',	'N',	'N',		1
UNION 
SELECT 'M00915',			'1969-06-16',	'M',	'D1',		'N',	'N',	'N',		0
--select * from @d
--select * from @M
 

exec [dbo].[sp_RS_Medicare_PartC_Outer_Suspect] 2024,  @Membership, @DxTable,1





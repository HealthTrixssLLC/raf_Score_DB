

--Server:10.10.1.4

CREATE     procedure [dbo].[demo_RAFCall]
as
-----------------------------------------------------------------------
--OPTION 1- MANUAL ROWS
-----------------------------------------------------------------------
Declare @Membership as InputMembership_PartC 
Declare @DxTable as [InputDiagnosisRA]

insert into @DxTable
select		 'M00912','F13229'
UNION select 'M00912','S062X6S'
--UNION select 'M00912','2023-01-06','2024-01-10','S062X6S'
--UNION select 'M00912','2024-03-15','2024-03-17','K55042'
--UNION select 'M00912','2024-05-08','2024-05-09','I63349'
--UNION select 'M00912','2024-08-15','2024-08-16','M488X1'
--UNION select 'M00912','2024-06-30','2024-07-02','L97413'
--UNION select 'M00912','2024-05-14','2024-05-17','S58012S'
UNION select 'M00913','G903'
--UNION select 'M00913','2024-09-09','2024-09-13','I63233'
--UNION select 'M00913','2024-06-19','2024-06-23','X788XXS'
--UNION select 'M00913','2024-02-22','2024-02-23','E083533'
--UNION select 'M00913','2024-02-04','2024-02-07','S72479A'
--UNION select 'M00913','2024-11-19','2024-11-20','M05822'
--UNION select 'M00913','2024-01-21','2024-01-25','G8102'

--UNION select 'M00914','2024-08-15','2024-08-16','M488X1'
--UNION select 'M00914','2024-06-30','2024-07-02','L97413'
--UNION select 'M00914','2024-05-14','2024-05-17','S58012S'
--UNION select 'M00915','2024-07-14','2024-07-17','G903'
--UNION select 'M00915','2024-09-09','2024-09-13','I63233'
UNION select 'M00915','X788XXS'
UNION select 'M00915','I63233'
  

insert into @Membership
select 'M00912',			'1985-10-13',	'M',	'CP',		'N',	'N',	'N',		0
UNION 
SELECT 'M00913',			'',	'',	'CN',		'N',	'N',	'N',		1
--UNION 
--SELECT 'M00914',			'1930-06-16',	'F',	'CN',		'N',	'N',	'N',		1
--UNION 
--SELECT 'M00914',			'1959-06-16',	'M',	'D1',		'N',	'N',	'N',		0
UNION 
SELECT 'M00915',			'1969-06-16',	'M',	'cn',		'N',	'N',	'N',		0
--select * from @d
--select * from @M
 

exec [dbo].[sp_RS_Medicare_PartC_Outer] 2025,  @Membership, @DxTable,1

/*
-----------------------------------------------------------------------
--OPTION 2
-----------------------------------------------------------------------
Declare @M as InputMembership_PartC_CMSHCC
Declare @d as [InputDiagnosis]


insert into @d
select * from [dbo].[tbl_dummy_CMSHCC_DiagnosisInput]--You should have this data as user

insert into @M
select * from [dbo].[tbl_dummy_CMSHCC_Membership]-- You should have this data as user


Declare @Output as [OutputMembership_PartC_CMSHCC_Outer]
DECLARE @sql NVARCHAR(MAX)
insert into @Output
exec [dbo].[sp_RS_PartC_CMSHCC_Outer] 2025,  @M, @d

-----------------------------------------------------------------------
drop table if exists #Output
select * into #Output from @Output


*/
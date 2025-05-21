/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_Weights]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_Weights]
GO
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_RXC_NDC]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_RXC_NDC]
GO
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_RXC_Heirarchy]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_RXC_Heirarchy]
GO
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_RXC_HCPCS]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_RXC_HCPCS]
GO
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_Infant_Variables]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_Infant_Variables]
GO
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_ICD_Category_Mapping]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_ICD_Category_Mapping]
GO
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_HCPCS_CPT]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_HCPCS_CPT]
GO
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_HCC_heirarchy]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_HCC_heirarchy]
GO
/****** Object:  StoredProcedure [dbo].[sp_transform_ref_HHS_Adult_Child_Variables]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_transform_ref_HHS_Adult_Child_Variables]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_Medicare_PartC_Validate_Membership]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_Medicare_PartC_Validate_Membership]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_Medicare_PartC_Suspect]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_Medicare_PartC_Suspect]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_Medicare_PartC_Outer]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_Medicare_PartC_Outer]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_Medicare_PartC_ESRD_Inner]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_Medicare_PartC_ESRD_Inner]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_Medicare_PartC_CMSHCC_Inner]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_Medicare_PartC_CMSHCC_Inner]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_HHS_Validate_Membership]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_HHS_Validate_Membership]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_HHS_Outer]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_HHS_Outer]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_HHS_Inner]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_HHS_Inner]
GO
/****** Object:  StoredProcedure [dbo].[sp_RS_HHS]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_RS_HHS]
GO
/****** Object:  StoredProcedure [dbo].[demo_SuspectCall]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[demo_SuspectCall]
GO
/****** Object:  StoredProcedure [dbo].[demo_RAFCall_HHS]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[demo_RAFCall_HHS]
GO
/****** Object:  StoredProcedure [dbo].[demo_RAFCall]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[demo_RAFCall]
GO
/****** Object:  StoredProcedure [dbo].[CallFlaskApi]    Script Date: 21-05-2025 17:56:11 ******/
DROP PROCEDURE IF EXISTS [dbo].[CallFlaskApi]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertySales]') AND type in (N'U'))
ALTER TABLE [dbo].[PropertySales] DROP CONSTRAINT IF EXISTS [FK__PropertyS__Weath__6FB49575]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertySales]') AND type in (N'U'))
ALTER TABLE [dbo].[PropertySales] DROP CONSTRAINT IF EXISTS [FK__PropertyS__Tax_C__6DCC4D03]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertySales]') AND type in (N'U'))
ALTER TABLE [dbo].[PropertySales] DROP CONSTRAINT IF EXISTS [FK__PropertyS__Calen__6EC0713C]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertySales]') AND type in (N'U'))
ALTER TABLE [dbo].[PropertySales] DROP CONSTRAINT IF EXISTS [FK__PropertyS__Build__6CD828CA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PropertySales]') AND type in (N'U'))
ALTER TABLE [dbo].[PropertySales] DROP CONSTRAINT IF EXISTS [FK__PropertyS__Addre__6BE40491]
GO
/****** Object:  Table [dbo].[WeatherStaging]    Script Date: 21-05-2025 17:56:12 ******/
DROP TABLE IF EXISTS [dbo].[WeatherStaging]
GO
/****** Object:  Table [dbo].[Weather]    Script Date: 21-05-2025 17:56:13 ******/
DROP TABLE IF EXISTS [dbo].[Weather]
GO
/****** Object:  Table [dbo].[TempResult]    Script Date: 21-05-2025 17:56:14 ******/
DROP TABLE IF EXISTS [dbo].[TempResult]
GO
/****** Object:  Table [dbo].[TaxClass]    Script Date: 21-05-2025 17:56:15 ******/
DROP TABLE IF EXISTS [dbo].[TaxClass]
GO
/****** Object:  Table [dbo].[SalesStaging]    Script Date: 21-05-2025 17:56:15 ******/
DROP TABLE IF EXISTS [dbo].[SalesStaging]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table9_HHS_Weights]    Script Date: 21-05-2025 17:56:16 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table9_HHS_Weights]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table8_Infant_Variables]    Script Date: 21-05-2025 17:56:17 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table8_Infant_Variables]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table7_Child_Variables]    Script Date: 21-05-2025 17:56:18 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table7_Child_Variables]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table7_8_Adult_Child_Variables]    Script Date: 21-05-2025 17:56:19 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table7_8_Adult_Child_Variables]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table6_Adult_Variables]    Script Date: 21-05-2025 17:56:19 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table6_Adult_Variables]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table4_HCC_Heirarchy]    Script Date: 21-05-2025 17:56:20 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table4_HCC_Heirarchy]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table3_HCC_Category_Mapping]    Script Date: 21-05-2025 17:56:21 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table3_HCC_Category_Mapping]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table2_HCPCS_CPT]    Script Date: 21-05-2025 17:56:22 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table2_HCPCS_CPT]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table11_RXC_Heirarchy]    Script Date: 21-05-2025 17:56:22 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table11_RXC_Heirarchy]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table10b_RXC_HCPCS]    Script Date: 21-05-2025 17:56:23 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table10b_RXC_HCPCS]
GO
/****** Object:  Table [dbo].[ref_stg_HHS_cy2024diytables01072025_Table10a_RXC_NDC]    Script Date: 21-05-2025 17:56:24 ******/
DROP TABLE IF EXISTS [dbo].[ref_stg_HHS_cy2024diytables01072025_Table10a_RXC_NDC]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_CMSHCC_ValidationMessage]    Script Date: 21-05-2025 17:56:25 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_CMSHCC_ValidationMessage]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_CMSHCC_Adjustments]    Script Date: 21-05-2025 17:56:25 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_CMSHCC_Adjustments]
GO
/****** Object:  Table [dbo].[ref_HHS_HCC_Exclusion]    Script Date: 21-05-2025 17:56:26 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_HCC_Exclusion]
GO
/****** Object:  Table [dbo].[RATypeMapping]    Script Date: 21-05-2025 17:56:27 ******/
DROP TABLE IF EXISTS [dbo].[RATypeMapping]
GO
/****** Object:  Table [dbo].[PropertySales]    Script Date: 21-05-2025 17:56:27 ******/
DROP TABLE IF EXISTS [dbo].[PropertySales]
GO
/****** Object:  Table [dbo].[PropertyAddress]    Script Date: 21-05-2025 17:56:28 ******/
DROP TABLE IF EXISTS [dbo].[PropertyAddress]
GO
/****** Object:  Table [dbo].[ManhattanStaging]    Script Date: 21-05-2025 17:56:29 ******/
DROP TABLE IF EXISTS [dbo].[ManhattanStaging]
GO
/****** Object:  Table [dbo].[LookupStaging]    Script Date: 21-05-2025 17:56:29 ******/
DROP TABLE IF EXISTS [dbo].[LookupStaging]
GO
/****** Object:  Table [dbo].[Lookupdata_Staging]    Script Date: 21-05-2025 17:56:30 ******/
DROP TABLE IF EXISTS [dbo].[Lookupdata_Staging]
GO
/****** Object:  Table [dbo].[Calendar]    Script Date: 21-05-2025 17:56:31 ******/
DROP TABLE IF EXISTS [dbo].[Calendar]
GO
/****** Object:  Table [dbo].[BuildingClass]    Script Date: 21-05-2025 17:56:31 ******/
DROP TABLE IF EXISTS [dbo].[BuildingClass]
GO
/****** Object:  View [dbo].[archive_v_HHS_RXC_NDC]    Script Date: 21-05-2025 17:56:32 ******/
DROP VIEW IF EXISTS [dbo].[archive_v_HHS_RXC_NDC]
GO
/****** Object:  View [dbo].[vw_ref_HHS_RXC_Heirarchy]    Script Date: 21-05-2025 17:56:33 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_RXC_Heirarchy]
GO
/****** Object:  View [dbo].[archive_vw_HHS_RXC_Heirarchy]    Script Date: 21-05-2025 17:56:34 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_HHS_RXC_Heirarchy]
GO
/****** Object:  View [dbo].[vw_ref_HHS_RXC_NDC]    Script Date: 21-05-2025 17:56:35 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_RXC_NDC]
GO
/****** Object:  View [dbo].[vw_ref_HHS_RXC_HCPCS]    Script Date: 21-05-2025 17:56:36 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_RXC_HCPCS]
GO
/****** Object:  View [dbo].[vw_ref_HHS_CSR_Adjustments]    Script Date: 21-05-2025 17:56:37 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_CSR_Adjustments]
GO
/****** Object:  Table [dbo].[ref_HHS_CSR_Adjustments]    Script Date: 21-05-2025 17:56:38 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_CSR_Adjustments]
GO
/****** Object:  View [dbo].[vw_ref_HHS_Demographic_Factor]    Script Date: 21-05-2025 17:56:39 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_Demographic_Factor]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_Disease_Interaction]    Script Date: 21-05-2025 17:56:40 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_Disease_Interaction]
GO
/****** Object:  View [dbo].[vw_ref_HHS_Disease_Factor]    Script Date: 21-05-2025 17:56:41 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_Disease_Factor]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_HCC_Heirarchy]    Script Date: 21-05-2025 17:56:41 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_HCC_Heirarchy]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_RXC_Heirarchy]    Script Date: 21-05-2025 17:56:42 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_RXC_Heirarchy]
GO
/****** Object:  Table [dbo].[ref_HHS_RXC_Heirarchy]    Script Date: 21-05-2025 17:56:43 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_RXC_Heirarchy]
GO
/****** Object:  View [dbo].[vw_ref_HHS_ICD_Category_Mapping]    Script Date: 21-05-2025 17:56:44 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_ICD_Category_Mapping]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_ICD_Category_Mapping]    Script Date: 21-05-2025 17:56:44 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_ICD_Category_Mapping]
GO
/****** Object:  Table [dbo].[ref_HHS_ICD_Category_Mapping]    Script Date: 21-05-2025 17:56:45 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_ICD_Category_Mapping]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_Weights]    Script Date: 21-05-2025 17:56:46 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_Weights]
GO
/****** Object:  View [dbo].[vw_ref_HHS_Variable]    Script Date: 21-05-2025 17:56:47 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_Variable]
GO
/****** Object:  Table [dbo].[ref_HHS_Variable]    Script Date: 21-05-2025 17:56:48 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_Variable]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_RXC_NDC]    Script Date: 21-05-2025 17:56:48 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_RXC_NDC]
GO
/****** Object:  Table [dbo].[ref_HHS_RXC_NDC]    Script Date: 21-05-2025 17:56:49 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_RXC_NDC]
GO
/****** Object:  View [dbo].[vw_ref_HHS_HCC_Heirarchy]    Script Date: 21-05-2025 17:56:50 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_HCC_Heirarchy]
GO
/****** Object:  Table [dbo].[ref_HHS_HCC_Heirarchy]    Script Date: 21-05-2025 17:56:51 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_HCC_Heirarchy]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_RXC_HCPCS]    Script Date: 21-05-2025 17:56:52 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_RXC_HCPCS]
GO
/****** Object:  Table [dbo].[ref_HHS_RXC_HCPCS]    Script Date: 21-05-2025 17:56:52 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_RXC_HCPCS]
GO
/****** Object:  View [dbo].[vw_ref_HHS_HCPCS_CPT]    Script Date: 21-05-2025 17:56:53 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_HCPCS_CPT]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_HCPCS_CPT]    Script Date: 21-05-2025 17:56:54 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_HCPCS_CPT]
GO
/****** Object:  Table [dbo].[ref_HHS_HCPCS_CPT]    Script Date: 21-05-2025 17:56:55 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_HCPCS_CPT]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Demographic_Factor]    Script Date: 21-05-2025 17:56:56 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Demographic_Factor]
GO
/****** Object:  View [dbo].[vw_ref_ChronicDefination_HCUP]    Script Date: 21-05-2025 17:56:57 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_ChronicDefination_HCUP]
GO
/****** Object:  Table [dbo].[ref_ChronicDefination_HCUP]    Script Date: 21-05-2025 17:56:57 ******/
DROP TABLE IF EXISTS [dbo].[ref_ChronicDefination_HCUP]
GO
/****** Object:  View [dbo].[vw_ref_HHS_ValidationMessage]    Script Date: 21-05-2025 17:56:58 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_ValidationMessage]
GO
/****** Object:  Table [dbo].[ref_HHS_ValidationMessage]    Script Date: 21-05-2025 17:56:59 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_ValidationMessage]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Norm_And_Coding]    Script Date: 21-05-2025 17:56:59 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Norm_And_Coding]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Model_Inventory]    Script Date: 21-05-2025 17:57:00 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Model_Inventory]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_Model_Inventory]    Script Date: 21-05-2025 17:57:01 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_Model_Inventory]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Interaction_Map]    Script Date: 21-05-2025 17:57:02 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Interaction_Map]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_Interaction_Map]    Script Date: 21-05-2025 17:57:03 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_Interaction_Map]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_ICD_Category_Mapping]    Script Date: 21-05-2025 17:57:04 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_ICD_Category_Mapping]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_ICD_Category_Mapping]    Script Date: 21-05-2025 17:57:04 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_ICD_Category_Mapping]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Hierarchy]    Script Date: 21-05-2025 17:57:05 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Hierarchy]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_Hierarchy]    Script Date: 21-05-2025 17:57:06 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_Hierarchy]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Disease_Group_Map]    Script Date: 21-05-2025 17:57:07 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Disease_Group_Map]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_Disease_Group_Map]    Script Date: 21-05-2025 17:57:08 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_Disease_Group_Map]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Disease_Disability_Factor]    Script Date: 21-05-2025 17:57:09 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Disease_Disability_Factor]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Disease_Count_Factor]    Script Date: 21-05-2025 17:57:10 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Disease_Count_Factor]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor]    Script Date: 21-05-2025 17:57:10 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Demographic_Interation_With_Status_Factor]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Disease_Factor]    Script Date: 21-05-2025 17:57:11 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Disease_Factor]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Disease_Interaction_Factor]    Script Date: 21-05-2025 17:57:12 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Disease_Interaction_Factor]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_Weights]    Script Date: 21-05-2025 17:57:13 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_Weights]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_Weights]    Script Date: 21-05-2025 17:57:14 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_Weights]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_Infant_Severity_Interactions]    Script Date: 21-05-2025 17:57:15 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_Infant_Severity_Interactions]
GO
/****** Object:  View [dbo].[vw_ref_HHS_Adult_Child_EnrolDuration_HCCCount]    Script Date: 21-05-2025 17:57:16 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_Adult_Child_EnrolDuration_HCCCount]
GO
/****** Object:  View [dbo].[vw_ref_HHS_Adult_Child_Variables]    Script Date: 21-05-2025 17:57:17 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_Adult_Child_Variables]
GO
/****** Object:  Table [dbo].[ref_HHS_Adult_Child_Variables]    Script Date: 21-05-2025 17:57:17 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_Adult_Child_Variables]
GO
/****** Object:  View [dbo].[vw_ref_HHS_EnrolDuration_HCCCount]    Script Date: 21-05-2025 17:57:18 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_EnrolDuration_HCCCount]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_Disease_Interactions]    Script Date: 21-05-2025 17:57:19 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_Disease_Interactions]
GO
/****** Object:  View [dbo].[vw_ref_Medicare_PartC_RATypeMapping]    Script Date: 21-05-2025 17:57:20 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_Medicare_PartC_RATypeMapping]
GO
/****** Object:  Table [dbo].[ref_Medicare_PartC_RAType_Mapping]    Script Date: 21-05-2025 17:57:20 ******/
DROP TABLE IF EXISTS [dbo].[ref_Medicare_PartC_RAType_Mapping]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_DiseaseInteraction]    Script Date: 21-05-2025 17:57:21 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_DiseaseInteraction]
GO
/****** Object:  View [dbo].[vw_ref_HHS_Weights]    Script Date: 21-05-2025 17:57:22 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_Weights]
GO
/****** Object:  Table [dbo].[ref_HHS_Weights]    Script Date: 21-05-2025 17:57:23 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_Weights]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_Interactions_Severity]    Script Date: 21-05-2025 17:57:24 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_Interactions_Severity]
GO
/****** Object:  View [dbo].[archive_vw_ref_HHS_Interactions_Group]    Script Date: 21-05-2025 17:57:25 ******/
DROP VIEW IF EXISTS [dbo].[archive_vw_ref_HHS_Interactions_Group]
GO
/****** Object:  Table [dbo].[ref_HHS_Interactions]    Script Date: 21-05-2025 17:57:25 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_Interactions]
GO
/****** Object:  View [dbo].[vw_ref_HHS_Infant_Variables]    Script Date: 21-05-2025 17:57:26 ******/
DROP VIEW IF EXISTS [dbo].[vw_ref_HHS_Infant_Variables]
GO
/****** Object:  Table [dbo].[ref_HHS_Infant_Variables]    Script Date: 21-05-2025 17:57:27 ******/
DROP TABLE IF EXISTS [dbo].[ref_HHS_Infant_Variables]
GO
/****** Object:  UserDefinedFunction [dbo].[RANDBETWEEN]    Script Date: 21-05-2025 17:57:27 ******/
DROP FUNCTION IF EXISTS [dbo].[RANDBETWEEN]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateAge]    Script Date: 21-05-2025 17:57:27 ******/
DROP FUNCTION IF EXISTS [dbo].[CalculateAge]
GO

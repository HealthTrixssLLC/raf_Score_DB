
CREATE VIEW vw_ref_HHS_CSR_Adjustments AS
SELECT 
    HIOS_Variant_ID HIOSID,
    CSR_Level CSRLevel,
    CASE 
        WHEN CSR_Level LIKE '%GOLD%' THEN 'GOLD'
        WHEN CSR_Level LIKE '%SILVER%' THEN 'SILVER'
        WHEN CSR_Level LIKE '%BRONZE%' THEN 'BRONZE'
        WHEN CSR_Level LIKE '%PLATINUM%' THEN 'PLATINUM'
        ELSE NULL
    END AS MetalLevel,
    RA_Software_CSR_Indicator  CSRIndicator,
    CSR_RA_Factor CSR_Factor
FROM ref_HHS_CSR_Adjustments

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'View for CSR (Cost Sharing Reduction) Adjustments reference data', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ref_HHS_CSR_Adjustments';


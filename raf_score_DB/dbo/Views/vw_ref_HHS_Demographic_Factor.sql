
CREATE   View [dbo].[vw_ref_HHS_Demographic_Factor]
as 
SELECT PaymentYear,
    Model,
    Variable,
    IsVariableValid,
    LevelName [MetalLevel],
    [Weight],
    CASE 
        WHEN Variable like 'Mage%' OR Variable like '%Male' then 'M'
        WHEN Variable like 'Fage%'  OR Variable like '%FeMale' then 'F' 
    END as Gender,
    CASE 
        WHEN Variable like 'age0%' THEN 0
        WHEN Variable like 'age1%' THEN 1
        WHEN ISNUMERIC(PARSENAME(REPLACE(Variable, '_', '.'), 2)) = 1 
        THEN CAST(PARSENAME(REPLACE(Variable, '_', '.'), 2) AS INT) 
        ELSE NULL 
    END AS Age_Start,
    CASE 
        WHEN Variable like 'age0%' THEN 0
        WHEN Variable like 'age1%' THEN 1
        WHEN PARSENAME(REPLACE(Variable, '_', '.'), 1) = 'GT' THEN 200
        WHEN ISNUMERIC(PARSENAME(REPLACE(Variable, '_', '.'), 1)) = 1 
        THEN CAST(PARSENAME(REPLACE(Variable, '_', '.'), 1) AS INT) 
        ELSE NULL 
    END AS Age_End,
    CONCAT(
        CASE 
            WHEN Variable like 'age0%' THEN '0'
            WHEN Variable like 'age1%' THEN '1'
            WHEN ISNUMERIC(PARSENAME(REPLACE(Variable, '_', '.'), 2)) = 1 
            THEN PARSENAME(REPLACE(Variable, '_', '.'), 2)
            ELSE '' 
        END,
        '-',
        CASE 
            WHEN Variable like 'age0%' THEN '0'
            WHEN Variable like 'age1%' THEN '1'
            WHEN PARSENAME(REPLACE(Variable, '_', '.'), 1) = 'GT' THEN '200'
            WHEN ISNUMERIC(PARSENAME(REPLACE(Variable, '_', '.'), 1)) = 1 
            THEN PARSENAME(REPLACE(Variable, '_', '.'), 1)
            ELSE '' 
        END
    ) AS AgeBand,
    SourceFile
FROM [dbo].[vw_ref_HHS_Weights]
WHERE Variable LIKE '%age%'
AND Variable NOT LIKE '%SEVERITY%'

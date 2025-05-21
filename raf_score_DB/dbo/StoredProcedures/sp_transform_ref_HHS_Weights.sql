Create Procedure sp_transform_ref_HHS_Weights
As
Insert into ref_HHS_Weights(PaymentYear, Model, Variable, IsVariableValid, LevelName, Weight, Sourcefile)
SELECT   
    [PaymentYear],  
    [Model],  
    [Variable],  
    [IsVariableValid],  
    REPLACE(LevelName,'_Level','') LevelName,  
    Weight,  
    [SourceFile]  
FROM   
    (SELECT   
        [PaymentYear],  
        [Model],  
        [Variable],  
        [IsVariableValid],  
        [Platinum_Level],  
        [Gold_Level],  
        [Silver_Level],  
        [Bronze_Level],  
        [Catastrophic_Level],  
        [SourceFile]  
     FROM [dbo].[ref_stg_HHS_cy2024diytables01072025_Table9_HHS_Weights]) AS SourceTable  
UNPIVOT  
    (Weight FOR LevelName IN ([Platinum_Level], [Gold_Level], [Silver_Level], [Bronze_Level], [Catastrophic_Level])  
    ) AS UnpivotedTable  


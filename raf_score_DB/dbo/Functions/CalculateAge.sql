CREATE FUNCTION [dbo].[CalculateAge] (
    @BirthDate DATE,
    @AsOfDate DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;

    -- Calculate the difference in years
    SET @Age = YEAR(@AsOfDate) - YEAR(@BirthDate);

    -- Adjust if the person hasn't had their birthday yet in the year of @AsOfDate
    IF (MONTH(@AsOfDate) < MONTH(@BirthDate)) 
        OR (MONTH(@AsOfDate) = MONTH(@BirthDate) AND DAY(@AsOfDate) < DAY(@BirthDate))
    BEGIN
        SET @Age = @Age - 1;
    END

    RETURN @Age;
END;

CREATE FUNCTION [Library-Management].fn_BookBorrowingFrequency
(
	@BookID UNIQUEIDENTIFIER
)
RETURNS INT 
AS
BEGIN
	DECLARE @Frequency INT;

	SELECT @Frequency = ISNULL(COUNT(*), 0)
	FROM Loans
	WHERE BookID = @BookID

	RETURN @Frequency;
END;

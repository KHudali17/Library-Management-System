
CREATE FUNCTION [Library-Management].BorrowedBooks
(
	@BorrowerID uniqueidentifier
)
RETURNS TABLE 
AS 
RETURN
(
	WITH BorrowedBookIDs
	AS(
	SELECT [BookID] 
	FROM [Loans]
	WHERE [BorrowerID] = @BorrowerID
	)

	SELECT * 
	FROM [Books]
	WHERE [BookID] IN (SELECT [BookID] FROM BorrowedBookIDs)
);



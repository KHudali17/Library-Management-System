CREATE PROCEDURE [Library-Management].sp_BorrowedBooksReport
	@StartDate DATE,
	@EndDate DATE
AS
BEGIN
	WITH BorrowedBooksWithinDateRange
	AS
	(
		SELECT [Title], [BorrowerID], [DateBorrowed]
		FROM 
			Loans 
			LEFT JOIN 
			Books
			ON Loans.[BookID] = Books.[BookID]
		WHERE [DateBorrowed] < @EndDate 
		  AND [DateBorrowed] > @StartDate 
	)

	SELECT [Title], [FirstName], [LastName], [DateBorrowed]
	FROM 
		BorrowedBooksWithinDateRange AS BBWDR
		LEFT JOIN 
		Borrowers
		ON BBWDR.[BorrowerID] = Borrowers.[BorrowerID]
END;

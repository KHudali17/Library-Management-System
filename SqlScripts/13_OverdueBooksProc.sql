CREATE PROCEDURE OverdueBooks
AS
BEGIN 
	CREATE TABLE #OverdueBorrowers (
		BorrowerID UNIQUEIDENTIFIER,
		FirstName VARCHAR(255),
		LastName VARCHAR(255),
	);

	INSERT INTO #OverdueBorrowers (BorrowerID, FirstName, LastName)
    SELECT DISTINCT
        L.[BorrowerID],
        B.[FirstName],
		B.[LastName]
    FROM 
		Loans AS L
		LEFT JOIN 
		Borrowers AS B 
		ON L.[BorrowerID] = B.[BorrowerID]
    WHERE L.[DueDate] < GETDATE() AND [DateReturned] IS NULL;

	SELECT
        OB.[FirstName],
		OB.[LastName],
		B.[Title],
        L.[DueDate]
    FROM 
		#OverdueBorrowers AS OB
		INNER JOIN Loans AS L 
		ON OB.[BorrowerID] = L.[BorrowerID]
		LEFT JOIN Books as B
		ON L.[BookID] = B.[BookID]
	WHERE L.DueDate < GETDATE() AND [DateReturned] IS NULL
	ORDER BY B.[Title];

	DROP TABLE #OverdueBorrowers;
END;

WITH MoreThanAMonthOverdue AS (
    SELECT L.[BorrowerID], B.[Title]
    FROM Loans AS L
    LEFT JOIN Books AS B ON L.[BookID] = B.[BookID]
    WHERE DATEDIFF(DAY, L.[DueDate], GETDATE()) > 30
)

SELECT B.[FirstName], B.[LastName], B.[Email], M.[Title]
FROM 
	MoreThanAMonthOverdue AS M
	LEFT JOIN Borrowers AS B 
	ON M.[BorrowerID] = B.[BorrowerID]
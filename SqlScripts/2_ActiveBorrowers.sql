
WITH ActiveBorrowers AS 
(
	SELECT [BorrowerID]
	FROM [Loans]
	GROUP BY [BorrowerID]
	HAVING COUNT([BookID]) >= 2
	AND SUM(CASE WHEN [DateReturned] IS NOT NULL THEN 1 ELSE 0 END) = 0
)

SELECT B.[FirstName], B.[LastName], B.[Email]
FROM [Borrowers] B
RIGHT JOIN ActiveBorrowers AB ON B.[BorrowerID] = AB.[BorrowerID];
WITH AuthorBorrowCounts 
AS 
(
    SELECT B.[Author], COALESCE(COUNT(L.[BookID]), 0) AS [BorrowCount]
    FROM 
		Books AS B
		LEFT JOIN 
		Loans AS L 
		ON B.[BookID] = L.[BookID]
    GROUP BY B.[Author]
)

SELECT 
	A.[Author], 
	DENSE_RANK() OVER (ORDER BY A.[BorrowCount] DESC) AS [Rank]
FROM AuthorBorrowCounts AS A
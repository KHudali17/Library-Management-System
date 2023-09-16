WITH BorrowerFrequency AS (
    SELECT
        [BorrowerID],
        COUNT(*) AS BorrowingFrequency
    FROM
        [Loans]
    GROUP BY
        [BorrowerID]
)

SELECT
    B.[FirstName],
	B.[LastName],
    COALESCE(BF.[BorrowingFrequency], 0) AS [Frequency],
    DENSE_RANK() OVER (ORDER BY BF.[BorrowingFrequency] DESC) AS [Rank]
FROM
	[Borrowers] AS B
	LEFT JOIN
    BorrowerFrequency AS BF
	ON BF.[BorrowerID] = B.[BorrowerID];

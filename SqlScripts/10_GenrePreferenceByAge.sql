With BookIdAndAge
AS
(
	SELECT 
		L.[BookID], 
		DATEDIFF(YEAR, B.[DateOfBirth], GETDATE()) AS Age
	FROM 
		Loans AS L
		LEFT JOIN 
		Borrowers AS B
		ON L.[BorrowerID] = B.[BorrowerID]
),

GenreAndAgeGroups
AS
(
	SELECT 
		B.[Genre], 
		(BIA.[Age] -1) / 10 AS AgeGroup
	FROM 
		BookIdAndAge AS BIA
		LEFT JOIN 
		Books AS B
		ON B.[BookID] = BIA.[BookID]
),

GenreCountPerAgeGroup
AS
(
	SELECT 
		[AgeGroup], 
		[Genre], 
		COUNT(*) AS [Count]
	FROM GenreAndAgeGroups
	GROUP BY [AgeGroup], [Genre]
),

RankedGenresPerAgeGroup AS (
    SELECT
        [AgeGroup],
        [Genre],
        DENSE_RANK() OVER (PARTITION BY [AgeGroup] ORDER BY [Count] DESC) AS Rank
    FROM GenreCountPerAgeGroup
) 

SELECT 
	CASE WHEN [AgeGroup] = 0 THEN '0-10'
	     ELSE 
			CAST(1 + [AgeGroup] * 10 AS VARCHAR) 
			+ '-' + 
			CAST(([AgeGroup]+1) * 10 AS VARCHAR)
	END AS [Age Group], 
	[Genre] AS [Most Popular Genre]
FROM RankedGenresPerAgeGroup
WHERE [Rank] = 1
ORDER BY [AgeGroup]

CREATE FUNCTION [Library-Management].MonthlyPopularGenre
(
	@Month INT
)
RETURNS TABLE 
AS 
RETURN
(
	WITH GenreBorrowDateOnMonth AS
	(
		SELECT B.[Genre], YEAR(L.[DateBorrowed]) AS [Year]
		FROM 
			Loans AS L LEFT JOIN Books AS B
			ON L.[BookID] = B.[BookID]
		WHERE DATEPART(MONTH, L.[DateBorrowed]) = @Month
	),

	GenreCountsByYear AS
	(
		SELECT [Year], [Genre], COUNT(*) AS [GenreCount]
		FROM GenreBorrowDateOnMonth
		GROUP BY [Year], [Genre]
	),

	GenrePopularityByYearRanked AS
	(
    SELECT
        [Year], [Genre],
        DENSE_RANK() OVER (PARTITION BY [Year] ORDER BY [GenreCount] DESC) AS [Rank]
    FROM
        GenreCountsByYear
	)

	SELECT [Year], [Genre] AS [Most popular Genre]
	FROM GenrePopularityByYearRanked
	WHERE [Rank] = 1
);

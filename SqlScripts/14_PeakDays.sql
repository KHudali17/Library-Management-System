WITH DayPercentage 
AS 
(
	SELECT 
		DATENAME(weekday, [DateBorrowed]) AS [DayOfWeek], 
		(COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Loans) AS [Percentage]
	FROM Loans
	GROUP BY DATENAME(weekday, [DateBorrowed])
)

SELECT TOP 3 *  
FROM DayPercentage
ORDER BY [Percentage] DESC, [DayOfWeek] ASC;

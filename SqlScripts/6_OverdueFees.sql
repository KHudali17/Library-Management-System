CREATE FUNCTION [Library-Management].fn_CalculateOverdueFees
(
	@LoanID INT
)
RETURNS INT
AS
BEGIN
	DECLARE @DaysOverdue INT;
	SET @DaysOverdue = 
	(
		SELECT 
			CASE 
			    --doesn't need to be retured yet
				WHEN DATEDIFF(DAY, GETDATE(), [DueDate]) >= 0 
				THEN 0
				--not returned, overdue
				WHEN [DateReturned] IS NULL 
				THEN DATEDIFF(DAY, [DueDate], GETDATE())
				--returned, not overdue
				WHEN DATEDIFF(DAY, [DueDate], [DateReturned]) <= 0
				THEN 0
				ELSE
				--returned, overdue
				DATEDIFF(DAY, [DueDate], [DateReturned])
		END AS DaysOverdue
		FROM Loans
		WHERE LoanID = @LoanID
	)

	IF @DaysOverdue = 0 RETURN 0;

	DECLARE @FirstMonthFee INT;
	SET @FirstMonthFee = 1;

	IF @DaysOverdue <= 30 RETURN @DaysOverdue;

	DECLARE @PostFirstMonthFee INT;
	SET @PostFirstMonthFee = 2;

	RETURN (30 * @FirstMonthFee) + ((@DaysOverdue - 30) * @PostFirstMonthFee)
END;


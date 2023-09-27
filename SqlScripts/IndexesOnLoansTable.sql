--The following two columns are used a lot in range queries
CREATE INDEX IX_Loans_DueDate
ON Loans ([DueDate]);

CREATE INDEX IX_Loans_DateBorrowed
ON Loans ([DateBorrowed]);

--These columns aren't used as often, 
--hence why we use a computed column to form an index on.
--we get the benefits of an index at no storage cost, but some extra CPU cost.
ALTER TABLE Loans
ADD PartialBorrowerID AS CAST(SUBSTRING(CONVERT(BINARY(16), BorrowerID), 1, 4) AS BINARY(4));

ALTER TABLE Loans
ADD PartialBookID AS CAST(SUBSTRING(CONVERT(BINARY(16), BookID), 1, 4) AS BINARY(4));

CREATE INDEX IX_Loans_PartialBorrowerID
ON Loans ([PartialBorrowerID]);

CREATE INDEX IX_Loans_PartialBookID
ON Loans ([PartialBookID]);
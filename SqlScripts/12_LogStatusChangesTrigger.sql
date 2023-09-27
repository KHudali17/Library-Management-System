CREATE TRIGGER StatusChangeAudit
ON Books
AFTER UPDATE
AS
BEGIN 
	INSERT INTO AuditLog (BookID, StatusChange, ChangeDate)
	SELECT 
		inserted.[BookID], 
		inserted.[CurrentStatus], 
		GETDATE()
	FROM 
		inserted
		INNER JOIN 
		deleted
		ON inserted.[BookID] = deleted.[BookID]
	WHERE inserted.[CurrentStatus] <> deleted.[CurrentStatus];
END;

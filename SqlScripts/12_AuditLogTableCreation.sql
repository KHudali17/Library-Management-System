use [Library-Management];

CREATE TABLE AuditLog (
	[LogID] INT IDENTITY(1,1) PRIMARY KEY,
	[BookID] UNIQUEIDENTIFIER,
	[StatusChange] varchar(9),
	[ChangeDate] datetime
);

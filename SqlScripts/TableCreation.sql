use [Library-Management];

CREATE TABLE [Books] (
	[BookID] uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
	[Title] varchar(255),
	[ISBN] varchar(17),
	[PublishDate] Date,
	[CurrentStatus] varchar(9) CHECK (CurrentStatus IN ('Available', 'Borrowed')),
	[Author] varchar(255),
	[Genre] varchar(255),
	[ShelfLocation] varchar(50)
);

CREATE TABLE [Borrowers] (
	[BorrowerID] uniqueidentifier PRIMARY KEY DEFAULT NEWID(),
	[FirstName] varchar(255),
	[LastName] varchar(255),
	[Email] varchar(255),
	[DateOfBirth] Date,
	[MemberSince] Date
);

CREATE TABLE [Loans] (
	[LoanID] INT IDENTITY(1,1) PRIMARY KEY,
	[BookID] uniqueidentifier,
	[BorrowerID] uniqueidentifier,
	[DateBorrowed] Date,
	[DueDate] Date,
	[DateReturned] Date

	CONSTRAINT FK_BookID
	FOREIGN KEY (BookID)
	REFERENCES [Books](BookID)
	ON DELETE NO ACTION,

	CONSTRAINT FK_BorrowerID
	FOREIGN KEY (BorrowerID)
	REFERENCES [Borrowers](BorrowerID)
	ON DELETE SET NULL
);
CREATE PROCEDURE [Library-Management].AddNewBorrower
	@FirstName VARCHAR(255),
	@LastName VARCHAR(255),
	@Email VARCHAR(255),
	@DateOfBirth DATE,
	@MemberSince DATE,
	@BorrowerID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Borrowers WHERE [Email] = @Email)
		BEGIN
			RAISERROR('Email already exists in the table.', 16, 0);
			RETURN;
		END;
	
	SET @BorrowerID = NEWID();

	INSERT INTO Borrowers 
	(BorrowerID, FirstName, LastName, Email, DateOfBirth, MemberSince) 
	VALUES 
	(@BorrowerID, @FirstName, @LastName, @Email, @DateOfBirth, @MemberSince);
	RETURN 0;
END;

# Library Management System Database Project

## Background

This project aims to design and implement a relational database for a local library's management system. 
The system includes entities like Books, Borrowers, and Loans, which are stored in a Microsoft SQL Server (MS SQL) database. 
The database supports library operations, tracks loan details, and offers extensive querying capabilities.

### 1. List of Borrowed Books

**Task**: This is realized in a function named BorrowedBooks that takes a BorrowerID as input and returns a table of borrowed books associated with that ID. It uses a CTE called BorrowedBookIDs to retrieve the BookID values from the Loans table for the specified borrower and then selects the corresponding books from the Books table based on those BookID values.

### 2. Active Borrowers with CTEs

**Task**: This is achieved with a CTE named ActiveBorrowers which identifies borrowers who have borrowed two or more books and have not returned any of them. A right join is then performed between the Borrowers table and the ActiveBorrowers CTE on BorrowerID to retrieve the first name, last name, and email of these active borrowers.

### 3. Borrowing Frequency using Window Functions

**Task**: This is achieved with a CTE named BorrowerFrequency that calculates the borrowing frequency for each borrower by counting the number of loans they have made and groups the results by BorrowerID. Then, the main query selects the names of borrowers from the Borrowers table (first and last). It also retrieves the borrowing frequency from the BorrowerFrequency CTE, using COALESCE to handle cases where there are no records in the CTE, defaulting to 0. Finally, DENSE_RANK() assigns a rank to each borrower based on their borrowing frequency. The ranking is done in descending order, so borrowers with the highest borrowing frequency will have the lowest rank. Here we use DENSE_RANK() to allow a natural ranking that permits ties.

### 4. Popular Genre Analysis using Joins and Window Functions

**Task**: This is realized in a function named MonthlyPopularGenre that takes an input @Month and returns a table with the most popular genre for each year within that specified month. The CTE GenreBorrowDateOnMonth retrieves the genre and year of books borrowed in the specified month. It joins the Loans table with the Books table using BookID and filters the results to include only records with a DateBorrowed in the given month. Then the CTE GenreCountsByYear calculates the count of each genre for each year from the results of GenreBorrowDateOnMonth. After that, The CTE GenrePopularityByYearRanked assigns a rank to each genre within each year using the DENSE_RANK() function, partitioned by year and ordered by the genre count in descending order. Again, here we use DENSE_RANK() to permit ties. Finally, the main query selects the year and the most popular genre (where the rank is 1) from the GenrePopularityByYearRanked CTE for each year.

### 5. Stored Procedure - Add New Borrowers

**Task**: This is realized in a procedure named AddNewBorrower that takes parameters FirstName, LastName, Email, DateOfBirth, and MemberSince, and generates a unique BorrowerID as an output parameter if insertion is successful. The procedure first checks if an email address already exists in the Borrowers table. If an email match is found, it raises an error with the message "Email already exists in the table. If the email is not already in use, the procedure generates a new unique BorrowerID using the NEWID() function. Then, the procedure inserts the new borrower into the Borrowers table and returns 0 on success.

### 6. Database Function - Calculate Overdue Fees

**Task**: This is realized in a function named fn_CalculateOverdueFees that takes a @LoanID as input and returns the overdue fees on that loan. If the book is not overdue, it returns 0. If the book is overdue by up to 30 days, it charges $1 per day. If the book is overdue by more than 30 days, it charges $2 per day for the additional days.

### 7. Database Function - Book Borrowing Frequency

**Task**: This is realized in a function named fn_BookBorrowingFrequency that takes @BookID as input and returns the number of times it has been borrowed. It initializes a variable @Frequency to store the borrowing frequency. It then counts the number of times the book with the specified BookID appears in the Loans table.

### 8. Overdue Analysis

**Task**: This is achieved with a CTE named MoreThanAMonthOverdue that selects borrowers and the titles of books that are overdue by more than 30 days. It performs a LEFT JOIN between the Loans table and the Books table based on the BookID, filtering records where the difference in days between the DueDate and the current date is greater than 30. Then, the main query retrieves the first name, last name, and email address of borrowers from the Borrowers table. It also joins this information with the results from the MoreThanAMonthOverdue CTE based on the BorrowerID.

### 9. Author Popularity using Aggregation

**Task**: This is achieved with a CTE named AuthorBorrowCounts that calculates the borrowing count for each author. It performs a LEFT JOIN between the Books table and the Loans table based on the BookID. It then counts the number of times each book by a particular author has been borrowed. The COALESCE function is used to handle cases where there are no borrowing records, defaulting to 0. Then, the main query selects the author's name from the AuthorBorrowCounts CTE. It also uses the DENSE_RANK() function to assign a rank to each author based on their borrowing count. Authors with the highest borrowing counts will have the lowest rank; ties are permitted and natural ranking is preserved by DENSE_RANK().

### 10. Genre Preference by Age using Group By and Having

**Task**: This is achieved with a series of CTEs. The first of which, BookIdAndAge, calculates the age of borrowers. The second, GenreAndAgeGroups, joins the BookIdAndAge with the Books table based on the BookID. It also calculates the age group for each borrowing record, where each age group spans ten years. For example, age group 0 represents ages 0-10, age group 1 represents ages 11-20, and so forth. The third CTE GenreCountPerAgeGroup calculates the count of books borrowed for each genre within each age group. It groups the results by age group and genre. The fourth CTE, RankedGenresPerAgeGroup, assigns a rank to each genre within each age group based on the borrowing count. The DENSE_RANK() function is used to determine the rank. The final query selects the most popular genre for each age group and formats the age group labels. It uses a CASE statement to display the age groups in the format "0-10", "11-20", and so on. It filters the results to only include the genres with the highest rank (Rank = 1) in each age group and orders the results by age group; ties are permitted.

### 11. Stored Procedure - Borrowed Books Report

**Task**: This is realized in a procedure named sp_BorrowedBooksReport that takes two input parameters: @StartDate and @EndDate, specifying the desired date range. The CTE named BorrowedBooksWithinDateRange retrieves the book title, borrower ID, and borrowing date of books borrowed within the date range. It performs a LEFT JOIN between the Loans table and the Books table based on the BookID and filters the records to include only those with borrowing dates falling within the specified date range. The main query selects columns Title, FirstName, LastName, and DateBorrowed from the BorrowedBooksWithinDateRange CTE. It performs a LEFT JOIN with the Borrowers table to retrieve the borrower's name based on their BorrowerID.

### 12. Update Trigger

**Task**: This is realized in a trigger named StatusChangeAudit that executes AFTER UPDATE on the Books table. It inserts into the AuditLog table the columns BookID, StatusChange which correspond to the columns being updated in the Books table. It also inserts the DATETIME of the update. The data being inserted is selected from the inserted pseudo-table and the deleted pseudo-table. The INNER JOIN between inserted and deleted is based on the BookID to match the old and new records for the same book. The WHERE clause filters the records to only include those where the CurrentStatus in the inserted table is different from the CurrentStatus in the deleted table. This ensures that only actual status changes are logged.

### 13. SQL Stored Procedure with Temp Table

**Task**: This is realized in a store procedure named OverdueBooks. It begins by creating a temporary table #OverdueBorrowers with columns BorrowerID, FirstName, and LastName. This table will be used to store information about borrowers who have overdue books. The procedure then inserts records into the #OverdueBorrowers table by selecting distinct BorrowerID, FirstName, and LastName from the Loans table and the Borrowers table. It performs a LEFT JOIN between Loans and Borrowers based on the BorrowerID and filters the records to include only those where the due date (DueDate) is in the past (< GETDATE()) and the book has not been returned. Next, the procedure selects FirstName, LastName, Title and DueDate by performing joins between #OverdueBorrowers, Loans, and Books. Again, it filters the records to include only those where the due date is in the past and the book has not been returned. The results are ordered by book title for clarity. Finally, the temporary table #OverdueBorrowers is dropped to clean up after the procedure has completed its task.

### Bonus Task - Weekly Peak Days

**Task**: This is achieved with a CTE named DayPercentage that extracts day of the week from date and calculates the percentage by dividing the count of loans for each day by the total count of loans in the Loans table, grouping by day of the week. The main query selects the top three records from the DayPercentage CTE using the TOP 3 clause. It orders the selected records in descending order of percentage and ascending order of day of the week.


--Remove duplicates that were not accounted for in the seeding process.
UPDATE Borrowers
SET Email = 'amanda58@example.com'
WHERE BorrowerID = 'D0F1E200-C527-4B95-82F0-E5AF2E5F981C';

UPDATE Borrowers
SET Email = 'awilson1@example.org'
WHERE BorrowerID = 'ECA3CAE0-1B74-46F8-96FA-93BA58CED94D';

UPDATE Borrowers
SET Email = 'dhayes1@example.net'
WHERE BorrowerID = '0CC3B457-2698-4843-9AA2-EEE531EA0EAA';

CREATE UNIQUE INDEX UK_Borrowers_Email
ON Borrowers ([Email]);
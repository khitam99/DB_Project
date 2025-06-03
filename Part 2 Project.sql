-- ============================
-- DB Project Part 2
-- ============================

-- Advanced SELECT Queries

-- 1. Top 3 most loaned books
SELECT TOP 3 Book.Title, COUNT(*) AS LoanCount
FROM Loan
JOIN Book ON Loan.BookID = Book.BookID
GROUP BY Book.Title
ORDER BY LoanCount DESC;

-- 2. Member loan history
SELECT m.FullName, b.Title, l.LoanDate, l.ReturnDate
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
JOIN Member m ON l.MemberID = m.MemberID
WHERE m.MemberID = 1;

-- 3. Book reviews with member names
SELECT m.FullName, r.Comments
FROM Review r
JOIN Member m ON r.MemberID = m.MemberID
WHERE r.BookID = 4;

-- 4. Staff in a given library
SELECT s.FullName, s.Position
FROM Staff s
WHERE s.LibraryID = 2;

-- 5. Books within price range
SELECT * FROM Book
WHERE Price BETWEEN 5 AND 15;

-- 6. Active loans (not returned)
SELECT m.FullName, b.Title, l.LoanDate
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID
WHERE l.Status = 'Issued';

-- 7. Members who paid fines
SELECT DISTINCT m.FullName
FROM FinePayment p
JOIN Loan l ON p.LoanID = l.LoanID
JOIN Member m ON l.MemberID = m.MemberID;

-- 8. Books never reviewed
SELECT b.Title
FROM Book b
LEFT JOIN Review r ON b.BookID = r.BookID
WHERE r.ReviewID IS NULL;

-- 9. Member loan history with status
SELECT b.Title, l.Status
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
WHERE l.MemberID = 1;

-- 10. Members who never borrowed books
SELECT m.FullName
FROM Member m
LEFT JOIN Loan l ON m.MemberID = l.MemberID
WHERE l.LoanID IS NULL;

-- 11. Books never loaned
SELECT b.Title
FROM Book b
LEFT JOIN Loan l ON b.BookID = l.BookID
WHERE l.LoanID IS NULL;

-- 12. All payments with member and book
SELECT m.FullName, b.Title, p.Amount
FROM FinePayment p
JOIN Loan l ON p.LoanID = l.LoanID
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID;

-- 13. Overdue loans
SELECT m.FullName, b.Title, l.DueDate
FROM Loan l
JOIN Member m ON l.MemberID = m.MemberID
JOIN Book b ON l.BookID = b.BookID
WHERE l.Status = 'Overdue';

-- 14. Loan count per book
SELECT COUNT(*) AS LoanCount
FROM Loan
WHERE BookID = 4;

-- 15. Total fines paid by member
SELECT SUM(p.Amount) AS TotalFines
FROM FinePayment p
JOIN Loan l ON p.LoanID = l.LoanID
WHERE l.MemberID = 1;

-- 16. Book stats in a library
SELECT
    COUNT(CASE WHEN IsAvailable = 1 THEN 1 END) AS AvailableBooks,
    COUNT(CASE WHEN IsAvailable = 0 THEN 1 END) AS UnavailableBooks
FROM Book
WHERE LibraryID = 1;

-- 17. Top-rated reviewed books
SELECT b.Title
FROM Book b
JOIN Review r ON b.BookID = r.BookID
GROUP BY b.Title
HAVING COUNT(r.ReviewID) > 5 AND AVG(r.Rating) > 4.5;

-- SQL Views

-- View 1: Available books
CREATE OR ALTER VIEW ViewAvailableBooks AS
SELECT Title, Genre, Price
FROM Book
WHERE IsAvailable = 1;

-- View 2: Active members in past 12 months
CREATE OR ALTER VIEW ViewActiveMembers AS
SELECT *
FROM Member
WHERE DATEDIFF(MONTH, MembershipStartDate, GETDATE()) <= 12;

-- View 3: Library contact info
CREATE OR ALTER VIEW ViewLibraryContacts AS
SELECT Name, ContactNumber
FROM Library;

-- Transactions Simulation
BEGIN TRANSACTION;
BEGIN TRY
    -- Insert loan
    INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, Status)
    VALUES (1, 2, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    -- Update book availability
    UPDATE Book SET IsAvailable = 0 WHERE BookID = 2;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;

-- Aggregation Queries

-- 1. Total books per genre
SELECT Genre, COUNT(*) AS TotalBooks FROM Book GROUP BY Genre;

-- 2. Average rating per book
SELECT BookID, AVG(Rating) AS AvgRating FROM Review GROUP BY BookID;

-- 3. Total fines per member
SELECT l.MemberID, SUM(p.Amount) AS TotalPaid
FROM FinePayment p
JOIN Loan l ON p.LoanID = l.LoanID
GROUP BY l.MemberID;

-- 4. Highest payment made
SELECT MAX(Amount) AS HighestPayment FROM FinePayment;

-- 5. Number of loans per member
SELECT MemberID, COUNT(*) AS LoanCount FROM Loan GROUP BY MemberID;

-- ================================================
-- DDL: Create Tables
-- ================================================

CREATE TABLE Library (
    LibraryID INT PRIMARY KEY IDENTITY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    ContactNumber VARCHAR(20),
    EstablishedYear INT
);

CREATE TABLE Book (
    BookID INT PRIMARY KEY IDENTITY,
    LibraryID INT,
    ISBN VARCHAR(20) UNIQUE,
    Title VARCHAR(150) NOT NULL,
    Genre VARCHAR(50) CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(10,2) CHECK (Price > 0),
    IsAvailable BIT DEFAULT 1,
    ShelfLocation VARCHAR(20),
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Member (
    MemberID INT PRIMARY KEY IDENTITY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    MembershipStartDate DATE NOT NULL
);

CREATE TABLE Loan (
    LoanID INT PRIMARY KEY IDENTITY,
    MemberID INT,
    BookID INT,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status VARCHAR(20) DEFAULT 'Issued' CHECK (Status IN ('Issued', 'Returned', 'Overdue')),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY IDENTITY,
    LoanID INT,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) CHECK (Amount > 0),
    Method VARCHAR(50) NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY,
    LibraryID INT,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    ContactNumber VARCHAR(20),
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Review (
    ReviewID INT PRIMARY KEY IDENTITY,
    MemberID INT,
    BookID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT DEFAULT 'No comments',
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ================================================
-- DML: Insert Sample Data
-- ================================================

-- Insert Data into Library
INSERT INTO Library (Name, Location, ContactNumber, EstablishedYear)
VALUES 
('Central Library', 'Downtown', '123-456-7890', 1995),
('Northside Branch', 'North Avenue', '321-654-0987', 2005),
('Eastside Community Library', 'Eastside Blvd', '555-1212', 2010);


-- Insert Data into Staff

INSERT INTO Staff (LibraryID, FullName, Position, ContactNumber)
VALUES 
(1, 'Jane Doe', 'Librarian', '555-1010'),
(1, 'Sam Green', 'Assistant Librarian', '555-1020'),
(2, 'John Roe', 'Librarian', '555-2020'),
(3, 'Emily Blue', 'Manager', '555-3030');

-- Insert Data into Members

INSERT INTO Member (FullName, Email, PhoneNumber, MembershipStartDate)
VALUES 
('Alice Johnson', 'alice@example.com', '555-1234', '2023-01-10'),
('Bob Smith', 'bob@example.com', '555-5678', '2023-03-20'),
('Carol Lee', 'carol@example.com', '555-9012', '2023-04-15'),
('David Park', 'david@example.com', '555-3456', '2023-06-01'),
('Eva Brown', 'eva@example.com', '555-7890', '2023-08-10'),
('Frank White', 'frank@example.com', '555-6789', '2023-10-05');


-- Insert Data into Books

INSERT INTO Book (LibraryID, ISBN, Title, Genre, Price, ShelfLocation)
VALUES 
(1, '978-3-16-148410-0', 'Database Design', 'Reference', 45.99, 'R1-S1'),
(1, '978-0-13-110362-7', 'C Programming', 'Reference', 39.99, 'R1-S2'),
(1, '978-0-7432-7356-5', 'The Road', 'Fiction', 18.00, 'F1-S5'),
(2, '978-1-86197-876-9', 'Harry Potter', 'Fiction', 25.00, 'F2-S4'),
(2, '978-0-06-112008-4', 'To Kill a Mockingbird', 'Fiction', 20.00, 'F1-S3'),
(2, '978-0-525-47546-1', 'Atomic Habits', 'Non-fiction', 22.50, 'NF1-S2'),
(3, '978-1-250-30651-4', 'The Silent Patient', 'Fiction', 21.99, 'F3-S1'),
(3, '978-0-452-28423-4', '1984', 'Fiction', 15.99, 'F3-S2'),
(3, '978-0-374-15846-9', 'Children’s Stories', 'Children', 12.00, 'CH-S3'),
(1, '978-0-19-852663-6', 'Advanced SQL', 'Reference', 50.00, 'R2-S1');


-- Insert Data into Loans

INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, ReturnDate, Status)
VALUES 
(1, 1, '2024-05-01', '2024-05-14', '2024-05-13', 'Returned'),
(2, 4, '2024-05-03', '2024-05-17', NULL, 'Overdue'),
(3, 2, '2024-05-10', '2024-05-24', NULL, 'Issued'),
(4, 3, '2024-05-11', '2024-05-25', '2024-05-20', 'Returned'),
(5, 5, '2024-05-12', '2024-05-26', NULL, 'Issued'),
(6, 6, '2024-05-13', '2024-05-27', '2024-05-28', 'Returned'),
(1, 7, '2024-05-15', '2024-05-29', NULL, 'Issued'),
(2, 8, '2024-05-16', '2024-05-30', NULL, 'Issued'),
(3, 9, '2024-05-17', '2024-06-01', NULL, 'Issued'),
(4, 10, '2024-05-18', '2024-06-02', NULL, 'Issued');


-- Insert Data into FinePayment

INSERT INTO FinePayment (LoanID, PaymentDate, Amount, Method)
VALUES 
(1, '2024-05-20', 5.00, 'Cash'),
(2, '2024-05-21', 10.00, 'Credit Card'),
(6, '2024-05-29', 3.50, 'Cash'),
(4, '2024-05-22', 2.00, 'Debit Card');

-- Insert Data into Review

INSERT INTO Review (MemberID, BookID, Rating, Comments, ReviewDate)
VALUES 
(1, 1, 5, 'Very helpful book', '2024-05-10'),
(2, 4, 4, 'Great read', '2024-05-12'),
(3, 2, 5, 'Best C language reference.', '2024-05-15'),
(4, 3, 3, 'A bit slow, but good.', '2024-05-18'),
(5, 5, 4, 'Loved the characters.', '2024-05-20'),
(6, 6, 5, 'Highly motivational.', '2024-05-22');


-- Simulate Real Application Behavior


-- Mark a book as returned
UPDATE Loan
SET ReturnDate = '2024-05-29', Status = 'Returned'
WHERE LoanID = 5;

-- Update loan status to overdue manually
UPDATE Loan
SET Status = 'Overdue'
WHERE LoanID = 8;

-- Delete a review (simulate user regret)
DELETE FROM Review
WHERE ReviewID = 4;

-- Delete a payment (simulate admin correction)
DELETE FROM FinePayment
WHERE PaymentID = 3;

-- Mark book availability based on return
UPDATE Book
SET IsAvailable = 1
WHERE BookID = 5;

UPDATE Book
SET IsAvailable = 0
WHERE BookID IN (7, 8, 9, 10); -- still on loan


-- ================================================
-- DQL: Querying the Database
-- ================================================

SELECT L.LoanID, M.FullName, B.Title, L.DueDate
FROM Loan L
JOIN Member M ON L.MemberID = M.MemberID
JOIN Book B ON L.BookID = B.BookID
WHERE L.Status = 'Overdue';

SELECT BookID, Title
FROM Book
WHERE IsAvailable = 0;

SELECT M.FullName, COUNT(L.LoanID) AS TotalLoans
FROM Member M
JOIN Loan L ON M.MemberID = L.MemberID
GROUP BY M.FullName
HAVING COUNT(L.LoanID) > 2;

SELECT B.Title, AVG(R.Rating) AS AvgRating
FROM Book B
JOIN Review R ON B.BookID = R.BookID
GROUP BY B.Title;

SELECT Genre, COUNT(*) AS TotalBooks
FROM Book
WHERE LibraryID = 1
GROUP BY Genre;

SELECT FullName
FROM Member
WHERE MemberID NOT IN (SELECT DISTINCT MemberID FROM Loan);

SELECT M.FullName, SUM(P.Amount) AS TotalFines
FROM Member M
JOIN Loan L ON M.MemberID = L.MemberID
JOIN Payment P ON L.LoanID = P.LoanID
GROUP BY M.FullName;

SELECT M.FullName, B.Title, R.Rating, R.Comments, R.ReviewDate
FROM Review R
JOIN Member M ON R.MemberID = M.MemberID
JOIN Book B ON R.BookID = B.BookID;

----------------------------------------------------

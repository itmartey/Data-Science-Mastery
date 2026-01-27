-- Library Management Project

-- Creating Branch Table 
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
		branch_id VARCHAR(10) PRIMARY KEY,
		manager_id VARCHAR(10),
		branch_address VARCHAR(25),
		contact_no VARCHAR(10)
	);

ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(20);
	
-- Creating Employees Table 
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
		emp_id VARCHAR(10) PRIMARY KEY,
		emp_name VARCHAR(25),
		job_position VARCHAR(25),
		salary INT,
		branch_id VARCHAR(15) --FK

	);

ALTER TABLE employees
ALTER COLUMN salary TYPE FLOAT;
	
-- Creating Books Table
DROP TABLE IF EXISTS books;
CREATE TABLE books(
		isbn VARCHAR(25) PRIMARY KEY,
		book_title VARCHAR(75),
		category VARCHAR(15),
		rental_price FLOAT,
		status VARCHAR(15),
		author VARCHAR(55),
		publisher VARCHAR(55)

	);

ALTER TABLE BOOKS 
ALTER COLUMN category TYPE varchar(20);

-- Creating the Members Table
DROP TABLE IF EXISTS members;
CREATE TABLE members(
		member_id VARCHAR(10) PRIMARY KEY,
		member_name VARCHAR(25),
		member_address VARCHAR(55),
		reg_date DATE

	);

-- Creating the Issued Status Table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
		issued_id VARCHAR(10) PRIMARY KEY, 
		issued_member_id VARCHAR(10), --FK
		issued_book_name VARCHAR(75),
		issued_date DATE,
		issued_book_isbn VARCHAR(55), --FK
		issued_emp_id VARCHAR(10) --FK

	);


--Creating The Return Status Table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
		return_id VARCHAR(10) PRIMARY KEY,
		issued_id VARCHAR(10), --FK
		return_book_name VARCHAR(75),
		return_date DATE,
		return_book_isbn VARCHAR(25)

	);
	
--FOREIGN KEY 
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;


-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

--Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '484 Cran St'
WHERE member_address ='789 Oak St';
SELECT * FROM members;

/* Task 3: Delete a Record from the Issued Status Table 
Objective: Delete the record with issued_id = 'IS121' from the issued_status table */
DELETE FROM issued_status
WHERE issued_id = 'IS121';
SELECT * FROM issued_status;

/* Task 4: Retrieve All Books Issued by a Specific Employee 
Objective: Select all books issued by the employee with emp_id = 'E101'. */
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

/* Task 5: List Members Who Have Issued More Than One Book 
Objective: Use GROUP BY to find members who have issued more than one book. */
SELECT 
	issued_emp_id,
	COUNT(issued_emp_id) AS issued_count
FROM issued_status
GROUP BY 1
HAVING COUNT(issued_emp_id) > 1;

/* Task 6: Create Summary Tables.
Use CTAS to generate new tables based on query results - each book and total book_issued_cnt */
CREATE TABLE book_issued_cnts
AS
SELECT 
	b.isbn,
	b.book_title,
	COUNT(ist.issued_id) AS no_issued
FROM books AS b
JOIN
issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2;

-- Task 7. Retrieve All Books in a Specific Category
 SELECT * FROM books
 WHERE category = 'Classic';

 -- Task 8: Find Total Rental Income by Category:
 SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;

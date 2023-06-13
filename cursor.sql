/*Cursor is a Temporary Memory or Temporary Work Station. 
It is Allocated by Database Server at the Time of Performing DML operations on Table by User. 
Cursors are used to store Database Tables. There are 2 types of Cursors: 
Implicit Cursors, and Explicit Cursors. 
Implicit Cursors:
Implicit Cursors are also known as Default Cursors of SQL SERVER. 
These Cursors are allocated by SQL SERVER when the user performs DML operations.
Explicit Cursors :
Explicit Cursors are Created by Users whenever the user requires them. 
Explicit Cursors are used for Fetching data from Table in Row-By-Row Manner.*/


/*SQL Cursor Life Cycle:
The following steps are involced in a SQL cursor life cycle. 
Declaring Cursor:
A cursor is declared by defining the SQL statement.
DECLARE cursor_name CURSOR
    FOR select_statement;
To declare a cursor, you specify its name after the DECLARE keyword with the CURSOR data type 
and provide a SELECT statement that defines the result set for the cursor.
Opening Cursor:
A cursor is opened for storing data retrieved from the result set.
Fetching Cursor:
When a cursor is opened, rows can be fetched from the cursor one by one or in a block to do data manipulation.
Closing Cursor:
The cursor should be closed explicitly after data manipulation.
Deallocating Cursor:
Cursors should be deallocated to delete cursor definition and release all the system resources associated with the cursor.*/


/*Why use a SQL Cursor?
In relational databases, operations are made on a set of rows. 
For example, a SELECT statement returns a set of rows which is called a result set. 
Sometimes the application logic needs to work with one row at a time rather than the 
entire result set at once. This can be done using cursors.*/


/*Syntax of a Cursor
DECLARE @Variable  nvarchar(50)  # Declare All Required Variables  
DECLARE Cursor_Name CURSOR       # Declare Cursor Name
 [LOCAL | GLOBAL]               # Define  Cursor Scope  
 [FORWARD_ONLY | SCROLL]                # Define  Movement Direction  of Cursor 
 [ KEYSET | DYNAMIC |STATIC | FAST_FORWARD] # Define basic type of cursor   
 [  SCROLL_LOCKS | OPTIMISTIC |READ_ONLY ]    #   Define Locks 
 
 OPEN Cursor_Name               # Open Cursor 
 FETCH NEXT FROM Cursor_Name    #  Fetch data From Cursor  
Implement SQL QUery                          
 CLOSE Cursor_Name              #  Clsoe The Cursor               
DEALLOCATE Cursor_Name          # Deallocate all resources and Memory */  


 /*Cursor Scope
Microsoft SQL Server supports the GLOBAL and LOCAL keywords on the DECLARE CURSOR 
statement to define the scope of the cursor name.
GLOBAL - specifies that the cursor name is global to the connection.
LOCAL - specifies that the cursor name is local to the Stored Procedure, trigger, 
or query that holds the cursor.*/


/*Data Fetch Option in Cursors
Microsoft SQL Server supports the following two fetch options for data:
FORWARD_ONLY - Specifies that the cursor can only be scrolled from the first to the last row.
SCROLL - It provides 6 options to fetch the data (FIRST, LAST, PRIOR, NEXT, RELATIVE, and ABSOLUTE).*/
  
/*Types of cursors
Microsoft SQL Server supports the following 4 types of cursors.
STATIC CURSOR
A static cursor populates the result set during cursor creation and the query 
result is cached for the lifetime of the cursor. A static cursor can move forward and backward.
FAST_FORWARD
This is the default type of cursor. It is identical to the static except that 
you can only scroll forward.
DYNAMIC
In a dynamic cursor, additions and deletions are visible for others in the data 
source while the cursor is open.
KEYSET
This is similar to a dynamic cursor except we can't see records others add. 
If another user deletes a record, it is inaccessible from our recordset. */


/*Types of Locks
Locking is the process by which a DBMS restricts access to a row in a multi-user environment. 
When a row or column is exclusively locked, other users are not permitted to access the locked 
data until the lock is released. It is used for data integrity. This ensures that two users 
cannot simultaneously update the same column in a row.
Microsoft SQL Server supports the following three types of Locks.
READ ONLY
Specifies that the cursor cannot be updated.
SCROLL_LOCKS
Provides data integrity into the cursor. It specifies that the cursor will lock the rows 
as they are read into the cursor to ensure that updates or deletes made using the cursor will succeed.
OPTIMISTIC
Specifies that the cursor does not lock rows as they are read into the cursor. 
So, the updates or deletes made using the cursor will not succeed if the row has been 
updated outside the cursor. */

use univdb;

CREATE TABLE Employees
(
 EmpID int PRIMARY KEY,
 EmpName varchar (50) NOT NULL,
 Salary int NOT NULL,
 Address varchar (200) NOT NULL
);
INSERT INTO Employees(EmpID,EmpName,Salary,Address) VALUES(1,'Mohan',12000,'Noida');
INSERT INTO Employees(EmpID,EmpName,Salary,Address) VALUES(2,'Pavan',25000,'Delhi');
INSERT INTO Employees(EmpID,EmpName,Salary,Address) VALUES(3,'Amit',22000,'Dehradun');
INSERT INTO Employees(EmpID,EmpName,Salary,Address) VALUES(4,'Sonu',22000,'Noida');
INSERT INTO Employees(EmpID,EmpName,Salary,Address) VALUES(5,'Deepak',28000,'Gurgaon');
SELECT * FROM Employees;

delimiter $$
drop procedure if exists cur$$
create procedure cur()
begin
DECLARE EMP_ID, EMP_SALARY, done INT; 
DECLARE EMP_NAME, EMP_CITY VARCHAR(50);
  
DECLARE EMP_CURSOR CURSOR for     #Declare Cursor 
SELECT * FROM Employees;  
OPEN EMP_CURSOR;               #Open the Cursor
FETCH NEXT FROM EMP_CURSOR INTO  EMP_ID ,EMP_NAME,EMP_SALARY,EMP_CITY;  #Fetch the next record from the cursor
myloop: loop
select concat('EMP_ID: ', cast(EMP_ID as CHAR),  '  EMP_NAME ',EMP_NAME ,'  EMP_SALARY '  ,cast(EMP_SALARY as CHAR)  ,  '  EMP_CITY ' ,EMP_CITY) as output;  
FETCH NEXT FROM EMP_CURSOR INTO  EMP_ID ,EMP_NAME,EMP_SALARY,EMP_CITY;  #Fetch the next record from the cursor 
if EMP_ID=null then
leave myloop;
end if;
end loop myloop;
CLOSE EMP_CURSOR;  #Close the cursor
DEALLOCATE prepare EMP_CURSOR; #Deallocate the cursor
end$$
call cur();
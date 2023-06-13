use univdb;

/*What is Exception
An error occurs during the program execution is called Exception in PL/SQL.
PL/SQL facilitates programmers to catch such conditions using exception block 
in the program and an appropriate action is taken against the error condition.*/

/*Types:
There are three type of exceptions:
1. Internally defined exceptions are errors which arise from the Oracle Database environment. 
The runtime system raises the internally defined exceptions automatically. 
ORA-27102 (out of memory) is one example of Internally defined exceptions. Note that 
Internally defined exceptions do not have names, but an error code.
2. Predefined exceptions are errors which occur during the execution of the program. The predefined 
exceptions are internally defined exceptions that PL/SQL has given names e.g., NO_DATA_FOUND, TOO_MANY_ROWS.

Exception                      Raised when....
DUP_VAL_ON_INDEX         When you try to insert a duplicate value into a unique column.
INVALID_CURSOR             It occurs when we try accessing an invalid cursor.
INVALID_NUMBER              On usage of something other than number in place of number value.
LOGIN_DENIED              At the time when user login is denied.
TOO_MANY_ROWS              When a select query returns more than one row and the destination variable can take only single value.
VALUE_ERROR                  When an arithmetic, value conversion, truncation, or constraint error occurs.
CURSOR_ALREADY_OPEN           Raised when we try to open an already open cursor.

3. User-defined exceptions are custom exception defined by users like you. User-defined exceptions 
must be raised explicitly.

The following table illustrates the differences between exception categories.

Category - Definer -  Has Error Code - Has Name - Raised Implicitly - Raised Explicitly
Internally defined - Runtime system - Always - Only if you assign one -    Yes - Optionally
Predefined - Runtime system - Always - Always - Yes - Optionally
User-defined - User - Only if you assign one - Always -    No - Always*/

/* Declare a handler:
To declare a handler, you use the  DECLARE HANDLER statement as follows:

DECLARE action HANDLER FOR condition_value statement;
If a condition whose value matches the  condition_value , MySQL will execute the statement 
and continue or exit the current code block based on the action .

The action accepts one of the following values:
1. CONTINUE :  the execution of the enclosing code block ( BEGIN … END ) continues.
2. EXIT : the execution of the enclosing code block, where the handler is declared, terminates.

The  condition_value specifies a particular condition or a class of conditions that activate the handler. 
The  condition_value accepts one of the following values:
1. A MySQL error code.
2. A standard SQLSTATE value. Or it can be an SQLWARNING , NOTFOUND or SQLEXCEPTION condition, 
which is shorthand for the class of SQLSTATE values. The NOTFOUND condition is used for a cursor 
or  SELECT INTO variable_list statement.
3. A named condition associated with either a MySQL error code or SQLSTATE value.

The statement could be a simple statement or a compound statement enclosing by the BEGIN and END keywords.*/

/*MySQL error handling examples:
1. The following handler set the value of the  hasError variable to 1 and continue the execution 
if an SQLEXCEPTION occurs:

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET hasError = 1;

2. The following handler rolls back the previous operations, issues an error message, and exit 
the current code block in case an error occurs. If you declare it inside the BEGIN END block of a 
stored procedure, it will terminate the stored procedure immediately.
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SELECT 'An error has occurred, operation rollbacked and the stored procedure was terminated';
END;

3. The following handler sets the value of the  RowNotFound variable to 1 and continues execution 
if there is no more row to fetch in case of a cursor or SELECT INTO statement:

DECLARE CONTINUE HANDLER FOR NOT FOUND 
SET RowNotFound = 1;

4. If a duplicate key error occurs, the following handler issues an error message and continues execution.
DECLARE CONTINUE HANDLER FOR 1062
SELECT 'Error, duplicate key occurred';*/
#################################################################################

desc students;
delimiter $$
drop procedure if exists nullchk;
CREATE PROCEDURE nullchk()
BEGIN
    -- exit if the null occurs
    DECLARE EXIT HANDLER FOR 1364
    BEGIN
     SELECT ('roll number, student name cant be null') AS message;
    END;
    
    -- insert a new row into students
    #INSERT INTO students(roll_no, course) VALUES(1, 'JAVA');
    #INSERT INTO students(course) VALUES('JAVA');
    INSERT INTO students(student_name, course) VALUES('priya', 'JAVA');
    
END$$

CALL nullchk;

#====================================================================
delimiter $$
drop procedure if exists notable$$
CREATE PROCEDURE notable()
BEGIN
    -- exit if the null occurs
    DECLARE EXIT HANDLER FOR 1146
    BEGIN
     SELECT ('used table not exists') AS message;
    END;
    
    -- insert a new row into student
    INSERT INTO student(student_name, course) VALUES('priya', 'JAVA');
    
END$$
CALL notable;
#===================================================================
delimiter $$
drop procedure if exists table_exists$$
CREATE PROCEDURE table_exists()
BEGIN
    -- exit if table already exists
    DECLARE EXIT HANDLER FOR 1050
    BEGIN
     SELECT ('table already exists') AS message;
    END;
    
    create table students (sturoll int);
    
END$$
CALL table_exists;
#===================================================================
delimiter $$
drop procedure if exists unknown_col$$
CREATE PROCEDURE unknown_col()
BEGIN
    -- exit if the column does not exists
    DECLARE EXIT HANDLER FOR 1054
    BEGIN
     SELECT ('column does not exists') AS message;
    END;
    
    INSERT INTO students(roll_no, student_name, courses) VALUES(1, 'priya', 'JAVA');
END$$
CALL unknown_col();
#===================================================================
delimiter $$
drop procedure if exists stu_add_chk;
CREATE PROCEDURE stu_add_chk(stu_id int, stu_address varchar (20))
 BEGIN
   DECLARE stu_count INT;
   DECLARE address_count INT; 

  -- check if student exists
   SELECT COUNT(*) INTO stu_count
   FROM students
   WHERE roll_no = stu_id;
   
  IF stu_count != 1 THEN 
     SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT = 'stu_id not found in students table.';
   END IF;
   
  -- check if address exists
   SELECT COUNT(*) INTO address_count
   FROM students
   WHERE address = stu_address;

  IF address_count != 1 THEN 
     SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT = 'stu_address not found in students table.';
   END IF; 
END$$
call stu_add_chk(1,'mumbai');
call stu_add_chk(2,'USA');
#======================================================================
#First, create a new table named SupplierProducts for the demonstration:
drop table if exists SupplierProducts;
CREATE TABLE SupplierProducts (
    supplierId INT,
    productId INT,
    PRIMARY KEY (supplierId , productId)
);

#Second, create a stored procedure that inserts product id and supplier id into the SupplierProducts table:
delimiter $$
drop procedure if exists InsertSupplierProduct;
CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT, 
    IN inProductId INT
)
BEGIN
    -- exit if the duplicate key occurs
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
     SELECT CONCAT('Duplicate key (',inSupplierId,',',inProductId,') occurred') AS message;
    END;
    
    -- insert a new row into the SupplierProducts
    INSERT INTO SupplierProducts(supplierId,productId)
    VALUES(inSupplierId,inProductId);
    
    -- return the products supplied by the supplier id
    SELECT COUNT(*) 
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;

END$$
CALL InsertSupplierProduct(1,1);
CALL InsertSupplierProduct(1,2);
CALL InsertSupplierProduct(1,3);

CALL InsertSupplierProduct(1,3);
/*Because the handler is an EXIT handler, the last statement does not execute:
SELECT COUNT(*) 
FROM SupplierProducts
WHERE supplierId = inSupplierId;*/

#==================================================================================
#If  you change the EXIT in the handler declaration to CONTINUE , you will also get the number of products provided by the supplier:
DROP PROCEDURE IF EXISTS InsertSupplierProduct;
DELIMITER $$
CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT, 
    IN inProductId INT
)
BEGIN
    -- exit if the duplicate key occurs
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
    SELECT CONCAT('Duplicate key (',inSupplierId,',',inProductId,') occurred') AS message;
    END;
    
    -- insert a new row into the SupplierProducts
    INSERT INTO SupplierProducts(supplierId,productId)
    VALUES(inSupplierId,inProductId);
    
    -- return the products supplied by the supplier id
    SELECT COUNT(*) 
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;
    
END$$

CALL InsertSupplierProduct(1,3);
#==================================================================================    
DROP PROCEDURE IF EXISTS InsertSupplierProduct;
DELIMITER $$
CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT, 
    IN inProductId INT
)
BEGIN
    -- exit if the duplicate key occurs
    DECLARE EXIT HANDLER FOR 1062 SELECT 'Duplicate keys error encountered' Message; 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'SQLException encountered' Message; 
    DECLARE EXIT HANDLER FOR SQLSTATE '23000' SELECT 'SQLSTATE 23000' ErrorCode;
    
    -- insert a new row into the SupplierProducts
    INSERT INTO SupplierProducts(supplierId,productId)
    VALUES(inSupplierId,inProductId);
    
    -- return the products supplied by the supplier id
    SELECT COUNT(*) 
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;
    
END$$

CALL InsertSupplierProduct(1,3);
#===================================================================================
/*Using a named error condition:
MySQL provides you with the DECLARE CONDITION statement that declares a named error condition, 
which associates with a condition.
Here is the syntax of the DECLARE CONDITION statement:

DECLARE condition_name CONDITION FOR condition_value;

The condition_value  can be a MySQL error code such as 1146 or a SQLSTATE value. 
The condition_value is represented by the condition_name .

After the declaration, you can refer to condition_name instead of condition_value .*/

DROP PROCEDURE IF EXISTS TestProc;
DELIMITER $$
CREATE PROCEDURE TestProc()
BEGIN
    DECLARE TableNotFound CONDITION for 1146 ; 

    DECLARE EXIT HANDLER FOR TableNotFound 
    SELECT 'Please create table abc first' Message; 
    SELECT * FROM abc;
END$$
call TestProc();





use univdb;
/*Parameter IN example:
In the following procedure, we have used a IN parameter 
'var1' (type integer) which accept a number from the user.*/
DELIMITER $$
DROP PROCEDURE IF EXISTS my_proc_IN$$
CREATE PROCEDURE my_proc_IN (IN var1 INT)
BEGIN
SELECT * FROM students LIMIT var1;
END$$
CALL my_proc_in(2);

/*Parameter OUT example: It is used to pass a parameter as output. Its value can be 
changed inside the stored procedure, and the changed (new) value is passed back to 
the calling program. It is noted that a procedure cannot access the OUT parameter's 
initial value when it starts.*/
/*In the body of the procedure, the parameter will get the highest fees 
from fees column. After calling the procedure the word OUT tells the DBMS 
that the value goes out from the procedure. Here highest_fees is the name 
of the output parameter and we have passed its value to a session variable named 
@F, in the CALL statement.*/
DELIMITER $$
DROP PROCEDURE IF EXISTS my_proc_out$$
CREATE PROCEDURE my_proc_OUT (OUT highest_fees INT)
BEGIN
SELECT MAX(fees) INTO highest_fees FROM students;
END$$
CALL my_proc_OUT(@F);
SELECT @F;


/*Parameter INOUT example: It is a combination of IN and OUT parameters. 
It means the calling program can pass the argument, and the procedure can 
modify the INOUT parameter, and then passes the new value back to the calling program.*/
DELIMITER $$
DROP PROCEDURE IF EXISTS my_proc_inout$$
CREATE PROCEDURE my_proc_INOUT (INOUT stu_address varchar(10), IN stu_add varchar(10))
BEGIN
SELECT COUNT(address) INTO stu_address FROM students WHERE address = stu_add;
END$$
CALL my_proc_INOUT(@a,'delhi');
SELECT @a;

CREATE TABLE studentMarks (stud_id SMALLINT(5) NOT NULL AUTO_INCREMENT PRIMARY KEY, total_marks INT, grade VARCHAR(5));
#insert sample data
INSERT INTO studentMarks(total_marks, grade) VALUES(450, 'A'), (480, 'A+'), (490, 'A++'), (440, 'B+'),(400, 'C+'),(380,'C')
,(250, 'D'),(200,'E'),(100,'F'),(150,'F'),(220, 'E');
select * from studentMarks;

 

DELIMITER $$
DROP PROCEDURE IF EXISTS stored_proc_AverageMarks$$
CREATE PROCEDURE stored_proc_AverageMarks(OUT average DECIMAL(5,2))
BEGIN
    SELECT AVG(total_marks) INTO average FROM studentMarks;
END$$
CALL stored_proc_AverageMarks(@average_marks)$$
SELECT @average_marks$$

 

#Suppose we want to find the count of students who is having marks below the average marks of all the students.
DELIMITER //
DROP PROCEDURE IF EXISTS stored_proc_CountOfBelowAverage//
CREATE PROCEDURE stored_proc_CountOfBelowAverage(OUT countBelowAverage INT)
BEGIN
    DECLARE avgMarks DECIMAL(5,2) DEFAULT 0;
    SELECT AVG(total_marks) INTO avgMarks FROM studentMarks;
    SELECT COUNT(*) INTO countBelowAverage FROM studentMarks WHERE total_marks < avgMarks;
END //
CALL stored_proc_CountOfBelowAverage(@countBelowAverage);
SELECT @countBelowAverage;

 

#Updation of SP
#We are creating a new procedure with no comments.
DELIMITER //
DROP PROCEDURE IF EXISTS stored_proc_AlterProcTutorial//
CREATE PROCEDURE stored_proc_AlterProcTutorial()
BEGIN
    SELECT "Hello World!";
END //
ALTER PROCEDURE stored_proc_AlterProcTutorial COMMENT 'altering comments!';
SHOW CREATE PROCEDURE stored_proc_AlterProcTutorial;

/*nested SP:
We will call a procedure from another procedure to return the overall result of a student. 
If student marks are above average – then the result would be PASS else – FAIL*/
/*First, is named GetIsAboveAverage would return a Boolean value if the student marks are above average or not.*/
/*Second one is named GetStudentResult – It will pass studentId as input (IN) and expect result as output (OUT) parameter.*/
DELIMITER $$
DROP PROCEDURE IF EXISTS stored_proc_GetIsAboveAverage$$
CREATE PROCEDURE stored_proc_GetIsAboveAverage(IN studentId INT, OUT isAboveAverage BOOLEAN)
BEGIN
    DECLARE avgMarks DECIMAL(5,2) DEFAULT 0;
    DECLARE studMarks INT DEFAULT 0;
    SELECT AVG(total_marks) INTO avgMarks FROM studentMarks;
    SELECT total_marks INTO studMarks FROM studentMarks WHERE stud_id = studentId; 
    IF studMarks > avgMarks THEN
        SET isAboveAverage = TRUE;
    ELSE
        SET isAboveAverage = FALSE;
    END IF;
END$$
DELIMITER $$
DROP PROCEDURE IF EXISTS stored_proc_GetStudentResult$$
CREATE PROCEDURE stored_proc_GetStudentResult(IN studentId INT, OUT result VARCHAR(20))
BEGIN
      -- nested stored procedure call
    CALL stored_proc_GetIsAboveAverage(studentId, @isAboveAverage);
    IF @isAboveAverage = 0 THEN
        SET result = "FAIL";
    ELSE
        SET result = "PASS";
    END IF;
END$$
CALL stored_proc_GetStudentResult(2,@result); #The average marks for all the entries in studentTable is 323.6
SELECT @result;
CALL stored_proc_GetStudentResult(10,@result);
SELECT @result;

 

/*We want to write a procedure to take studentId and depending on the studentMarks 
we need to return the class according to the below criteria.
Marks >= 400 : Class – First Class
Marks >= 300 and Marks < 400 – Second Class
Marks < 300 – Failed*/
DELIMITER $$
DROP PROCEDURE IF EXISTS stored_proc_GetStudentClass$$
CREATE PROCEDURE stored_proc_GetStudentClass(IN studentId INT, OUT class VARCHAR(20))
BEGIN
    DECLARE marks INT DEFAULT 0;
    SELECT total_marks INTO marks FROM studentMarks WHERE stud_id = studentId;
        IF marks >= 400 THEN
        SET class = "First Class";
    ELSEIF marks >=300 AND marks < 400 THEN
        SET class = "Second Class";
    ELSE
        SET class = "Failed";
    END IF;
END$$
CALL stored_proc_GetStudentClass(1,@class);
SELECT @class; #For student ID – 1 – total_marks are 450 – hence the expected result is FIRST CLASS.
CALL stored_proc_GetStudentClass(6,@class);
SELECT @class; #For student ID – 6 – total_marks is 380 – Hence the expected result is SECOND CLASS.
CALL stored_proc_GetStudentClass(11,@class);
SELECT @class; #For student ID – 11 – total_marks are 220 – Hence expected result is FAILED.

#two i/p
delimiter @%
DROP PROCEDURE IF EXISTS checkstu@%
CREATE PROCEDURE checkstu (IN stunm varchar(10), IN adds varchar(10)) 
BEGIN 
   SELECT * FROM students 
   WHERE student_name=stunm 
   AND address=adds; 
end@% 
call checkstu('sanjay','mumbai');

 
#IN and multiple OUT
drop table if exists orders;
CREATE TABLE orders (
order_id INT NOT NULL primary key,
customer_id VARCHAR(50),
order_date DATE,
shipped_date DATE,
delivery_date DATE,
order_status ENUM('pending','canceled','shipped','delivered') NOT NULL DEFAULT 'pending'
)
COMMENT='Order Table';
describe orders;
SELECT table_comment FROM INFORMATION_SCHEMA.TABLES WHERE table_name='orders';

insert into orders values (001, 'c01', '2020-01-15', '2020-01-25', '2020-01-30', 'pending'), 
                          (002, 'c02', '2021-01-15', '2021-01-25', '2021-01-30', 'canceled'),
                          (003, 'c03', '2019-01-15', '2019-01-25', '2019-01-30', 'shipped'),
                          (004, 'c04', '2018-01-15', '2018-01-25', '2018-01-30', 'delivered');
select * from orders;
DELIMITER $$
DROP PROCEDURE IF EXISTS proc_getCustomerOrders$$
CREATE PROCEDURE proc_getCustomerOrders(
IN custid varchar(10),
OUT pending INT,
OUT shipped INT,
OUT canceled INT,
OUT delivered INT
)
BEGIN
-- pending
SELECT count(*) INTO pending
FROM orders
WHERE customer_id = custid AND order_status = 'pending';

-- shipped
SELECT count(*) INTO shipped
FROM orders
WHERE customer_id = custid AND order_status = 'shipped';

-- canceled
SELECT count(*) INTO canceled
FROM orders
WHERE customer_id = custid AND order_status = 'canceled';

-- delivered
SELECT count(*) INTO delivered
FROM orders
WHERE customer_id = custid AND order_status = 'delivered';

END $$
CALL proc_getCustomerOrders('c01',@pending,@shipped,@canceled,@delivered);
SELECT @pending,@shipped,@canceled,@delivered;
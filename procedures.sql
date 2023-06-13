/*A procedure (often called a stored procedure) is a subroutine like a subprogram in a regular computing language, 
stored in database. A procedure has a name, a parameter list, and SQL statement(s). */

/*The delimiter is the character or string of characters which is used to complete an SQL statement. 
By default we use semicolon (;) as a delimiter. But this causes problem in stored procedure because a 
procedure can have many statements, and everyone must end with a semicolon. So for your delimiter, 
pick a string which is rarely occur within statement or within procedure. Here we have 
used double dollar sign i.e. $$.You can use whatever you want. */

 

use unidb;
select * from students; 
/*creating a procedure*/
DELIMITER $$
DROP PROCEDURE IF EXISTS address_selection; #just for safety
CREATE PROCEDURE address_selection()
SELECT * FROM students where address = 'mumbai';
$$
/* calling a procedure*/
call address_selection(); #like function calling 

 

/*Local variables are declared within stored procedures and are only valid within the 
BEGIN…END block where they are declared. Local variables can have any SQL data type. 
The following example shows the use of local variables in a stored procedure.*/
/*BEGIN ... END block is used to write compound statements, 
i.e. when you need more than one statement within stored programs*/
DELIMITER $$
DROP PROCEDURE IF EXISTS my_procedure_Local_Variables;
CREATE PROCEDURE my_procedure_Local_Variables()
BEGIN   /* declare local variables */   
DECLARE a INT DEFAULT 10;   
DECLARE b, c INT;    /* using the local variables */   
SET a = a + 100;   
SET b = 2;   
SET c = a + b;    
BEGIN      /* local variable in nested block */      
DECLARE c INT;             
SET c = 5;       
/* local variable c takes precedence over the one of the          
same name declared in the enclosing block. */       
SELECT a, b, c;   
END;    
SELECT a, b, c;
END$$
CALL my_procedure_Local_Variables();

/*In MySQL stored procedures, user variables are referenced with an ampersand (@) prefixed 
to the user variable name (for example, @x and @y). The following example shows the use of 
user variables within the stored procedure :*/
DELIMITER $$
DROP PROCEDURE IF EXISTS my_procedure_user_Variables;
CREATE PROCEDURE my_procedure_User_Variables()
BEGIN   
SET @x = 15;       
SET @y = 10;       
SELECT @x, @y, @x-@y;   
END$$
CALL my_procedure_user_Variables();

 
use unidb;

/*if......then*/
DELIMITER $$
DROP PROCEDURE IF EXISTS my_procedure_if_then;
CREATE PROCEDURE my_procedure_if_then()
BEGIN 
set @a = 10; 
  # check the boolean condition using if statement  
   IF( @a < 20 ) THEN 
  #if condition is true then print the following   
      select 'a is less than 20 ' as output; 
   END IF; 
   select concat ('value of a is : ', @a) as value_of_a; 
end$$
call my_procedure_if_then();

 

#while (exit controlled loop) (for is entry controlled loop)
DELIMITER $$
DROP PROCEDURE IF EXISTS my_proc_WHILE$$  #if we give ; at end it gives sync error
CREATE PROCEDURE my_proc_WHILE()
BEGIN
    declare n int; #delaring local variable
    set n:=0;
    WHILE n < 5 do
    SELECT n;
    SET n := n +1;
    END while;
end$$
call my_proc_WHILE();


DELIMITER $$
DROP PROCEDURE IF EXISTS my_proc_WHILE;
CREATE PROCEDURE my_proc_WHILE()
begin
declare x int default 1;
WHILE x<5
do
select (x);  
SET x = x + 1;   
END WHILE;
END$$
CALL my_proc_WHILE();

 
use unidb;
Delimiter $$
DROP PROCEDURE IF EXISTS While_Loop;
CREATE PROCEDURE While_Loop()
BEGIN
DECLARE A INT;
DECLARE XYZ Varchar(50);
SET A = 1;
SET XYZ = '';
WHILE A <=10 DO
SET XYZ = CONCAT(XYZ,A,',');  #initially xyz is blank, we get "1," and then "1,2,"
SET A = A + 1;
END WHILE;
SELECT XYZ;
END$$
call While_Loop();

 

#while with leave
Delimiter $$
DROP PROCEDURE IF EXISTS While_Loop$$
CREATE PROCEDURE While_Loop()
begin
DECLARE Counter INT; 
SET Counter=1;
mywhile: WHILE (Counter <= 10)
do
  select concat( 'The counter value is = ' , Counter);
  IF Counter >=5 then
  leave mywhile;      #leaving the while loop
  END if;
SET Counter  = Counter  + 1;
end while mywhile;
END$$
call While_Loop();

 

#Loop
drop table if exists table1;
CREATE TABLE table1 (value VARCHAR(50) NULL DEFAULT NULL);  #we can ignore the null default null, wil work even withouit it
DELIMITER $$ 
DROP PROCEDURE IF EXISTS ADD1$$  #remember to put $$ in end of sentence
CREATE PROCEDURE ADD1()
 BEGIN
  DECLARE a INT Default 1 ;
  simple_loop: LOOP          #loop index
    insert into table1 values(a);
    SET a=a+1;
    IF a=11 THEN
      LEAVE simple_loop;
    END IF;
 END LOOP simple_loop;
END $$
CALL ADD1();
Select value from table1;

 

DELIMITER $$
DROP PROCEDURE IF EXISTS LoopDemo;
CREATE PROCEDURE LoopDemo()
BEGIN
    DECLARE x  INT;
    DECLARE str  VARCHAR(255);
    SET x = 1;
    SET str =  '';
    loop_label:  LOOP
        IF  x > 10 THEN 
            LEAVE  loop_label;
        END  IF;
          SET  x = x + 1;
        IF  (x mod 2) THEN
            ITERATE  loop_label;
        ELSE
            SET  str = CONCAT(str,x,',');
        END  IF;
    END LOOP;
    SELECT str;
END$$
call LoopDemo();



CREATE DATABASE CarShop;
USE CarShop;
DROP TABLE IF EXISTS Cars;
CREATE TABLE Cars
(
Id INT PRIMARY KEY,
Name VARCHAR (50) NOT NULL,
Price INT
);

select * from cars;
Delimiter $$
DROP PROCEDURE IF EXISTS While_Loop$$
CREATE PROCEDURE While_Loop()
begin
DECLARE count INT;
SET count = 1;
WHILE count<= 10 do
   INSERT INTO Cars VALUES(count, concat('Car-',CAST(count as char)), count*100);  #we're changing count to char so we can concatenate
   SET count = count + 1;
END while;
end$$
call while_loop();
select * from cars;


#paging using while
Delimiter $$
DROP PROCEDURE IF EXISTS While_Loop$$
CREATE PROCEDURE While_Loop()
begin
DECLARE count INT;
SET count = 0;
   
WHILE count< 10 do
   SELECT * FROM Cars limit 2 offset count;  #stmnt valid when not using loop also #offset is where we want to tsrat(starting index) and limit is till which index we want to fetch
   SET count = count + 2;  #count is 0,2,4,6,8
END while;
end$$
call while_loop();

    
USE unidb;
DROP TABLE IF EXISTS SampleTable;
CREATE TABLE SampleTable
(Id INT, CountryName VARCHAR(100), ReadStatus TINYINT);
INSERT INTO SampleTable ( Id, CountryName, ReadStatus)
Values (1, 'Germany', 0),
        (2, 'France', 0),
        (3, 'Italy', 0),
     (4, 'Netherlands', 0),
       (5, 'Poland', 0);
select * from sampletable;


Delimiter $$
DROP PROCEDURE IF EXISTS While_Loop$$
CREATE PROCEDURE While_Loop()
BEGIN
DECLARE Counter, MaxId INT; 
DECLARE ContName VARCHAR(100);
set counter = (Select min(Id) from sampletable);
set maxID = (Select max(Id) from sampletable);
set contname='';
select counter, maxID;

WHILE(Counter <= MaxId)
do
   SET ContName = concat(contname , (select CountryName FROM SampleTable WHERE Id = Counter), ' ');
   SET Counter  = Counter  + 1;        
END while;
select ContName;  
end$$
call While_Loop();


#nested SP
Delimiter $$
DROP PROCEDURE IF EXISTS nestedsp$$
CREATE PROCEDURE nestedsp()
BEGIN
DECLARE Counter, MaxId INT;
DECLARE ContName VARCHAR(100);
set counter = (SElect min(Id) from sampletable);
set maxID = (SElect max(Id) from sampletable);
set contname='';
select counter, maxID;
call loopdemo();  #this is a previous procedure and it displays output
end$$
call nestedsp();

select * from students;
select fees,
if (address = 'mumbai', 'valid', 'invalid') as checking
from students;                            #we are just using 'if' in single line no else and stmnts and stuff 


#nested procedure example 
drop table if exists nptable;
create table nptable (name varchar (100));
Delimiter $$
DROP PROCEDURE IF EXISTS np$$
CREATE PROCEDURE np()
BEGIN
insert into nptable values(@contname);
end$$;

Delimiter $$
DROP PROCEDURE IF EXISTS While_Loop$$
CREATE PROCEDURE While_Loop()
BEGIN
DECLARE Counter, MaxId INT; 
DECLARE ContName VARCHAR(100);
set counter = (SElect min(Id) from sampletable);
set maxID = (SElect max(Id) from sampletable);
set @contname='';     #if we use user varibale @name the scope isn't just within begin to end
#select counter, maxID; 

while (Counter <= MaxId) do
   SET @ContName = (select CountryName FROM SampleTable WHERE Id = Counter);
   call np();
   SET Counter  = Counter  + 1;        
END while;
end$$
call While_Loop();
select * from nptable;





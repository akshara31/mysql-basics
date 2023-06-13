CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Books
(
ID INT(1),
Name VARCHAR(50),
Price INT(10)
);

SHOW TABLES;
DESC BOOKS;

ALTER TABLE BOOKS
ADD PRIMARY KEY(ID);

ALTER TABLE BOOKS
ADD YEAR year;

ALTER TABLE BOOKS
MODIFY COLUMN Price FLOAT(10,2);

ALTER TABLE BOOKS
ADD PUBLISHER VARCHAR(50),
ADD AUTHORNAME VARCHAR(50);

DESC BOOKS;

ALTER TABLE BOOKS
RENAME COLUMN AUTHORNAME TO FIRSTNAME,
ADD LASTNAME VARCHAR(50);

DESC BOOKS;

ALTER TABLE BOOKS RENAME BOOK_DETAILS;

SHOW TABLES;

ALTER TABLE BOOK_DETAILS
MODIFY Name VARCHAR(50) NOT NULL;

SHOW DATABASES;

DROP TABLE BOOK_DETAILS;

CREATE TABLE BOOK_DETAILS
(
ID INT PRIMARY KEY,
NAME VARCHAR(50),
DESCRIPTION BLOB);

DESC BOOK_DETAILS;

#2
show databases;
create database univdb;
use univdb;
create table students
(roll_no int primary key,
student_name varchar(150) not null,
course varchar(150));
insert into students
values(1,"ashish","java");
insert into students
values(2,"rahul","C++");
insert into students
(roll_no, student_name, course)
values(3,"raju","C");
insert into students
(roll_no, student_name)
values(4,"AI");
insert into students
values(5,"sagar","C");
insert into students
values(6,"sagar","C++");

create table students2
(roll_no int primary key,
student_name varchar(150) not null,
course varchar(150));

insert into students2
select roll_no,student_name,course
from students where roll_no=2;

alter table students2
add address varchar(50); 

insert into students2
select *
from students where roll_no=1;

insert into students2
select roll_no, student_name,course
from students where roll_no=1;


#select
 
select * from students;
select roll_no,course from students;
select * from students where course is null;
select * from students where course is not null;
select * from students where course='C';
select roll_no,student_name from students where roll_no>3;
select roll_no,student_name from students where roll_no<3;
select roll_no,student_name from students where roll_no<>3;
select * from students where student_name in ('rohit','sagar');
select * from students where student_name like 'r%';
select * from univdb.students;
select distinct student_name from students;
select distinct roll_no,student_name from students;
select distinct student_name,course from students;
select count(distinct student_name) from students;
select * from students where student_name='raju' and course='C';
select * from students where student_name='raju' or course='C++';
select * from students where student_name like 's%' or course='C';
select * from students where not student_name='raju';

select * from students where student_name like 'r%' and (course='C' or roll_no between 2 and 4);
select * from students where student_name like 'r%' and not course='c';


select * from students order by student_name;
select * from students order by student_name desc;
select * from students order by student_name,course;

#aggregate func
select min(roll_no) as firstrollno from students;
select min(roll_no) from students;
select max(roll_no) as lastrollno from students;
select min(course) as firstcourse, max(course) as lastcourse from students;

select count(roll_no) from students;
select avg(roll_no) from students;
select sum(roll_no) from students; #null values are ignored

select count(roll_no) as '#',course
from students
group by course;

select count(roll_no),course
from students 
group by course
order by count(roll_no) desc;

select count(roll_no),course
from students 
group by course
having count(roll_no)>1;  #with having, we can use aggregate func

select * from students;

update students
set student_name='alfred',course='ML'
where roll_no=2;

select * from students;

update students
set student_name='rohit'
where roll_no=4;

select * from students;

update students
set student_name='puja';
where course='C++';

select * from students;

delete from students where student_name='alfred';
delete from students2;
select * from students2;

truncate table students;


#3
CREATE DATABASE Employee;
USE Employee;

CREATE TABLE Employee
(ID INT(2) PRIMARY KEY,
NAME VARCHAR(20) NOT NULL,
AGE INT(3),
DOJ DATE,
ADDRESS VARCHAR(20),
SALARY INT(6));

INSERT INTO Employee
VALUES(1,'Prabhat',25,'2019-07-12','Delhi',25000);

INSERT INTO Employee
VALUES(2,'Rimpa',27,'2021-01-25','Mumbai',20000);

INSERT INTO Employee
VALUES(3,'Saikat',31,'2020-09-24','Kolkata',30000);

INSERT INTO Employee
VALUES(4,'Sagar',29,'2020-05-08','Delhi',34000);

INSERT INTO Employee
VALUES(5,'Naina',30,'2019-02-07','Delhi',29000);

INSERT INTO Employee
VALUES(6,'Rahul',28,'2020-06-04','Mumbai',27000);

SELECT * FROM Employee;

ALTER TABLE Employee
CHANGE DOJ Date_of_Joining DATE;

DESC Employee;

SELECT * FROM Employee WHERE AGE<=30 AND SALARY>=20000;

SELECT NAME,AGE FROM Employee WHERE AGE BETWEEN 30 AND 31;

SELECT NAME, MAX(SALARY) FROM Employee;

SELECT ADDRESS AS 'Location', COUNT(ADDRESS) AS 'No. Of Employees' FROM Employee GROUP BY ADDRESS;

UPDATE Employee
SET SALARY=28000 
WHERE ADDRESS='Kolkata';

SELECT * FROM Employee;

SELECT * FROM Employee ORDER BY SALARY DESC;

SELECT ADDRESS AS 'Location', COUNT(ADDRESS) AS 'No. Of Employee'
FROM Employee GROUP BY ADDRESS HAVING COUNT(NAME)>2;

SELECT SUM(SALARY) AS 'Total Employee Salary' FROM Employee;



#ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mysql';




use univdb;
create table students 
(roll_no int primary key,
student_name varchar(150) not null,
course varchar(150),
address varchar (50),
Fees int(10),
phone int);
insert into students
values (1, 'Raju', 'C', 'chennai', 2000, 451-250);
insert into students
values (2, 'sanjay', 'C++', 'mumbai', 2500, 321-487);
insert into students
values (3, 'partha', 'java', 'delhi', 2100, 123-456);
insert into students
values (4, 'puja', 'C', 'mumbai', 2000, 365-741);
insert into students
values (7, 'nikhil', 'C', 'chennai', 2000, 758-962);
insert into students
values (8, 'rahul', 'java', 'noida', 2100, 259-741);
insert into students
values (9, 'tina', 'java', 'delhi', 2100, 854-236);

 
delete from parents;
create table parents 
(stu_roll_no int primary key,
parent_name varchar(150) not null,
address varchar (50),
phone varchar(50),
occupation varchar(50),
occupationid int);
insert into parents
values (1, 'keshav', 'chennai', '451-250', 'manager', 1);
insert into parents
values (2, 'rajkumar', 'mumbai', '521-745', 'doctor', 2);
insert into parents
values (3, 'tapas', 'delhi', '354-745', 'manager', 1);
insert into parents
values (4, 'julia', 'chennai', '475-856', 'doctor', 2);
insert into parents
values (5, 'pinki', 'kolkata', '447-965', 'service', 3);
insert into parents
values (6, 'ram', 'noida', '247-965', 'service', 3);

 

create table tution_fee 
(stu_roll_no int primary key,
tution_fee float not null);
insert into tution_fee 
values (1, 45800);
insert into tution_fee 
values (2, 55800);
insert into tution_fee 
values (3, 49800);
insert into tution_fee 
values (4, 51800);

 

#Subqueries with DELETE statement
#remove rows from the table 'parents' with following conditions -
#1. 'stu_roll_no' should be any 'roll_no' from 'students' table which satisfies the condition bellow :
#2. 'adress' of 'students' table must be 'mumbai'
DELETE FROM parents
WHERE stu_roll_no=ANY(
SELECT roll_no FROM students
WHERE address='mumbai');
select * from parents;

 

#delete records using subqueries with alias
#remove rows from the table 'students' with following conditions -
#1. 't' and 's' are the aliases for the table 'tution_fee' and 'students'
#2. check the existence of the subquery is true or false. which satisfies the condition bellow :
#3. 'tution_fee' of 'tution_fee' table must be more than 50000,
#4. 'roll_no' of 'students' table and 'stu_roll_no' of 'tution_fee' table should not be same,

DELETE FROM students s
WHERE EXISTS(
SELECT stu_roll_no FROM  tution_fee t
WHERE t.tution_fee>50000
AND s.roll_no=t.stu_roll_no); #<> = not same
select * from students;

 

#delete records using subqueries with alias and IN
#remove rows from the table 'students' with following conditions -
#1. 'p' and 's' are the aliases for the table 'parents' and 'students'
#2. check the address chennai is in the result of the subquery which satisfies the condition bellow :
#3. 'address' of 'parents' table and 'address' of 'students' table should not be same,
DELETE FROM students s
WHERE 'chennai' IN(
SELECT p.stu_roll_no, p.address FROM parents p, students s
WHERE s.address=p.address);
select * from students;
select * from parents;
 
truncate table students;
truncate table parents; 

#delete records using subqueries with alias and MIN
/*remove rows from the table 'students' with following conditions -
1. 'parents' table used as alias 'p1' and alias 'p2',
2. 'roll_no' of 'students' should be within the 'stu_roll_no' in alias 'p1' which satisfies the condition bellow :
i) 'stu_roll_no' of alias 'p1' must be equal to the minimum 'occupationID' of alias 'p2' which satisfies the condition bellow :
a) 'address' of alias 'p1' and alias 'p2' must be equal,*/
DELETE FROM students
WHERE roll_no IN
(SELECT stu_roll_no FROM parents p1
WHERE stu_roll_no=(
SELECT MIN(occupationID) FROM parents p2
WHERE p1.address=p2.address));
select * from students;

 

#Inner Join : Returns records that have matching values in both tables
SELECT students.roll_no, students.student_Name, parents.parent_name #Two tables
FROM students
INNER JOIN parents ON students.roll_no=parents.stu_roll_no; #Equi Join

 

SELECT students.roll_no, students.student_Name, parents.parent_name
FROM parents
INNER JOIN students ON students.roll_no = parents.stu_roll_no;

 

SELECT students.roll_no, students.student_Name, parents.parent_name, tution_fee.tution_fee #Three tables
FROM ((students
INNER JOIN parents ON students.roll_no = parents.stu_roll_no)
INNER JOIN tution_fee ON students.roll_no = tution_fee.stu_roll_no);

 

#Left (Outer) Join: Returns all records from the left table (table1), and the matching records (if any) from the right table (table2)
SELECT students.roll_no, students.student_Name, parents.parent_name #Two tables
FROM students
LEFT JOIN parents ON students.roll_no=parents.stu_roll_no;

 

SELECT students.roll_no, students.student_Name, parents.parent_name, tution_fee.tution_fee #Three tables
FROM ((students
LEFT JOIN parents ON students.roll_no = parents.stu_roll_no)
LEFT JOIN tution_fee ON students.roll_no = tution_fee.stu_roll_no);

 

SELECT students.roll_no, students.student_Name, parents.parent_name #Two tables
FROM students
LEFT JOIN parents ON students.roll_no=parents.stu_roll_no
ORDER BY students.roll_no desc;

 

#Right (Outer) Join: Returns all records from the left table (table1), and the matching records (if any) from the right table (table2).
SELECT students.roll_no, students.student_Name, parents.parent_name #Two tables
FROM students
RIGHT JOIN parents ON students.roll_no=parents.stu_roll_no;

 

SELECT students.roll_no, students.student_Name, parents.parent_name, tution_fee.tution_fee #Three tables
FROM ((students
RIGHT JOIN parents ON students.roll_no = parents.stu_roll_no)
RIGHT JOIN tution_fee ON students.roll_no = tution_fee.stu_roll_no);

 

SELECT students.roll_no, students.student_Name, parents.parent_name #Two tables
FROM students
RIGHT JOIN parents ON students.roll_no=parents.stu_roll_no
ORDER BY students.roll_no desc;

 

#Cross (Outer) Join: Returns all records from both tables (table1 and table2).
SELECT students.roll_no, students.student_Name, parents.parent_name #Two tables
FROM students
CROSS JOIN parents
ORDER BY students.roll_no;

 

SELECT students.roll_no, students.student_Name, parents.parent_name #Two tables
FROM students
CROSS JOIN parents
WHERE students.roll_no=parents.stu_roll_no; #same as inner join

#ANY Syntax With SELECT
SELECT roll_no, student_name
FROM students
WHERE roll_no = ANY
  (SELECT stu_roll_no
  FROM parents
  WHERE occupation = 'doctor'); #this will return TRUE because the Occupation column has some values of 'Doctor'
  
#ALL Syntax With SELECT
SELECT roll_no, student_name
FROM students
WHERE roll_no = ALL
  (SELECT stu_roll_no
  FROM parents
  WHERE occupation = 'doctor'); #This will return FALSE because the occupation column has many different values (not only the value of 'Doctor')
  
  SELECT roll_no, student_name FROM students
WHERE address='chennai'
UNION
SELECT parent_name FROM parents
WHERE address='kolkata'
ORDER BY student_name;

SELECT roll_no, student_name FROM students
WHERE address='chennai'
UNION All
SELECT parent_name, stu_roll_no FROM parents
WHERE address='kolkata';

SELECT roll_no as num, student_name as name FROM students
WHERE address='chennai'
UNION
SELECT stu_roll_no, parent_name FROM parents
WHERE address='kolkata'
ORDER BY student_name;

SELECT roll_no as num, student_name as name FROM students
WHERE address='chennai'
UNION
SELECT stu_roll_no, parent_name FROM parents
WHERE address='kolkata'
ORDER BY name;

select * from students;
select * from parents;

#INTERSECT
SELECT DISTINCT roll_no FROM students          #MySQL does not provide support for the INTERSECT operator
INNER JOIN parents USING (stu_roll_no); 

SELECT DISTINCT address FROM students  
INNER JOIN parents USING (address); 


SELECT DISTINCT roll_no FROM students  
WHERE roll_no IN (SELECT stu_roll_no FROM parents);

SELECT contacts.contact_id, contacts.last_name, contacts.first_name
FROM contacts
WHERE contacts.contact_id < 100
AND EXISTS (SELECT *
            FROM customers
            WHERE customers.last_name <> 'Johnson'
            AND customers.customer_id = contacts.contact_id
            AND customers.last_name = contacts.last_name
            AND customers.first_name = contacts.first_name);
            
use univdb;
select * from students;
select * from parents;
select * from students2;

/*correlated subquery and nested query 
cor - outer quey excecutes frst and for eveyr outer query, the inner query eill be executed
*/
/*the foll correlated subqueries retieve name, curse, fees amd rool mo from table students
and ('s' and 'p' are aliases of stu and parents) w folcondition
the roll_no of students tabel must be the same stu_roll_no of parents and address of 
parents table must be chennai */

select roll_no,s.student_name,s.course,s.fees
from students s  #to get multiple results we can use 'in' or 'between; instead of ''
where s.roll_no=(
select p.stu_roll_no
from parents p where p.address='chennai');  #gives error if more than one row is retuned since we're using '=' operarot
#so now change one data to be able to exceute this, chamge last one , oparents address

update parents set address='noida' where stu_roll_no=4;
#now execute and it will work

#using EXISTS wth a corrrlated subquery 
#display the ward roll_no, parent name, address of those parent swhose ward roll_no mathes w their occupation id
select stu_roll_no,parent_name,address
from parents p1
where exists 
(select occupationid
from parents p2
where p1.stu_roll_no = p2.occupationid);

/* using NOT EXISTS with a correlated subquery 
display the ward_roll no, parent name, addres of thnose parents whose ward roll_no matches occupatinid*/

select stu_roll_no,parent_name,address
from parents p1
where not exists 
(select occupationid
from parents p2
where p1.stu_roll_no = p2.occupationid);

#insert subquery 
#create table students 1
#to insert all records into 'students1' from 'students' table the folowing
insert into students1
select *from students;
select * from students1;
truncate table students1; #deleting contents

#inserting records using subqueries with where clause
#insert records intp'studetns1' from 'students' w consdition 
#address of studentrs table must be 'mumbai'
insert into students1
select * from students
where address='mumbai';
#truncate students1 again to show the next process

#insertinf records using subqueries with ANY operator
#insert records into st1 from stu w condito
# 1) roll_no of stud must be ant stu_roll_ no from parents table which satifies
# 2) address of parents table must be chennai 
insert into students1
select * from students
where roll_no = any(
select stu_roll_no from parents 
where address='chennai');

# we can use 'all' instead of 'any' for this 
#difference is 'all' will return only if all subqurey values are true 
#for 'any' if only one is true then also iuter query will get executed

#inserting records using suqqueries with any operator and group by
#create table tuition_fees

#insert data into stu1 from stu w conditions
#'roll_no' of students table must be any 'atu_roll_no' from ' aorents' which satisty
#stu_roll of parents must be stu_roll from tuition_fee
#same address of aparents table must be stu_roll from tuition fee table 
#same 'address' of parents table should come in a group
#'tuition_fee of tuition_fee must be more than 50000

insert into students1
select * from students
where roll_no=any(
select stu_roll_no from parents 
where stu_rol_no=any(
select stu_roll_no from tuition_fee
where tuitio_fee>50000)
group by address);

#result will be inserted the tuples related to roll2 and roll 4
#update studente table w
# 1)mdifiesd value of fees is fees +1000
# 2) number 3 is >= number of name from parents table with
# 3) stu_roll_no of parents tablel and roll_no of students tale should  match
update students
set fees=fees+1000
where 3>=(
select count(parent_name) from parents
where parents.stu_roll_no=students.roll_no);
select * from students;

#update using subqueries usin in and min()
# update tuition fees w
# 1) modiy value for tuition_fee is tuition fee-500
# 2)stu_roll_no not within selected stu_roll no of parents tabke name w alias p 
# 3) address of parents table names as alias p is the minimum address of  student
# 4)phone of alias a and b must be same 

update tuition_fee
set tuition_fee=tuition_fee-500
where stu_roll_no not in(
select stu_roll_no from parents p 
where address=(
select min(address) from students s
where p.phone=s.phone));
select * from tuition_fee;

---------------------------------------------------------------------------------        
            
use univdb;
create table student
(sid varchar(10),
name varchar(20)
);
create table marks
(sid varchar(10),
total int(3)
);

insert into student values('V001','Abe');
insert into student values('V002','Abhay');
insert into student values('V003','Acelin');
insert into student values('V004','Adelphos');
insert into marks values('V001',95);
insert into marks values('V002',80);
insert into marks values('V003',74);
insert into marks values('V004',81);

select * from student;
select * from marks;

select s.name from student s, marks m 
where s.sid=m.sid and 
m.total>(select total from marks where sid='V002');

ALTER TABLE student
RENAME TO stud;    

ALTER TABLE students
RENAME TO studs; 

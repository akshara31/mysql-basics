create database univdb;
use univdb;
create table students
(roll_no int primary key,
student_name varchar(150), 
course  varchar(150));
#INSERT
insert into students
values(1,'ash','java');
select * from students; 
insert into students
values(2,'rahul','c++');
insert into students
(roll_no, student_name,course)
values(3,'damn','c');
insert into students
(roll_no, course)
values(4,'ai');
insert into students
(roll_no,student_name)
values(4,'rastogi');
insert into students
(roll_no,student_name,course)
values(5,'rastogi','c++');
create table students2
(roll_no int primary key,
student_name varchar(150) not null, 
course  varchar(150));

insert into students2
select roll_no,student_name, course
from students where roll_no = 2;    /*to copy data from one table into another */
select * from students2;

insert into students2
(roll_no,student_name)
select roll_no,student_name
from students where roll_no = 3;    /*to copy portion of data from one table into another */
select * from students2;

insert into students2
(roll_no,student_name)
select roll_no,student_name
from students;   /*to copy portion of data from one table into another */
select * from students2;

/*to add new column to student 2*/
alter table students2
add address varchar(50);

insert into students2   /*if we want to copy row wise no of attributes mnmust be same for both the tables */
select *
from students where roll_no = 1;  

insert into students2   
select roll_no,student_name, course
from students where roll_no = 1;  

#select 
select * from students;
select roll_no, course from students; #to just see specific data 
select * from students where course is null;
select * from students where course is not null;
select * from students where course='c';
select roll_no,student_name from students where roll_no >3; #>=3
select roll_no,student_name from students where roll_no <3; #<=
select roll_no,student_name from students where roll_no <>3; #<> is not equal
select roll_no,student_name from students where roll_no between 2 and 4; # 2, 3, 4 will be seen i didnt enter 4 here so shut up
select * from students where student_name in ('rastogi','damn'); #multiple possible values for a column if 5 was rastogi again woud display again
select * from students where student_name like 'r%'; #names starting with r
select * from univdb.students; #database name. table name

select distinct student_name from students; #removes duplicates, if a name has two roll no it wil be ignored
select distinct roll_no,student_name from students; #if there are duplicsaes won't work
select distinct student_name,course from students;
select count(distinct student_name) from students; #counts distinct names 

select * from students where student_name ='rastogi' and course='c';#if no match just null is shown
select * from students where student_name ='rastogi' or course='c++';
select * from students where student_name like 'r%' or course='c'; #can use and also
select * from students where not student_name='rahul';
select * from students where student_name like 'r%' and (course='c' or roll_no between 2 and 4);
select * from students where student_name like 'r%' and not course='c';

select * from students order by student_name;
select * from students order by student_name desc; #descending order
select * from students order by student_name, course; # this means that it orders by student_name, but if some rows have same name it orders by course 
select * from students order by student_name desc, course desc; #if name is same the course is used and ordered by asc

#aggregate functions
select min(roll_no) as firstrollno from students; #assigning a nmae for minimum of roll no
#if we don't put a name then it just shows as min(roll_no)
select min(roll_no) from students;
select max(roll_no) as lastrollno from students;
select min(course) as firstcourse, max(course) as lastcourse from students;
select count(roll_no) from students;
select avg(roll_no) from students; #null values are ignored
select sum(roll_no) from students; #null ignored

#group by
select count(roll_no),course
from students
group by course; #lists the number of students in each course 

select count(roll_no),course
from students
group by course
order by count(roll_no) desc; #no of strudents in each curse d=sorted high to low

#having
select count(roll_no),course
from students
group by course
having count(roll_no) > 1; #lists no of students in each cpurse w more htan roll 1
#we can use aggreagate(count) w having function

#update
update students
set student_name='alfred', course='ml'  #we chamged the name and course
where roll_no=2;
select * from students;

update students
set student_name='puhio' 
where course='c++';
#if you omit where clause, ALL RECORDS WILL BE UPDATED

#delete 
delete from students where student_name='alfred';
delete from student2; #delete all record
select * from student2;

#truncate  data definiton comment (DDL)
truncate table students; #student records will be deleted 
#differences b/w truncate and delete
#we are not deleting table but deleting data (table records)
#we can use condiition in delete like 'where' cnan delete













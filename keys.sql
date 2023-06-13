create database univer;
use univer;
#NOT NULL Constraint: Ensures that a column cannot have a NULL value
CREATE TABLE Employee (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255) NOT NULL,
    Age int
);

insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
(id, firstname, age)  #there no last name but won't aacept as no default given
values (2, 'Roy', 25);   #we can ignore age but ithers given not null so no


ALTER TABLE employee
MODIFY Age int NOT NULL;   # to make age not null
desc employee;


drop table employee;
show tables;


#UNIQUE Constraint: Ensures that all values in a column are different
#create
CREATE TABLE employee (                
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    UNIQUE (ID)   #single attribute
);
desc employee;     #automatically unique and not null mentioned attribute will become primary key without metnioning also
insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
values (1, 'Roy', 'Puja', 28);  #error, as id should be uinque 
drop table employee;


CREATE TABLE employee (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    UNIQUE (ID,LastName)            #multiple attribute: ckecking for the combined uniqueness
);                        
desc employee;    #since two attributes unique and not null, two primary key
drop table employee;


CREATE TABLE employee (
    ID int,
    LastName varchar(255),
    FirstName varchar(255),
    Age int,
    UNIQUE (ID,LastName)            #multiple attribute: ckecking for the combined uniqueness
);
desc employee;    #we get MUL in ID 


insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
values (1, 'Sharma', 'Puja', 28);  #error, duplicate entry 1 sharma, it takes combination 
truncate table employee;


insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
values (2, 'Sharma', 'Puja', 28);  #here accpeted, only idi schanged and name is same 
select * from employee;   
truncate table employee;


insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
(Lastname, id, firstname, age)
values ('Roy', 1, 'Puja', 28);
drop table employee;


#alter
CREATE TABLE employee (
    ID int,
    LastName varchar(255),
    FirstName varchar(255),
    Age int
);
desc employee;  #no constraint, can be null
ALTER TABLE employee
ADD UNIQUE (ID);                #single
desc employee;
drop table employee;


CREATE TABLE employee (
    ID int,
    LastName varchar(255),
    FirstName varchar(255),
    Age int
);
desc employee;
ALTER TABLE employee
ADD UNIQUE (ID,LastName);            #multiple as unique field (key)
desc employee;


insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
values (1, 'Sharma', 'Puja', 28);  #duplicate id
truncate table employee;


insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
values (2, 'Sharma', 'Puja', 28);  #accepted 
select * from employee;
truncate table employee;


insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
(firstname, age)
values ('Raju', 25);
select * from employee;  #accepts as no null constraints
truncate table employee;


insert into employee
values (1, 'Sharma', 'Raju', 25);
insert into employee
(lastname, firstname, age)
values ('Sharma', 'Raju', 25);
select * from employee;       #here we have id and last name as primary key but still accepted as the combination of both is different 
drop table employee;


#drop
CREATE TABLE employee (
    ID int,
    LastName varchar(255),
    FirstName varchar(255),
    Age int,
    CONSTRAINT UC_employee UNIQUE (ID,LastName)            #multiple attribute: ckecking for the combined uniqueness
);
desc employee;
ALTER TABLE employee
DROP INDEX UC_employee;   #dropping the constraint makes it not MUL anymore 
desc employee;
drop table employee;


CREATE TABLE employee (
    ID int not null,
    LastName varchar(255) not null,
    FirstName varchar(255),
    Age int,
    CONSTRAINT UC_employee UNIQUE (ID,LastName)            #multiple attribute: ckecking for the combined uniqueness
);                                
desc employee;
ALTER TABLE employee
DROP INDEX UC_employee;    #dropping the constraint makes it not primary anymore 
desc employee;
drop table employee;


CREATE TABLE employee (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);
desc employee;
ALTER TABLE employee
ADD CONSTRAINT UC_employee UNIQUE (ID,LastName);
desc employee;
ALTER TABLE employee
DROP INDEX UC_employee;
desc employee;
drop table employee;

#PRIMARY KEY Constraint
#create
CREATE TABLE employee (
    ID int,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (ID)                #single, primary implies it is not null
);
desc employee;
drop table employee;

 

CREATE TABLE employee (
    ID int,
    LastName varchar(255),
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (ID,LastName)            #multiple primary keys
);
desc employee;
drop table employee;

CREATE TABLE employee (
    ID int primary key,
    LastName varchar(255),
    FirstName varchar(255),
    Age int	
);
desc employee;
drop table employee;
 

CREATE TABLE employee (
    ID int primary key,
    LastName varchar(255) primary key,
    FirstName varchar(255),
    Age int	
);
desc employee;    #can't do as multiple primary key cannot be assigned 

#alter and drop
CREATE TABLE employee (
    ID int,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);
desc employee;
ALTER TABLE employee
ADD PRIMARY KEY (ID);    #makes id NOT NULL
desc employee;
ALTER TABLE employee
DROP PRIMARY KEY;       #now id is not primary but still NO NULL values
desc employee;
drop table employee;



CREATE TABLE employee (
    ID int,
    LastName varchar(255),
    FirstName varchar(255),
    Age int
);
desc employee;
ALTER TABLE employee
ADD PRIMARY KEY (ID,LastName);   #adds primary, makes NO NULL
desc employee;
ALTER TABLE employee
DROP PRIMARY KEY;   #removes primary and retains NO NULL property
desc employee;
drop table employee;


#FOREIGN KEY constraint
#create
CREATE TABLE employee (
    employeeID int,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (employeeID)                #referenced table
);
desc employee;
CREATE TABLE core_group (
    cgID int NOT NULL,
    salary int NOT NULL,
    employeeID int NOT NULL,       #this structure shoukd be same as ref table to be a koreign key
    PRIMARY KEY (cgID),
    FOREIGN KEY (employeeID) REFERENCES employee(employeeID)        #referencing table
);
desc core_group;     #foreign key (eployeeid) in core_group can be NULL, unless mentioned like here but in employee it is primary key so no


insert into employee
values (1, 'Sharma', 'Puja', 28), (2, 'roy', 'rohit', 25);
insert into core_group
values (101, 50000, 1), (102, 60000, 2);
select * from employee;
select * from core_group;


truncate table core_group;
insert into core_group
values (101, 50000, 1), (102, 60000, 3);  #error, as 3 is nnot available in reference table and it's foreign key
select * from core_group;
drop table core_group;
drop table employee;


CREATE TABLE employee (
    employeeID int,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (employeeID, lastname)                #multiple primary key
);
CREATE TABLE core_group (
    cgID int NOT NULL,
    salary int NOT NULL,
    employeeID int NOT NULL,
    lastname varchar(255),
    PRIMARY KEY (cgID),
    CONSTRAINT FK_emp_cg FOREIGN KEY (employeeID, lastname)   #multiple foreign key
    REFERENCES employee(employeeID, lastname)
);
desc employee;
desc core_group;    #key for id will be given as MUL, since last name not explicitly given not null it can be null and foreign key unlike employeeid
drop table core_group;


#alter and drop
CREATE TABLE core_group (
    cgID int NOT NULL,
    salary int NOT NULL,
    employeeID int
);
desc core_group;
ALTER TABLE core_group
ADD CONSTRAINT FK_emp_cg
FOREIGN KEY (employeeID) REFERENCES employee(employeeID);   #single
desc core_group;
insert into core_group
values (101, 50000, 1), (102, 60000, 3);  #no 3 in main table so error, can't refernce 3
ALTER TABLE core_group
DROP FOREIGN KEY FK_emp_cg; #If Key is MUL , the column is the first column of a nonunique index in which multiple occurrences of a given value are permitted within the column.
desc core_group;

insert into core_group
values (101, 50000, 1), (102, 60000, 3);  #here since we dropped foreign key, we can now put 3 and it is allowed 
select * from core_group;
desc core_group;

#CHECK Constraint: used to limit the value range that can be placed in a column.
#create
CREATE TABLE employee (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    CHECK (Age>=18)
);
desc employee;
insert into employee
values (1, 'Sharma', 'Puja', 15);
drop table employee;


CREATE TABLE employee (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    City varchar(255),
    CONSTRAINT CHK_Person CHECK (Age>=18 AND City='Vellore')
);
insert into employee
values (1, 'Sharma', 'Puja', 15, 'vellore');
drop table employee;

 

CREATE TABLE employee (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    City varchar(255),
    CONSTRAINT CHK_employee CHECK (Age between 18 and 26 AND City='Vellore')
);
insert into employee
values (1, 'Sharma', 'Puja', 29, 'vellore');


#alter
ALTER TABLE employee
ADD CHECK (Age>=18);


ALTER TABLE employee
ADD CONSTRAINT CHK_employee CHECK (Age>=18 AND City='vellore');

 

#drop
ALTER TABLE employee
DROP CHECK CHK_employee;
insert into employee
values (1, 'Sharma', 'Puja', 29, 'vellore');

 
drop table employee;
#DEFAULT Constraint: used to set a default value for a column.
#create
CREATE TABLE employee (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    City varchar(255) DEFAULT 'vellore'
);

desc employee;
select * from employee;
insert into employee
values (1, 'Sharma', 'Puja', 29, 'chennai');
select * from employee;


#alter
ALTER TABLE employee
ALTER City SET DEFAULT 'vellore',
ALTER age SET DEFAULT 18;
desc employee;

#drop
ALTER TABLE employee
ALTER City DROP DEFAULT;
desc employee;


insert into employee
values (1, 'Sharma', 'Puja', 28, 'chennai'), (2, 'roy', 'rohit', 25, 'vellore');


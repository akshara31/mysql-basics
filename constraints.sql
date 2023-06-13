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
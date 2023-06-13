use univdb;
###################################################Experiment###################################
drop table if exists c1;
drop table if exists c2;
drop table if exists c3;
CREATE TABLE c1(i INT);
CREATE TABLE c2(i INT);
CREATE TABLE c3(i INT);
INSERT INTO c1 VALUES(5),(50),(500);
INSERT INTO c2 VALUES(10),(20),(30);

DELIMITER //
drop procedure if exists p1//
CREATE PROCEDURE p1()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE x, y INT;
  DECLARE cur1 CURSOR FOR SELECT i FROM c1;
  DECLARE cur2 CURSOR FOR SELECT i FROM c2;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; #stopping criteria
  #SIMPLEST STOPPING CRITERIA

  OPEN cur1;
  OPEN cur2;

  read_loop: LOOP
    FETCH NEXT FROM cur1 INTO x;
    FETCH NEXT FROM cur2 INTO y;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF x < y THEN
      INSERT INTO c3 VALUES (x);
    ELSE
      INSERT INTO c3 VALUES (y);
    END IF;
  END LOOP;

  CLOSE cur1;
  CLOSE cur2;
END //


CALL p1;
SELECT * FROM c3;
#truncate c3;

##########################Experiment##################################
DROP PROCEDURE IF EXISTS p1;
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE TABLE t1 (a INT, b VARCHAR(10));
INSERT INTO t1 VALUES (1,'old'),(2,'old'),(3,'old'),(4,'old'),(5,'old');
CREATE TABLE t2 (a INT, b VARCHAR(10));

DELIMITER //
CREATE PROCEDURE p1(pmin INT,pmax INT)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE va INT;
  DECLARE cur CURSOR FOR SELECT a FROM t1 WHERE a BETWEEN pmin AND pmax;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;# or done=1(T)/0(F)
  OPEN cur;
  read_loop: LOOP
    FETCH cur INTO va;
    IF done THEN
      LEAVE read_loop;
    END IF;
    INSERT INTO t2 VALUES (va,'new');
  END LOOP;
  CLOSE cur; 
END//

CALL p1(1,3);
SELECT * FROM t2;

########################Experiment###################################
select * from students;
DROP PROCEDURE IF EXISTS `multipleCursorsAtOne`;
DELIMITER $$
CREATE PROCEDURE `multipleCursorsAtOne`()
BEGIN
    DROP TABLE IF EXISTS userNames;
    CREATE TEMPORARY TABLE userNames
    (userName varchar(20) NOT NULL);

    BEGIN
        DECLARE done BOOLEAN DEFAULT false;
        DECLARE p_first_name VARCHAR(20);
        DECLARE cursor_a CURSOR FOR SELECT student_name FROM students LIMIT 1,3; #offset 1, count 3
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
         
        OPEN cursor_a;
            cursor_a_loop: LOOP
                 FETCH cursor_a INTO p_first_name;
                 IF done THEN
                        LEAVE cursor_a_loop;
                 END IF;    
                 -- cursor loop statements
                    
                 IF p_first_name IS NOT NULL AND p_first_name <> "" THEN
                    INSERT INTO userNames(userName) VALUES(p_first_name);
                 END IF;
            END LOOP;
        CLOSE cursor_a;
    END;
   
    BEGIN
        DECLARE done BOOLEAN DEFAULT false;
        DECLARE p_first_name VARCHAR(20);
        DECLARE cursor_a CURSOR FOR SELECT student_name FROM students LIMIT 4,1; #offset 4, count 3
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
         
        OPEN cursor_a;
            cursor_a_loop: LOOP
                 FETCH cursor_a INTO p_first_name;
                 IF done THEN
                        LEAVE cursor_a_loop;
                 END IF;    
                 -- cursor loop statements --
                 IF p_first_name IS NOT NULL AND p_first_name <> "" THEN
                    INSERT INTO userNames(userName) VALUES(p_first_name);
                 END IF;
            END LOOP;
        CLOSE cursor_a;
    END;
    SELECT * FROM userNames;
END$$
call `multipleCursorsAtOne`();

#########################Experiment#############################
drop table if exists employee;
CREATE TABLE Employee(
    id            int,
        first_name    VARCHAR(15),
        last_name     VARCHAR(15),
        salary        FLOAT(8,2),
		city          VARCHAR(10),
        descrip   VARCHAR(15)
    );
insert into Employee(id,first_name, last_name,   salary,  City, Descrip)
    values (1,'Jason',    'Martin',  1234.56, 'Toronto',  'Programmer'),
    (2,'Alison',   'Mathews',  6661.78, 'Vancouver','Tester'),
    (3,'James',    'Smith',    6544.78, 'Vancouver','Tester'),
    (4,'Celia',    'Rice',   2344.78, 'Vancouver','Manager'),
    (5,'Robert',   'Black',  2334.78, 'Vancouver','Tester'),
    (6,'Linda',    'Green',  4322.78,'New York',  'Tester'),
    (7,'David',    'Larry',  7897.78,'New York',  'Manager'),
    (8,'James',    'Cat',   1232.78,'Vancouver', 'Tester');
select * from Employee;

delimiter $$
drop procedure if exists myproc$$
CREATE PROCEDURE myProc()
BEGIN
DECLARE l_department_id INT;
DECLARE l_employee_id   INT;
DECLARE l_emp_count     INT DEFAULT 0 ;
DECLARE l_done          INT DEFAULT  0;

DECLARE dept_csr cursor FOR SELECT id FROM employee;

DECLARE emp_csr cursor FOR SELECT id+1 FROM employee;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
OPEN dept_csr;
dept_loop: LOOP   -- Loop through departments
FETCH dept_csr into l_department_id;
  
  IF l_done=1 THEN
        LEAVE dept_loop;
  END IF;

OPEN emp_csr;

SET l_emp_count=0;
emp_loop: LOOP      -- Loop through employee in dept.
    FETCH emp_csr INTO l_employee_id;

	IF l_done=1 THEN
         LEAVE emp_loop;
    END IF;
SET l_emp_count=l_emp_count+1;
END LOOP;
CLOSE emp_csr;
SET l_done=0;
SELECT CONCAT('Department ',l_department_id,' has ', l_emp_count,' employees') as output;
END LOOP dept_loop;
CLOSE dept_csr;
END$$

call myProc();

###########################Experiment###########################
#cross join
drop table if exists stu_par;
create table stu_par (stu_roll int, stu_name varchar (50), par_stu_roll int, par_name varchar (50));
delimiter $$
drop procedure if exists myproc$$
CREATE PROCEDURE myProc()
BEGIN
DECLARE c_rno,c_inner_id, done, inner_done INT;
DECLARE c_name, c_inner_name VARCHAR(100);

DECLARE cursor_var CURSOR FOR SELECT roll_no, student_name FROM students;
DECLARE inner_cursor_var CURSOR FOR SELECT stu_roll_no, parent_name FROM parents;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 
OPEN cursor_var;
cursor_var_loop: LOOP
     FETCH cursor_var INTO c_rno,c_name;
IF done THEN
            LEAVE cursor_var_loop;
     END IF;
#select concat (c_rno,c_name);
OPEN inner_cursor_var;
inner_cursor_var_loop: LOOP
            FETCH inner_cursor_var INTO c_inner_id,c_inner_name;  -- inner cursor statements
            IF done THEN
                LEAVE inner_cursor_var_loop;
            END IF;
insert into stu_par values(c_rno,c_name,c_inner_id,c_inner_name);
#select concat (c_inner_id,c_inner_name);
END LOOP inner_cursor_var_loop;             
CLOSE inner_cursor_var;
set done = 0;
#insert into stu_par values(c_rno,c_name,c_inner_id,c_inner_name);
END LOOP cursor_var_loop;
CLOSE cursor_var;
end$$ 

call myProc();
select * from stu_par;
truncate stu_par;

###################Experiment############################
CREATE TABLE `parent` 
(`a` int(11) DEFAULT NULL);
CREATE TABLE `child` 
(`a` int(11) DEFAULT NULL,
`b` varchar(20) DEFAULT NULL);

insert into parent values (1),(2),(3);
insert into child values (1,'a'),(1,'b'),(2,'a'),(2,'b'),(3,'a'),(3,'b');

delimiter $$
drop procedure if exists nestedCursor$$
create procedure nestedCursor()
BEGIN   
    DECLARE done1, done2 BOOLEAN DEFAULT FALSE;  
    DECLARE parentId,childId int;
    DECLARE childValue varchar(30);

    DECLARE cur1 CURSOR FOR SELECT a FROM parent;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = TRUE;

    open cur1;
    loop1: LOOP
    FETCH FROM cur1 INTO parentId;
    IF done1 THEN
        CLOSE cur1;
        LEAVE loop1;
    END IF;

    BLOCK1 : BEGIN
    DECLARE cur2 CURSOR FOR SELECT a,b FROM child where a = parentId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = TRUE;

    open cur2;
    loop2 : LOOP
    FETCH FROM cur2 INTO childId,childValue;  
        if done2 THEN
        CLOSE cur2;
        SET done2 = FALSE;
        LEAVE loop2;
        end if;
        select parentId,childId,childValue;

    END LOOP loop2;
    END BLOCK1;
    END loop loop1;
END$$

call nestedCursor();

###################Experiment#############################
drop table if exists stu_par;
create table stu_par (par_stu_roll int, stu_roll int, stu_name varchar (50));
delimiter $$
drop procedure if exists nestedCursor$$
create procedure nestedCursor()
BEGIN   
    DECLARE done1, done2 BOOLEAN DEFAULT FALSE;  
    DECLARE parentId,stuId int;
    DECLARE stu_name varchar(30);
    DECLARE cur1 CURSOR FOR SELECT stu_roll_no FROM parents;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = TRUE;

    open cur1;
    loop1: LOOP
    FETCH FROM cur1 INTO parentId;
    IF done1 THEN
        CLOSE cur1;
        LEAVE loop1;
    END IF;
    
    BLOCK1 : BEGIN
    DECLARE cur2 CURSOR FOR SELECT roll_no,student_name FROM students where roll_no = parentId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = TRUE;

    open cur2;
    loop2 : LOOP
    FETCH FROM cur2 INTO stuId,stu_name;  
        if done2 THEN
        CLOSE cur2;
        SET done2 = FALSE;
        LEAVE loop2;
        end if;
        insert into stu_par values(parentId,stuId,stu_name);
        #select parentId,stuId,stu_name;

    END LOOP loop2;
    END BLOCK1;
    END loop loop1;
END$$

call nestedCursor();
select * from stu_par;

##################################Experiment##############################
drop table if exists c;
CREATE TABLE c(c1 INT, c2 int);
delimiter $$
drop procedure if exists nestedCursor$$
create procedure nestedCursor()
BEGIN   
    DECLARE done1, done2 BOOLEAN DEFAULT FALSE;  
    DECLARE c1_val,c2_val int;
    
    DECLARE cur1 CURSOR FOR SELECT i FROM c1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = TRUE;
    
    open cur1;
    loop1: LOOP
    FETCH FROM cur1 INTO c1_val;
    IF done1 THEN
        CLOSE cur1;
        LEAVE loop1;
    END IF;
    
    BLOCK1 : BEGIN
    DECLARE cur2 CURSOR FOR SELECT i FROM c2;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = TRUE;

    open cur2;
    loop2 : LOOP
    FETCH FROM cur2 INTO c2_val;  
        if done2 THEN
        CLOSE cur2;
        SET done2 = FALSE;
        LEAVE loop2;
        end if;
        insert into c values(c1_val,c2_val);
        #select parentId,stuId,stu_name;

    END LOOP loop2;
    END BLOCK1;
    END loop loop1;
END$$

call nestedCursor();
select * from c;
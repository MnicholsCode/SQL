show databases; # This statement shows the list of databases
drop database if exists DBEx2x; # This statement drops/deletes the database named DBEx2
create database DBEx2x; # Create the database named DBEx2
show databases;
use DBEx2x; -- Use the database DBEx2 we just created
show tables; # This statement shows the list of tables in the database DBEx2

show procedure status; # Shows the list of procedures
show function status; # Shows the list of functions
show triggers; # Shows the list of triggers
SHOW PROCEDURE STATUS WHERE db = 'dbex2x'; /* Shows the list of procedures in the
database DBEx2 */
SHOW function STATUS WHERE db = 'dbex2x'; /* Shows the list of functions in the database
DBEx2 */
SHOW triggers in dbex2x; # Shows the list of triggers in the database DBEx2

drop table if exists Employees;
create table Employees(
LName varchar(12) NOT NULL,
BirthDay date NOT NULL,
IDN int NOT NULL PRIMARY KEY,
Salary Decimal(20,2) NULL DEFAULT 0 ,
Deduction decimal(20, 2) NULL DEFAULT 0 );
/* IDN is primary key, the display order may be default to increasing IDN order */
describe Employees;
insert into Employees values ('Peter', '1986-9-6', 1, 1000, 10), ('Mary', '1996-9-6', 12, 2000,
0), ('Tony', '1989-7-9', 22, 4000, 32),
('Mike', '1999-11-12', 17, 4000, 10), ('John', '1980-3-2', 93, null, null);
select * from Employees;

drop table if exists IRAs;
create table IRAs(
FK_IDN int NOT NULL, /* FK_IDN is the foreign key */
IRA_acct varchar(12),
Balance decimal(20, 2),
FOREIGN KEY (FK_IDN) REFERENCES Employees(IDN));
describe iras;
select * from iras;
insert into IRAs values(1, 'A1', 100), (22, 'A2', 200), (22, 'A3', 400), (93, 'A4', 500);
select * from iras;

drop table if exists AddressCity;
create table AddressCity(
FK_IDN int NOT NULL, /* FK_IDN is the foreign key */
CompanyCity varchar(22),
HomeCity varchar(22),
FOREIGN KEY (FK_IDN) REFERENCES Employees(IDN));
describe addresscity;
select * from addresscity;
insert into addresscity values (1, 'Saint Louis', 'Saint Louis'), (12, 'Saint Louis',
'Chesterfield'),
(22, 'Chesterfield', 'Saint Louis'), (93, 'Chesterfield', 'Chesterfield'), (17, 'Fenton',
'Fenton');
select * from addresscity;

-- The following command enables and starts the event scheduler thread: 
SET GLOBAL event_scheduler = ON;
SET GLOBAL event_scheduler = OFF;

drop trigger if exists UpcaseLName;
delimiter //
create trigger UpcaseLName
before
update on Employees
for each row
Begin
	Set new.LName = Upper(old.LName);
end//
delimiter ;

SHOW triggers in dbex2x; 
update Employees set salary = salary + 100 where salary < 2000; # Update one row
select * from employees;

create table EmployeesUpdateRecords(
LName varchar(12), BirthDay date,
IDN int, Salary Decimal(20,2), Deduction decimal(20, 2),
UpdateTime datetime );
select * from EmployeesUpdateRecords;

drop trigger if exists ReSetDeductionOnNewSalary;
delimiter //
create trigger ReSetDeductionOnNewSalary 
before 
update 
on Employees 
for each row
Begin
	set new.deduction = new.salary * (0.01);
	insert into EmployeesUpdateRecords
	values (old.LName, old.BirthDay, old.IDN, old.Salary, old.Deduction, now() );   -- now() time function
end//
delimiter ;
SHOW triggers in dbex2x; 
update Employees set salary = salary + 100 where salary < 1500; # Update one row

select * from EmployeesUpdateRecords;
update Employees set salary = salary + 100 where salary < 3000; /* Update more than one row */
select * from employees;
select * from EmployeesUpdateRecords;

create table EmployeesUpdateRecordsT(UserID varchar(80),
LName varchar(12), BirthDay date,
IDN int, Salary Decimal(20,2), Deduction decimal(20, 2),
UpdateTime datetime );

drop trigger if exists ReSetDeductionOnNewSalaryT;
delimiter //
create trigger ReSetDeductionOnNewSalaryT 
before 
update 
on Employees 
for each row
Begin
	set new.deduction = new.salary * (0.01);
	insert into EmployeesUpdateRecordsT
	values (User(), old.LName, old.BirthDay, old.IDN, old.Salary, old.Deduction, now() ); -- user() gives current user making the update 
end//
delimiter ;
UPDATE employees set salary = salary + 50 WHERE salary < 1500;
SELECT * FROM employeesupdaterecordst;

drop trigger if exists CheckSalaryOnEmployees;
delimiter //
create trigger CheckSalaryOnEmployees 
before 
update 
on Employees 
for each row
Begin
	If (new.Salary>10000)
		then SIGNAL SQLSTATE 'HY000'
		set MESSAGE_TEXT = 'Salary too high beyond consideration! ';
	end if;
end//
delimiter ;
SHOW triggers in dbex2x; 
update Employees set Salary = Salary + 9000 where Salary > 2000;
select * from employees; # No update, table unchanged.
select * from EmployeesUpdateRecords; # No update, table unchanged.

create table EmployeesAudit(
LName varchar(12), BirthDay date,
IDN int, Salary Decimal(20,2), Deduction decimal(20, 2),
InsertTime datetime );
select * from EmployeesAudit;

-- This trigger purpose is to give the time in which an insert happened in the employees table
DROP TRIGGER IF EXISTS EmployeesAfterInsert;
delimiter //
create trigger EmployeesAfterInsert 
after 
insert 
on Employees 
for each row
Begin
	insert into EmployeesAudit
	values (new.LName, new.BirthDay, new.IDN, new.Salary, new.Deduction, now());
end//
delimiter ;

insert into Employees values ('Peter1', '1986-9-6', 101, 1000, 10);

select * from employees;
select * from EmployeesAudit;
insert into Employees values ('Peter2', '1986-9-6', 102, 1000, 10), ('Mary1', '1996-9-6', 112,
2000, 0), ('Tony1', '1989-7-9', 122, 6000, 32);

create table EmployeesDeleteRecords(
LName varchar(12), BirthDay date,
IDN int, Salary Decimal(20,2), Deduction decimal(20, 2),
DeleteTime datetime );

DROP TRIGGER IF EXISTS EmployeesAfterDelete;
delimiter //
create trigger EmployeesAfterDelete 
after 
delete 
on Employees 
for each row
Begin
	insert into EmployeesDeleteRecords
	values (old.LName, old.BirthDay, old.IDN, old.Salary, old.Deduction, now());
end//
delimiter ;

insert into employees values('Jack','1999-10-05', 222, 2000.10, 2);
select * from Employees;
select * from EmployeesDeleteRecords;
delete from Employees where IDN = 222;
SHOW triggers in dbex2x; 

SET GLOBAL event_scheduler = ON;
SHOW VARIABLES LIKE 'event_scheduler';

DROP EVENT IF EXISTS UpdateIRAsNow;
DELIMITER //
CREATE EVENT UpdateIRAsNow
	ON SCHEDULE
		AT CURRENT_TIMESTAMP
DO
Begin
	Update IRAs set Balance = Balance * (1.1);
End//
DELIMITER ;
select * from iras;

drop table if exists MessageEvents;
CREATE TABLE MessageEvents (
 IDN INT PRIMARY KEY AUTO_INCREMENT,
 Message VARCHAR(50), InsertedAt DATETIME);
 
DROP EVENT IF EXISTS MessageEvent1;
DELIMITER //
CREATE EVENT MessageEvent1
	ON SCHEDULE
		AT CURRENT_TIMESTAMP
DO
Begin
	INSERT INTO MessageEvents(Message, InsertedAt)
	VALUES('Just a message inserted by MessageEvent1', NOW());
End//
DELIMITER ; 

SELECT * FROM MessageEvents;
SHOW EVENTS FROM classicmodels;
SHOW EVENTS;

DROP EVENT IF EXISTS MessageEvent2;
DELIMITER //
CREATE EVENT MessageEvent2
	ON SCHEDULE
		AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
	ON COMPLETION PRESERVE
DO
Begin
	INSERT INTO MessageEvents(Message, InsertedAt)
	VALUES('Just a message inserted by MessageEvent2', NOW());
End//
DELIMITER ; 
SELECT * FROM MessageEvents;
SET GLOBAL event_scheduler = OFF;


DELIMITER //
CREATE TRIGGER LocaseLName
	BEFORE
    UPDATE
    ON employees
    FOR EACH ROW
BEGIN
	SET new.LName = LOWER(old.LName);
END//
DELIMITER ;
select * from employees;
update employees set deduction = deduction + .10 where salary < 1500;

CREATE TABLE EmployeesUpdateRecords1(
	LName VARCHAR(12), BirthDay DATE,
	IDN INT, Salary DECIMAL(20,2), Deduction DECIMAL(20, 2), UpdateTime DATETIME);
    select * from EmployeesUpdateRecords1;
    
DELIMITER //
CREATE TRIGGER ReSetDeduction
	BEFORE
    UPDATE
    ON employees
    FOR EACH ROW
BEGIN
	SET NEW.deduction = (NEW.salary * (0.02)) + 50;
    INSERT INTO EmployeesUpdateRecords1
    VALUES(old.LName, old.BirthDay, old.IDN, old.Salary, old.Deduction, now());
END//
DELIMITER ;
select * from employees;
select * from employeesupdaterecords1;
update employees set salary = salary + 100 where salary < 4000;

drop procedure if exists Remainder;
DELIMITER //
CREATE PROCEDURE Remainder(a INT, b INT)
BEGIN
	DECLARE s INT;
    SET s = a % b;
    SELECT CONCAT('Remainder is: ', s) AS Remainder;
END //
DELIMITER ;
CALL Remainder(10,3);
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER //
CREATE FUNCTION Remainder2(a INT, b INT) RETURNS INT
BEGIN
	DECLARE s INT;
    SET s = a % b;
    RETURN(s);
END //
DELIMITER ;
select remainder2(10,3);

DELIMITER //
CREATE PROCEDURE GetDeduction(a INT)
BEGIN
	DECLARE DDeduction DECIMAL;
    SELECT Deduction FROM Employees
    WHERE a = IDN
    INTO DDeduction;
    SELECT CONCAT('Deduction is: ', DDeduction) AS Deduction;
END//
DELIMITER ;
call getdeduction(1);
select * from employees;


DELIMITER //
CREATE FUNCTION GetDeduction1(a INT) RETURNS DECIMAL
BEGIN
	DECLARE DDeduction DECIMAL;
    SELECT Deduction FROM Employees
    WHERE a = IDN
    INTO DDeduction;
    RETURN(DDeduction);
END//
DELIMITER ;
select getdeduction1(1);

drop procedure if exists prodev;
DELIMITER //
CREATE PROCEDURE ProdEv(num INT)
BEGIN
	DECLARE n, PE INT;
    set n = num, PE = 1;
    WHILE n <> 0 DO
		IF (n %2 = 0) THEN
			SET PE = PE * n;
			END IF;
        SET n = n + 1;
	END WHILE;
    SELECT CONCAT('Product of Negative Even Intergers: ', PE) AS ProdEven;
END//
DELIMITER ;

CALL prodev(-5);

DELIMITER //
CREATE FUNCTION ProdEv1(num INT) RETURNS INT
BEGIN
	DECLARE n, PE INT;
    set n = num, PE = 1;
    WHILE n <> 0 DO
		IF (n %2 = 0) THEN
			SET PE = PE * n;
			END IF;
        SET n = n + 1;
	END WHILE;
    RETURN(PE);
END//
DELIMITER ;
select prodev1(-5);


CREATE TABLE AddressInsertRows(
	FK_IDN INT, CompanyCity VARCHAR(22),
	HomeCity VARCHAR(22), InsertTime DATETIME);

select * from addressinsertrows;

DELIMITER //
CREATE TRIGGER CityAfterInsert
	AFTER
    INSERT
    ON AddressCity
    FOR EACH ROW
BEGIN
	INSERT INTO AddressInsertRows
    VALUES(new.FK_IDN, new.CompanyCity, new.HomeCity, now());
END//
DELIMITER ;

insert into addresscity values(1,'Buffalo','Buffalo');
select * from a

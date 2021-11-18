SHOW DATABASES;

DROP DATABASE IF EXISTS DBEx2;
CREATE DATABASE DBEx2;
SHOW DATABASES;
USE DBEx2;
SHOW TABLES;

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees(
	LName VARCHAR(12) NOT NULL,
	BirthDay DATE NOT NULL,
	IDN INT NOT NULL PRIMARY KEY,
	Salary DECIMAL(20,2) NULL DEFAULT 0 ,
	Deduction DECIMAL(20, 2) NULL DEFAULT 0 );
/* IDN is primary key, the display order may be default to increasing IDN order */
DESCRIBE Employees;
SELECT * FROM employees;

INSERT INTO employees
VALUES ('Peter', '1986-9-6', 1, 1000, 10),
	   ('Mary', '1996-9-6', 12, 2000, 0),
       ('Tony', '1989-7-9', 22, 4000, 32),
       ('Mike', '1999-11-12', 17, 4000, 10),
       ('John', '1980-3-2', 93, NULL, NULL);
SELECT * FROM employees;

SELECT LName, DATE_FORMAT(BirthDay, '%W, %M, %d, %Y') AS Birth_Date
FROM employees;

SELECT CONCAT(LName, ' was born on ', DATE_FORMAT(BirthDay,
'%W, %M %d, %Y')) AS BornDate 
FROM employees;

SELECT CONCAT(LName, ' is ', YEAR(NOW()) - YEAR(birthday), ' years old.')
AS currentage
FROM employees;

-- insert into Employees values ('Tom','1999-11-12', 22, 600,9);
/* check for errors, primary key IDN 22 already exists in the table */

DROP TABLE IF EXISTS IRAs;
CREATE TABLE IRAs(
	FK_IDN int NOT NULL,
	IRA_acct VARCHAR(12),
	Balance DECIMAL(20, 2),
	FOREIGN KEY (FK_IDN) REFERENCES Employees(IDN));
DESCRIBE iras;
SELECT * FROM iras;

INSERT INTO IRAs 
VALUES(1, 'A1', 100), (22, 'A2', 200), (22, 'A3', 400), (93, 'A4', 500);
select * from iras;

update iras 
set FK_IDN = FK_IDN + 1 ; /* check for errors, can not update FK values */

drop table if exists AddressCity;
create table AddressCity(
	FK_IDN int NOT NULL,
	CompanyCity varchar(22),
	HomeCity varchar(22),
	FOREIGN KEY (FK_IDN) REFERENCES Employees(IDN));
DESCRIBE addresscity;
insert into addresscity 
values (1, 'Saint Louis', 'Saint Louis'), (12, 'Saint Louis','Chesterfield'),
	   (22, 'Chesterfield', 'Saint Louis'), (93, 'Chesterfield', 'Chesterfield'),
       (17, 'Fenton','Fenton');
SELECT * FROM addresscity;
-- can not insert new IDN to FK tables, but that same FK_IDN can have mulitple values attached to it
insert into addresscity values (22, 'BCA', 'Saint Louis'); /* Can have more than one recordfor the same FK_IDN */
delete from addresscity where CompanyCity = 'BCA'; /* may delete row in this case, not targeting key */

alter table addresscity add WorkCity varchar(22) NULL;-- Can change the structure of the table, adding a column in this ex
update addresscity set workcity = companycity;-- updates workcity to have same value as companycity

insert into addresscity values (17, 'ABC4', 'Saint Louis','ABC4a' ); /* may insert, can have more records for IDN 17 in employees */

SELECT now(); /* Return the current time of the computer/system/device */
SELECT CURRENT_TIMESTAMP; /* Return the current time of the computer/system/device */
SELECT year(now())-year('1986-9-6') as age;
SELECT year( '2017/08/25') AS DatePartString;
SELECT month( '2017/08/25') AS DatePartString;
SELECT monthname( '2017/08/25') AS DatePartString;
SELECT day( '2017/08/25') AS DatePartString;
SELECT dayofmonth( '2017/08/25') AS DatePartString;
SELECT dayofyear( '2017/08/25') AS DatePartString;

SELECT dayofweek( '2017/08/25') AS DatePartString;
SELECT dayname( '2017/08/25') AS DatePartString; -- day starts on sunday
SELECT date( '2017/08/25') AS DatePartString;
select year(now()) - year('1956-9-6') as YearsOld;
select DATE_FORMAT('1997-10-04 22:23:00', '%W %M %Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%W, %M %d, %Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%W, %M %D, %Y') as FEx; -- %D gives correct format like '1st'
select DATE_FORMAT('1997-10-04 22:23:00', '%w %m %Y') as FEx; -- Lowercase gives number representation
select DATE_FORMAT('1997-10-04 22:23:00', '%w-%m-%Y') as FEx; -- Dashes add a dash to the format
select DATE_FORMAT('1997-10-04 22:23:00', '%d-%m-%Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%m-%d-%Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%m/%d/%Y') as FEx; -- backslash adds a backslash to the format
select DATE_FORMAT('1997-10-04 22:23:00', '%m /%d /%Y') as FEx;
select DATE_FORMAT('1997-10-04 22:23:00', '%m / %d / %Y') as FEx;

drop view if exists viewex1; # drop the view viewex1 if exists
select LName, salary from employees where Salary < 3000;
/* the query used to create the view viewex1 */

create view viewex1 as select LName, salary from employees where salary < 3000;
Select * from viewex1;

drop view if exists viewex2; # drop the view viewex1 if exists
select * from iras where balance < 300; /* the query used to create the view viewex2 */

create view viewex2 as select * from iras where balance < 300; # crteate view
Select * from viewex2;
select * from viewex2 where balance < 150; 
SELECT * FROM employees;
SELECT * FROM viewex1;

update viewex1 set salary = salary + 1000; /* update employees records in viewex1 */
select * from employees; /* Compare the result with the original Employees */

-- View ex1 will now hold peter, because its out of the range of the sub query that created the view.

update employees set salary = salary + 100;
/* update employees records, therefore viewex1 which produce a updated result of the
query, NULL values are not updated. */
select * from employees;

SELECT * FROM viewex1;

select LName, Salary, sum(balance) as Total_IRAB from employees, IRAs where idn =
fk_idn group by idn; /* the query used to create the view viewex3 */

create or replace view viewex3 as select LName, Salary, sum(balance) as Total_IRAB from
employees, IRAs where idn = fk_idn group by idn;
select * from viewex3; 

select LName, Salary, count(IRA_acct) as NumAccts, sum(balance) as Total_IRAB from
Employees, IRAs where idn = FK_idn group by idn; /* the query used to create the view
viewex4 */
create or replace view viewex4 as select LName, Salary, count(IRA_acct) as NumAccts,
sum(balance) as Total_IRAB from Employees, IRAs where idn = FK_idn group by idn;
select * from viewex4; /* will change after change the original tables */

-- Changed this example to see if I can grab viewex4 which is the subquery below and use that to create a table, result is the same.
create table Tableviewex4 as select LName, Salary, count(IRA_acct) as NumAccts,
sum(balance) as TotalIRAB from Employees, IRAs where idn = FK_idn group by idn;
select * from Tableviewex4; /* table will not change after change the original tables */

create table tableviewex5 as select * FROM viewex4;
select * from tableviewex5;




update IRAs set balance = balance + 50 where balance < 300;
select * from iras;
select * from viewex4; /* will change after change the original tables */
select * from Tableviewex4; /* table will not change after change the original tables */


SELECT LName, YEAR(birthday) AS BirthYear, totalb AS totalbalance
FROM employees e, (SELECT FK_IDN, SUM(balance) AS totalb FROM iras GROUP BY FK_IDN) AS t1
WHERE e.IDN = t1.FK_IDN AND totalb >= (SELECT MAX(totalb2) FROM (SELECT SUM(balance) AS totalb2 FROM iras GROUP BY FK_IDN) AS t2);


SELECT LName, YEAR(birthday) AS BirthYear, SUM(balance) AS totalbalance
FROM employees e, iras i
WHERE e.IDN = i.FK_IDN
GROUP BY e.IDN;

SELECT COUNT(e.IDN) as citypop, homecity
FROM employees e, addresscity a
WHERE e.IDN = a.FK_IDN
GROUP BY homecity;

SELECT MAX(t1.citypop) AS maxpop
FROM (SELECT COUNT(e.IDN) as citypop, homecity
FROM employees e, addresscity a
WHERE e.IDN = a.FK_IDN
GROUP BY homecity) AS t1;

select HomeCity, t2.NumofEmployees
from (select HomeCity, count(FK_IDN) as NumofEmployees from addresscity group by HomeCity) t2 
where t2.NumofEmployees >= (select max(t1.NumofEmployees) as LargestN from (select count(FK_IDN) as NumofEmployees from addresscity group by HomeCity) t1);

select min(TotalBalance) as MinTotalB 
from (select FK_IDN, Sum(balance) as TotalBalance from iras group by FK_IDN) t;

DELIMITER //
create procedure pex1()
Begin
	select 'This is a procedure ' as Procedure_example1;
End//
DELIMITER ;

CALL pex1();

delimiter //
create procedure add2(x int, y int)
Begin
	Declare s int;
	set s = x + y;
	select concat(x, ' + ', y, ' = ', s) as addition;
end//
delimiter ;

call add2(3,9);
call add2(-7,86);

delimiter //
create procedure TimeNow()
Begin
	select now() as CurrentTime,
	date_format(now(), '%m/%d/%Y') as NameForm1,
	date_format(now(), '%W, %M %D, %Y') as NameForm2;
End//
delimiter ;

CALL TimeNow();

delimiter //
create procedure EvenOdd(n int)
Begin
	Declare s varchar(12);
	if (n % 2 = 0) then set s = 'even';
		else set s = 'odd';
	end if;
	Select concat(n, ' is ', s) as IntegerEO;
End//
delimiter ;
call EvenOdd(10);
call EvenOdd(121);

delimiter //
create procedure EvenOddC(n int)
Begin
	Declare s varchar(12);
	Case (n % 2) when 0 then set s = 'even'; else set s = 'odd';
	end case;
	Select concat(n, ' is ', s) as IntegerEOC;
End//
delimiter ;
call EvenOddC(10);
call EvenOddC(121);


delimiter //
create procedure SumEO(num int)
Begin
	Declare n, SE, SO int; 
	set n=0, SE=0, SO=0;
	while n<num do
	if (n % 2 = 0) then set SE=SE+n; else set SO=SO+n;
	end if;
	set n=n+1;
	end while;
	select concat('Sum of positive Evens below ', num, ' is: ', SE) as SumEvens,
	concat('Sum of positive Odds below ', num, ' is: ', SO) as SumOdds;
end//
delimiter ;
-- can do the same with case, so instead of if* it will be case(n % 2) when 0 ......
call SumEO(5);
call SumEO(10);
call SumEO(-20);

delimiter //
create procedure PF(num int)
Begin
	Declare i int; Declare S Decimal(20, 4);
	set i=0, S=0;
	while i<=num do
	set S = S +i*SQRT(i);
	set i = i + 1;
	end while;
	select concat('F(', num, ') = ', S) as SumValue;
end//
delimiter ;
call PF(0);
call PF(1);
call PF(5);

delimiter //
create procedure SumEOrp(num int)
Begin
	Declare n, SE, SO int;
	set n=0, SE=0, SO=0;
	if num > 0 then
		Repeat set n = n + 1;        -- example using repeat loop, same outcome for sum of evens/odds for positive integers
			if (n % 2 = 0) then set SE=SE+n; else set SO=SO+n;
			end if;
		until n = num - 1 end repeat;
	end if;
	select concat(' Sum of positive Evens below ', num, ' is: ', SE) as SumEvens,
	concat(' Sum of positive Odds below ', num, ' is: ', SO) as SumOdds;
end//
delimiter ;

delimiter //
create procedure PFactorial(num int)
Begin
	Declare i, Fact int;
	set i=1, Fact=1;
	while i<=num do
		set fact=fact*i;
		set i=i+1;
	end while;
	select concat(num, '! = ', fact) as Factorial;
end//
delimiter ;
call PFactorial(3);
call PFactorial(5);

-- Example Before
DROP PROCEDURE IF EXISTS Totals;
DELIMITER //
create procedure Totals()
Begin
	Declare MaxBalance, TotalBalance decimal(10, 2);
	Declare Num_Accts int;
	select max(balance), sum(balance), count(ira_acct)
	into MaxBalance, TotalBalance, Num_accts from IRAs;
	select concat('$', MaxBalance) as 'Largest IRA Balance',
	concat('$', TotalBalance) as 'Sum of all ira Balance', Num_accts as
		'Number of IRA accounts';
end//
DELIMITER ;
call Totals();

select * from Employees;
select * from iras;

delimiter //
create procedure Updates(Bonus decimal(20,2), adddDeduction int)
Begin
	update IRAs set balance=balance + Bonus where balance <300; 
	update Employees set Deduction=deduction + adddDeduction
		where Salary > 1500;
end//
delimiter ;
call Updates(10, 5);


delimiter //
create procedure GetSalary(emp varchar(20))
Begin
	Declare s decimal(10,2);
	set s=0;
	if emp in (select LName from Employees) then
		select Salary into s from Employees where LName=emp;
		select Concat('Salary of ', emp, ' is $', s ) as EmpSalary;
	else select Concat(emp, ' is not an employee') as NotFound;
	end if;
end//
delimiter ;
call GetSalary('Tony');
call GetSalary('Peterson');

delimiter //
create procedure TotalBalance(I int)
Begin
	Declare s decimal(10,2);
	set s=0;
	if i in (select FK_IDN from IRAs) then
		select sum(balance) into s from IRAs where FK_IDN=i;
		select Concat('Total Balance of IDN ', i, ' is $', s ) as Total_IRA_Balance;
	else select Concat(i, ' does not have an account') NotFound;
	end if;
end//
delimiter ;
call TotalBalance(1);
call TotalBalance(22);
call TotalBalance(122);

select power(3,2);

delimiter //
CREATE PROCEDURE SquareDifference(a INT,b INT)
BEGIN
	DECLARE s INT;
    SET s = POWER(a,2) - b;
    SELECT CONCAT(a,'^2 - ',b, ' = ',s) AS SquareDifference;
END//
delimiter ;
CALL squaredifference(2,1);

delimiter //
CREATE PROCEDURE PFEX2(num INT)
BEGIN
	DECLARE i INT; DECLARE S DECIMAL(20, 5);
	SET i=0, S=0;
	WHILE i<=num DO
		SET S = S + (POWER(i,2) * SQRT(i));
		SET i = i + 1;
	END WHILE;
	SELECT CONCAT('F(', num, ') = ', S) AS SumValue;
END//
delimiter ;
CALL PFEX2(2);

delimiter //
CREATE PROCEDURE GetDeduction(emp VARCHAR(20))
BEGIN
	DECLARE s DECIMAL(10,2);
	SET s=0;
	IF emp IN (SELECT LName FROM Employees) THEN
		SELECT deduction INTO s FROM Employees WHERE LName=emp;
		SELECT CONCAT('Deduction of ', emp, ' is $', s ) AS EmpDeduction;
	ELSE SELECT CONCAT(emp, ' is not an employee') AS NotFound;
	END IF;
END//
delimiter ;
CALL getdeduction('Tony');

SELECT * FROM employees;
drop function if exists fex1;
DELIMITER //
create function fex1() returns varchar(50)
Begin
	Declare S varchar(50);
	Set S = ' Doing nothing function! ';
	Return(S);
End//
DELIMITER ;
Select fex1() as OneMessage;
SET GLOBAL log_bin_trust_function_creators = 1;
drop function if exists fex1a;
DELIMITER //
create function fex1a(InputS varchar(50)) returns varchar(50)
Begin
	Declare S varchar(50);
	Set S = InputS;
	Return(S);
End//
DELIMITER ;
Select fex1a( 'I have something in here! ' ) as MyMessage;

drop function if exists Sum2;
delimiter //
create function Sum2(x int, y int) returns int
Begin
	Declare s int;
	set s = x + y;
	Return(s);
end//
delimiter ;
select Sum2(3,9) as 3Plus9;
select Sum2(3,9);

drop function if exists STSum2;
delimiter //
create function STSum2(x int, y int) Returns varchar(50)
Begin
	Declare s int;
	Declare st varchar(50);
	set s = x + y;
	set st = concat(x, ' + ', y, ' = ', s);
	Return(st);
end//
delimiter ;
select STSum2(3,9) as SumofTwo;

drop function if exists FTimeNow;
delimiter //
create Function FTimeNow() returns varchar(150)
Begin
	Declare st varchar(150);
	Set st = concat(date_format(now(), '%m/%d/%Y'), ' ',
		date_format(now(), '%W, %M %D, %Y'));
	Return(st);
End//
delimiter ;
select FTimeNow() as CurrentTime;

drop function if exists FEvenOdd;
delimiter //
create function FEvenOdd(n int) returns varchar(30)
Begin
	Declare s1, s2 varchar(30);
	if (n % 2 = 0) then set s1 = 'even';
		else set s1 = 'odd';
	end if;
	Set s2 = concat(n, ' is ', s1);
	Return(s2);
End//
delimiter ;
select FEvenOdd(10) as IntegerEO;
select FEvenOdd(121);
-- example using case
drop function if exists FEvenOddC;
delimiter //
create function FEvenOddC(n int) returns varchar(30)
Begin
	Declare s1, s2 varchar(30);
	Case (n % 2) when 0 then set s1 = 'even'; else set s1 = 'odd';
	end case;
	Set s2 = concat(n, ' is ', s1);
	Return(s2);
End//
delimiter ;

drop function if exists FSumI;
delimiter //
create function FSumI(num int) returns int
Begin
	Declare i, S int;
	set i = 0, S = 0;
	while (i <= num) do
		set S = S + i;
		set i = i + 1;
	end while;
	Return(S);
end//
delimiter ;
select FSumI(5) as SumPosIntergers0to5;

drop function if exists FSumE;
delimiter //
create function FSumE(num int) returns int          
Begin
	Declare n, SE int;
	set n=0, SE=0;
	while n<num do
		if (n % 2 = 0) then set SE=SE+n;              -- Can also do odd here, ex n % 2 = 1 (condition)
		end if;
		set n=n+1;
	end while;
	Return(SE);
end//
delimiter ;
select FSumE(5) as SumEvensBelow5;

drop function if exists FSums;
delimiter //
create function FSums(num int) returns Decimal(20, 4)
Begin
	Declare i int; Declare S Decimal(20, 4);
	set i=0, S=0;
	while (i <= num) do
		set S = S +i*SQRT(i) + log(i+1);
		set i = i + 1;
	end while;
	Return(S);
end//
delimiter ;
Select FSums(5);

drop function if exists Factorial;
delimiter //
create Function Factorial(num int) returns int
Begin
	Declare i, Fact int;
	set i = 1, Fact = 1;
	while (i <= num) do
		set Fact = Fact*i;
		set i = i+1;
	end while;
	Return(Fact);
end//
delimiter ;
select Factorial(3) as Factorial3;

-- Uses fact function
drop function if exists FCom;
delimiter //
create Function FCom(n int, r int) returns int
Begin
	Declare c, d int;
	If (n >= r and r >= 0)
		then set d = Factorial(r) * Factorial(n-r); set c = Factorial(n)/d; Return(c);
		else return 1;
	end if;
end//
delimiter ;
select FCom(6, 2);

drop function if exists FAvgSalary;
delimiter //
create function FAvgSalary( ) returns Decimal(20, 2)
Begin
	Declare avgS decimal(10,2); set avgS = 0;
	select AVG(Salary) into avgS from Employees;
	Return(avgS);
end//
delimiter ;
select FAvgSalary();

drop function if exists FUpdates;
delimiter //
create function FUpdates(Bonus decimal(20,2), addDeduct int) Returns varchar(20)
Begin
	update IRAs set Balance=Balance+Bonus where balance <300;
	update Employees set Deduction=Deduction+addDeduct where salary > 1500;
	Return('Updates OK!!');
end//
delimiter ;
select FUpdates(10, 5);
select * from Employees;

drop function if exists FGetSalary;
delimiter //
create function FGetSalary(emp varchar(20)) returns varchar(50)
Begin
	Declare s Decimal(10,2);
	Declare st varchar(50);
	set s=0;
	if emp in (select LName from Employees) then
		select Salary into s from Employees where LName=emp; 
		set st = Concat('Salary of ', emp, ' is $', s );
		else set st = Concat(emp, ' is not an employee');
	end if;
	Return(st);
end//
delimiter ;
select FGetSalary('Tony') as EmpSalary;

drop function if exists FGetSalaryN;
delimiter //
create function FGetSalaryN(emp varchar(20)) returns Decimal(10, 2)
Begin 
	Declare s Decimal(10,2); set s=0;
	if emp in (select LName from Employees) then
		select Salary into s from Employees where LName=emp;
		else set s = Null;
	end if;
	Return(s);
end//
delimiter ;
select FGetSalaryN('Tony');

drop function if exists FTotalBalance;
delimiter //
create function FTotalBalance(i int) returns varchar(50)
Begin
	Declare s Decimal(10,2);
    Declare st varchar(50);
    Declare c int;
	set s=0;
	if I in (select FK_IDN from IRAs) then
		select sum(balance) into s from IRAs where FK_IDN=i;
        select COUNT(ira_acct) into c from IRAs where FK_IDN = i;
        set st = concat("Total Balance = ", s, " ","Number of Accounts = ", c);
		else set st = Null;
	end if;
	Return(st);
end//
delimiter ;
select FTotalBalance(22);


drop function if exists SquareDifference;
delimiter //
CREATE FUNCTION SquareDifference(a INT,b INT) RETURNS INT
BEGIN
    DECLARE s INT;
    SET s = POWER(a,2) - b;
    RETURN s;
END//
delimiter ;
select squaredifference(3,2);

drop function if exists PFSummation;
delimiter //
CREATE FUNCTION PFSummation(num INT) RETURNS DECIMAL(20,5) 
BEGIN
    DECLARE i INT; DECLARE S DECIMAL(20, 5);
    SET i=0, S=0;
    WHILE i<=num DO
        SET S = S + (POWER(i,2) - SQRT(i));
        SET i = i + 1;
    END WHILE;
    return s;
END//
delimiter ;
select PFSummation(2);


drop function if exists GetDeduction;
delimiter //
CREATE FUNCTION GetDeduction(emp VARCHAR(20)) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE s DECIMAL(10,2);
    SET s=0;
    IF emp IN (SELECT LName FROM Employees) THEN
        SELECT deduction INTO s FROM Employees WHERE LName=emp;
		ELSE SET s = NULL;
    END IF;
    RETURN(s);
END//
delimiter ;
select * FROM employees;
Select getdeduction('malcolm');
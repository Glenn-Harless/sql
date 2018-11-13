SET SQL_SAFE_UPDATES = 0;

CREATE TABLE ceu AS SELECT Employee_Number FROM Employees; 
ALTER TABLE ceu ADD ceuAlloted DECIMAL (10,2);
UPDATE ceu SET ceuAlloted = 1000.00;




SELECT * FROM ceu;
SELECT * FROM Employees;
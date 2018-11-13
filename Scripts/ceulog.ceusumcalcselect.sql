SET SQL_SAFE_UPDATES = 0;

CREATE TABLE ceuLog (Employee_Number INT, receiptDate DATE, ceuAmount DECIMAL (10,2))

INSERT INTO ceulog (Employee_Number, receiptDate, ceuAmount) VALUES (10, '2017-03-03', 74.00);
/*
DELETE FROM ceuLog WHERE Employee_Number = 10;
INSERT INTO ceulog (Employee_Number, receiptDate, ceuAmount) VALUES (11, '2017-03-03', 74.00);
INSERT INTO ceulog (Employee_Number, receiptDate, ceuAmount) VALUES (10, '2017-03-03', 74.00);
INSERT INTO ceulog (Employee_Number, receiptDate, ceuAmount) VALUES (10, '2017-03-03', 74.00);
INSERT INTO ceulog (Employee_Number, receiptDate, ceuAmount) VALUES (4, '2017-03-03', 74.00);
INSERT INTO ceulog (Employee_Number, receiptDate, ceuAmount) VALUES (3, '2017-03-03', 74.00);
INSERT INTO ceulog (Employee_Number, receiptDate, ceuAmount) VALUES (3, '2017-03-03', 74.00);
*/

#Selects the employee number, alloted amount, sums the ceu amount used and calculates the available ceu
SELECT ceuLog.Employee_Number, Employees.First_Name, Employees.Last_Name, ceu.ceuAlloted ,SUM(ceuAmount) AS ceuUsed, ceu.ceuAlloted - SUM(ceuAmount) AS ceuAvailable
FROM ceu,ceuLog, employees 
WHERE  employees.employee_number = ceuLog.Employee_Number AND ceuLog.employee_number = ceu.Employee_Number
GROUP BY Employee_Number, First_name, Last_Name, ceuAlloted;

SELECT * FROM ceuLog;

DROP TABLE ceuLog
SELECT * FROM ceuLog
SELECT * FROM 
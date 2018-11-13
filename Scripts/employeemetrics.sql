SET SQL_SAFE_UPDATES = 0;

SELECT * FROM Employees;

#Employees Out
DELETE FROM Employees WHERE Employee_Number =56; #SEAN FRASER OUT

#Calculates number of total employees/admin/bcba/ps/rbt
SELECT COUNT(Employee_Number) AS 'Total Employees' FROM Employees;

SELECT COUNT(Employee_Number) AS 'Total Admin' FROM Employees WHERE positionType = 'Admin';
SELECT COUNT(Employee_Number) AS 'Total BCBAs' FROM Employees WHERE positionType = 'Bcba';
SELECT COUNT(Employee_Number) AS 'Total Ps''' FROM Employees WHERE positionType = 'Ps';
SELECT COUNT(Employee_Number) AS 'Total RBTs' FROM Employees WHERE positionType = 'Rbt';

SELECT COUNT(Employee_Number) AS 'Total Full Time' FROM Employees WHERE positionType != 'Rbt';

#Years Worked - Rounds to 2 digits
SELECT *, ROUND(datediff(curdate(), Start_Date)/365.25,2) AS yearsWorked 
FROM Employees
WHERE (datediff(curdate(), Start_Date)/365.25)>1;


#Months Worked When under 1 year
SELECT *, TIMESTAMPDIFF(month, Start_Date, curdate()) AS monthsWorked 
FROM Employees
WHERE TIMESTAMPDIFF(month, Start_Date, curdate()) < 12;



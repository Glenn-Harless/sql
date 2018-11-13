SET SQL_SAFE_UPDATES = 0;
ALTER TABLE ptoLog
ADD PRIMARY KEY (Employee_Number)
SELECT * FROM ptoTrack

CREATE TABLE ptoTrack AS SELECT Employee_Number, Start_Date FROM Employees
DELETE FROM ptoTrack WHERE Employee_Number = 1 OR Employee_Number = 2;


###Calculates PTO --accurate AF for people hired after the PTO scare of 8-26. Iffy for those before
#doesnt't acount for yearly jump yet

SELECT ptoTrack.Employee_Number, ptoTrack.Start_Date, employees.First_Name, employees.Last_Name,
CASE
	WHEN ptoTrack.Start_Date < '2016-08-26'
         THEN ROUND(datediff(CURDATE(),'2016-08-26')/7,0) 
	 ELSE
		 ROUND(datediff(CURDATE(),ptoTrack.Start_Date)/7,0) END AS weeksWorked,
CASE
	WHEN ptoTrack.Start_Date < '2016-08-26'
    THEN
		CASE
			WHEN ptoTrack.Employee_Number = 12
				THEN ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) - 24.18
			WHEN ptoTrack.Employee_Number = 13
				THEN ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 19.02
			WHEN ptoTrack.Employee_Number = 5
				THEN ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) - 8.38
			WHEN ptoTrack.Employee_Number = 3
				THEN ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 115.82
			WHEN ptoTrack.Employee_Number = 10
				THEN ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 35.02
			WHEN ptoTrack.Employee_Number = 8
				THEN ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 53.62
			ELSE
				 ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 68.32
            END
	 ELSE
		 ROUND(ROUND(datediff(CURDATE(),ptoTrack.Start_Date)/7,0) * 4.615285/2, 2) END AS ptoAccrued,
 SUM(ptoUsed) AS ptoUsed,
 CASE
	WHEN ptoTrack.Start_Date < '2016-08-26'
		THEN
			CASE
			WHEN ptoTrack.Employee_Number = 12
				THEN (ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) - 24.18) - SUM(ptoUsed)
			WHEN ptoTrack.Employee_Number = 13
				THEN (ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 19.02) - SUM(ptoUsed)
			WHEN ptoTrack.Employee_Number = 5
				THEN (ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) - 8.38) - SUM(ptoUsed)
			WHEN ptoTrack.Employee_Number = 3
				THEN (ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 115.82) - SUM(ptoUsed)
			WHEN ptoTrack.Employee_Number = 10
				THEN (ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 35.02) - SUM(ptoUsed)
			WHEN ptoTrack.Employee_Number = 8
				THEN (ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 53.62) - SUM(ptoUsed)
			ELSE
				 (ROUND(ROUND(datediff(CURDATE(),'2016-08-26')/7,0) * 4.615285/2, 2) + 68.32) - SUM(ptoUsed)
            END
	 ELSE
		 ROUND(ROUND(datediff(CURDATE(),ptoTrack.Start_Date)/7,0) * 4.615285/2, 2) - SUM(ptoUsed) END AS ptoAvailable

	FROM ptoTrack, ptoLog , Employees
    WHERE ptoLog.Employee_Number = ptoTrack.Employee_Number AND Employees.Employee_Number = ptoTrack.Employee_Number AND Employees.Employee_Number = ptoLog.Employee_Number
         GROUP BY Employee_Number, Start_Date, First_Name, Last_Name; 
 
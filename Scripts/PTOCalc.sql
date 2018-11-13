SET SQL_SAFE_UPDATES = 0;

Create TABLE PTO AS SELECT * FROM Employees;

UPDATE PTO SET Start_Date = '2016-08-26' WHERE Start_Date <= '2016-08-26';

ALTER TABLE PTO ADD weeksWorked DECIMAL;
UPDATE PTO SET weeksWorked =  ROUND(datediff(CURDATE(),Start_Date)/7,0);

ALTER TABLE PTO ADD PTO_Accrued DECIMAL (5, 2);

UPDATE PTO SET PTO_Accrued = ROUND((WeeksWorked/2 * 4.615285),2);
UPDATE PTO SET PTO_Accrued = PTO_Accrued - 24.18  WHERE Employee_Number = 12;
UPDATE PTO SET PTO_Accrued = PTO_Accrued + 19.02  WHERE Employee_Number = 13;
UPDATE PTO SET PTO_Accrued = PTO_Accrued - 8.38  WHERE Employee_Number = 5;
UPDATE PTO SET PTO_Accrued = PTO_Accrued + 115.82 WHERE Employee_Number = 3;
UPDATE PTO SET PTO_Accrued = PTO_Accrued + 35.02  WHERE Employee_Number = 10;
UPDATE PTO SET PTO_Accrued = PTO_Accrued + 53.62  WHERE Employee_Number = 8;
UPDATE PTO SET PTO_Accrued = PTO_Accrued + 68.32  WHERE Employee_Number = 9;



ALTER TABLE PTO ADD PTO_Used DECIMAL (10,2);

UPDATE PTO SET PTO_Used = 98.50 WHERE Employee_Number = 3;
UPDATE PTO SET PTO_Used = 13 WHERE Employee_Number = 12;
UPDATE PTO SET PTO_Used = 59 WHERE Employee_Number = 10;
UPDATE PTO SET PTO_Used = 16 WHERE Employee_Number = 4;
UPDATE PTO SET PTO_Used = 4 WHERE Employee_Number = 7;
UPDATE PTO SET PTO_Used = 88.75 WHERE Employee_Number = 13;
UPDATE PTO SET PTO_Used = 16 WHERE Employee_Number = 14;
UPDATE PTO SET PTO_Used = 64 WHERE Employee_Number = 9;
UPDATE PTO SET PTO_Used = 8 WHERE Employee_Number = 8;
UPDATE PTO SET PTO_Used = 8 WHERE Employee_Number = 5;

UPDATE PTO SET PTO_Used = 0 WHERE Employee_Number = 6;
UPDATE PTO SET PTO_Used = 0 WHERE Employee_Number = 15;
UPDATE PTO SET PTO_Used = 4 WHERE Employee_Number = 11;
UPDATE PTO SET PTO_Used = 0 WHERE Employee_Number = 16;


ALTER TABLE PTO ADD PTO_Available DECIMAL (10,2);
UPDATE PTO SET PTO_Available = PTO_Accrued - PTO_Used;


Select * FROM PTO;
Drop TABLE PTO;
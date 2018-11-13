
--START MONTHLY REPORT CODE




--billed TOTALS when claim count > 0 everything but Regional Center


SELECT insurancecompanyid AS ID, name as Insurance, 
  SUM(copayamount) AS copay,
  SUM(paidcopay) AS paidcopay,
  (SUM(charge)) as totalBilled,
  (SUM(paidamount) + SUM(paidcopay)) as totalPaid,
    ((SUM(charge)) - (SUM(paidamount) + SUM(paidcopay))) as outstanding, 
  ((SUM(paidamount) + SUM(paidcopay)) / SUM(charge) ) * 100 AS percentPaid


  FROM customers.billing_entries, customers.insurances
  WHERE clientid <> 174263 AND dateofservice > '2017-03-31' AND dateofservice < '2017-05-01' AND claimcount > 0

  AND insurances.id = billing_entries.insurancecompanyid
  GROUP BY insurancecompanyid, name;



--BILLED TOTALS FOR REGIONAL CENTER


SELECT insurancecompanyid AS ID, name as Insurance, 
  SUM(copayamount) AS copay,
  SUM(paidcopay) AS paidcopay,
  (SUM(charge)) as totalBilled,
  (SUM(paidamount) + SUM(paidcopay)) as totalPaid,
    ((SUM(charge)) - (SUM(paidamount) + SUM(paidcopay))) as outstanding, 
  (SUM(paidamount) / SUM(charge) ) * 100 AS percentPaid


  FROM customers.billing_entries, customers.insurances
  WHERE  insurancecompanyid = 1968 AND clientid <> 174263 AND dateofservice > '2016-12-31' AND dateofservice < '2017-02-01' 
  AND exportcount <> 0
  AND insurances.id = billing_entries.insurancecompanyid
  GROUP BY insurancecompanyid, name;


--Selects Client Count by payor for date range
SELECT insurancecompanyid AS ID, name AS Insurance, COUNT(DISTINCT clientid) As clientCountMay 
FROM customers.billing_entries, customers.insurances
WHERE dateofservice > '2017-04-30' AND dateofservice < '2017-06-01' AND insurances.id = billing_entries.insurancecompanyid
GROUP BY insurancecompanyid, name;




--gets monthly total for clients
SELECT 
  DATEPART(month, be.dateofservice) AS MONTH,
   DATEPART(year, be.dateofservice) AS YEAR, 
  COUNT(DISTINCT fullname) FROM customers.billing_entries AS be
LEFT JOIN customers.contacts AS c 
ON c.id = be.clientid
RIGHT JOIN customers.contact_addresses AS ca
on c.id = ca.contactid
WHERE dateofservice > '2016-12-31'
AND ca.zippostalcode < 95000
GROUP BY MONTH, YEAR

--gets monthly total for provicer
SELECT 
  DATEPART(month, be.dateofservice) AS MONTH,
   DATEPART(year, be.dateofservice) AS YEAR, 
  COUNT(DISTINCT fullname) FROM customers.billing_entries AS be
LEFT JOIN customers.contacts AS c
ON c.id = be.providerid
RIGHT JOIN customers.contact_addresses AS ca
ON ca.contactid = c.id
WHERE dateofservice > '2016-12-31'
AND ca.zippostalcode < 95000
GROUP BY MONTH, YEAR

SELECT DISTINCT zippostalcode FROM customers.contact_addresses





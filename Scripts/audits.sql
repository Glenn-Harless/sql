
--finds NPIs
select DISTINCT c.lastname as lastName, c.firstname as firstname, cl.renderingproviderid AS NPI FROM customers.claim_items as cl
LEFT JOIN customers.contacts as c
ON c.id = cl.renderingprovidercontactid
WHERE cl.renderingproviderid IS NOT NULL
ORDER BY c.fullname, cl.renderingproviderid

--finds Missing NPIs from claims as of billing date - last checked was 1/25
select DISTINCT c.lastname as lastName, c.firstname as firstname, cl.renderingproviderid AS NPI FROM customers.claim_items as cl
LEFT JOIN customers.contacts as c
ON c.id = cl.renderingprovidercontactid
WHERE cl.renderingproviderid IS NULL
AND cl.servicedatefrom > '2018-01-25'
ORDER BY c.fullname, cl.renderingproviderid


-- Pulls Names for claims not sent - used to find BT's w/o NPIs
SELECT DISTINCT c.fullname --cl.claimid (you can add this to check for claims in case some have npis but arent sent_
FROM customers.claim_items AS cl
LEFT JOIN customers.contacts AS c
ON c.id = cl.renderingprovidercontactid
WHERE cl.servicedatefrom > '2018-01-01'
AND cl.senton IS NULL
GROUP BY fullname --cl.claimid (add this if you want to search by claimid)


--BILLING // PAYROLL AUDITS

---MILEAGE/DRIVETIME IN FIRST SESSION
---Grabs Everone's first session of each day; finds any mileage or drivetime attached
WITH summary AS (
    SELECT  
           b.dateofservice,
           c.fullname,
           b.mileage,
           b.drivetimeinminutes,
           ROW_NUMBER() OVER(PARTITION BY b.providerid, dateofservice 
                                 ORDER BY b.timeworkedfrom) AS rk
      FROM customers.billing_entries AS b
      LEFT JOIN customers.contacts AS c
      ON c.id = b.providerid
      WHERE dateofservice > '2018-03-04')
SELECT s.*
FROM summary s
WHERE s.rk = 1
AND (mileage > 0
OR drivetimeinminutes >0);


---Find service locations not HOME
SELECT fullname, b.dateofservice, sl.name AS Loc
FROM customers.billing_entries AS b
LEFT JOIN customers.contacts AS c
ON b.clientid = c.id
LEFT JOIN customers.service_locations AS sl
ON sl.id = b.servicelocationid
WHERE dateofservice > '2018-02-04'
AND fullname <> 'Admin Client'
AND loc <> 'Home';




--- Calculate Everones Sick Time ( /40 for WA;;; /30 for CA

SELECT fullname, 
(SUM(DATEDIFF(second, timeworkedfrom, timeworkedto)/3600.00) + SUM(drivetimeinminutes/60.0)) / 40.00
AS Sick_Time_Acc
FROM customers.billing_entries AS be
LEFT JOIN customers.contacts AS c
ON c.id = be.providerid
WHERE c.isactive = 1
AND isvoid = 0
AND be.dateofservice < '2018-02-19'
AND 
  (be.billingcodeid <> 81342)
AND 
  (be.billingcodeid <> 89630)
  AND 
  (be.billingcodeid <> 100411)
  AND 
  (be.billingcodeid <> 66569)
    AND 
  (be.billingcodeid <> 65049)
      AND 
  (be.billingcodeid <> 85237)
        AND 
  (be.billingcodeid <> 95037)
GROUP BY fullname;


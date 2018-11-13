--Patrick biweekly claim total, separates by Office,  calculates SENT AMOUNT
SELECT labelname, SUM(claimamount) FROM 
(SELECT DISTINCT(claimid), claimamount, labelname
FROM customers.claim_items, customers.contact_labels
WHERE servicedatefrom > '2017-03-31'  AND servicedateto < '2017-05-01' AND senton > '2017-01-01'
AND contact_labels.contactid = claim_items.clientid
AND (labelname = 'AOSC' 
OR labelname = 'AOWA'))
GROUP BY labelname;


--Patrick biweekly claim total, separates by Office,  calculates NOT READY FOR SUBMISSION
SELECT labelname, SUM(claimamount) FROM 
(SELECT DISTINCT(claimid), claimamount, labelname
FROM customers.claim_items, customers.contact_labels
WHERE servicedatefrom > '2017-01-01'  AND servicedateto < '2017-04-01'  AND senton IS NULL
AND contact_labels.contactid = claim_items.clientid
AND (labelname = 'AOSC' 
OR labelname = 'AOWA'))
GROUP BY labelname;



--Patrick Quarterly claim total, separates by Office,  calculates TOTAL Billed AMOUNT + SDRC and Cardiff shit
--Not done. Not close to done
SELECT labelname, SUM(claimamount) FROM 
(SELECT DISTINCT claimid, claimamount, labelname
FROM customers.claim_items, customers.contact_labels, customers.billing_entries
WHERE servicedatefrom > '2017-01-01'  AND servicedateto < '2017-04-01' 
AND contact_labels.contactid = claim_items.clientid
AND (labelname = 'AOSC' 
OR labelname = 'AOWA')
AND submitreason = 1
AND claimexportcount = 1)
GROUP BY labelname;


SELECT labelname, SUM(claimamount) as totalClaimBilled
FROM customers.claim_items, customers.contact_labels
WHERE 
---



--billed TOTALS when claim count > 0 everything but Regional Center


SELECT DATEPART(month,billing_entries.dateofservice) AS month, labelname, name as Insurance, 
  SUM(copayamount) AS copay,
  SUM(paidcopay) AS paidcopay,
  (SUM(charge)) as totalBilled,
  (SUM(paidamount) + SUM(paidcopay)) as totalPaid,
    ((SUM(charge)) - (SUM(paidamount) + SUM(paidcopay))) as outstanding, 
  ((SUM(paidamount) + SUM(paidcopay)) / SUM(charge) ) * 100 AS percentPaid


  FROM customers.billing_entries, customers.insurances, customers.contact_labels
  WHERE clientid <> 174263 AND dateofservice > '2017-03-31' AND dateofservice < '2017-05-01' AND claimcount > 0

  AND insurances.id = billing_entries.insurancecompanyid
 AND (contact_labels.labelname = 'AOSC' OR contact_labels.labelname = 'AOWA')
 AND contact_labels.contactid = billing_entries.clientid
 GROUP BY DATEPART(month,billing_entries.dateofservice), labelname, name
 ORDER BY DATEPART(month,billing_entries.dateofservice), labelname, name;

SELECT SUM(chargeamount) FROM customers.billing_entries where dateofservice > '2017-03-31' AND dateofservice < '2017-05-01';

--BILLED MONTHLY TOTALS FOR REGIONAL CENTER -- needs cardiff
--34147	Cardiff School District


SELECT DATEPART(month, billing_entries.dateofservice) AS month, insurancecompanyid AS ID, name as Insurance, 
  SUM(copayamount) AS copay,
  SUM(paidcopay) AS paidcopay,
  (SUM(charge)) as totalBilled,
  (SUM(paidamount) + SUM(paidcopay)) as totalPaid,
    ((SUM(charge)) - (SUM(paidamount) + SUM(paidcopay))) as outstanding, 
  (SUM(paidamount) / SUM(charge) ) * 100 AS percentPaid


  FROM customers.billing_entries, customers.insurances
  WHERE  (insurancecompanyid = 1968 AND clientid <> 174263 
  AND dateofservice > '2017-03-31' AND dateofservice < '2017-05-01' 
  AND exportcount <> 0
  AND insurances.id = billing_entries.insurancecompanyid
  GROUP BY insurancecompanyid, name, DATEPART(month, billing_entries.dateofservice)
  ORDER BY DATEPART(month, billing_entries.dateofservice), name;


---CLIENT COUNT BY PAYOR//SUM || SEPARATES BY OFFICE

--Selects Client Count by payor for date range
SELECT  DATEPART(month, billing_entries.dateofservice) AS month, labelname, name AS Insurance, COUNT(DISTINCT clientid) As clientCountMonth 
FROM customers.billing_entries, customers.insurances, customers.contact_labels
WHERE dateofservice > '2017-01-01' AND dateofservice < '2018-01-01' AND clientid <> 174263 
 AND insurances.id = billing_entries.insurancecompanyid 
 AND (contact_labels.labelname = 'AOSC' OR contact_labels.labelname = 'AOWA')
 AND contact_labels.contactid = billing_entries.clientid
GROUP BY labelname, DATEPART(month, billing_entries.dateofservice), name
ORDER BY DATEPART(month, billing_entries.dateofservice), labelname, name;



---SELECTS SUM DISTINT CLIENT COUNT FOR Each MONTH AND SEPARATES BY OFFICE
SELECT DATEPART(month, billing_entries.dateofservice) AS month, labelname, COUNT(DISTINCT clientid) As clientCountMonth 
FROM customers.billing_entries, customers.contact_labels
WHERE dateofservice > '2017-01-01' AND dateofservice < '2018-01-01' AND clientid <> 174263 
 AND (contact_labels.labelname = 'AOSC' OR contact_labels.labelname = 'AOWA')
 AND contact_labels.contactid = billing_entries.clientid
GROUP BY labelname, DATEPART(month, billing_entries.dateofservice)
ORDER BY DATEPART(month, billing_entries.dateofservice), labelname;




----Employee Count
SELECT DATEPART(month, billing_entries.dateofservice) AS month, labelname, COUNT(DISTINCT billing_entries.providerid)
FROM customers.contact_labels, customers.billing_entries, customers.contacts
WHERE (contact_labels.labelid = 9053
OR contact_labels.labelid = 36264
OR contact_labels.labelid = 9052  --Subtract Liz and Ashley
OR contact_labels.labelid = 147871
---OR contact_labels.labelid = 147868) --Subtract Christine
--OR contact_labels.labelid = 140758) this will be AOWA PS
AND dateofservice > '2017-01-01' AND dateofservice < '2017-09-01' 
AND billing_entries.providerid = contacts.id 
AND contact_labels.contactid = contacts.id
GROUP BY labelname, DATEPART(month, billing_entries.dateofservice)
ORDER BY DATEPART(month, billing_entries.dateofservice), labelname;

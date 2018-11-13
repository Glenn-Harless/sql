
------BILLING SLASH CLAIMS SECITON II

--Monthly billing/paid totals by payor -- OG shows claim export count and totals
--for unsent billing lines are included, The unsent totals are slightly off cant figure
--out why

SELECT insurancecompanyid AS ID,  name as Insurance, claimexportcount,
  SUM(copayamount) AS copay,
  SUM(paidcopay) AS paidcopay,
  CASE WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968
  THEN (SUM(billed) + SUM(copayamount))
       
  WHEN claimexportcount <> 0 AND insurancecompanyid <> 0 OR insurancecompanyid <> 1968 
  THEN (SUM(billed) + SUM(copayamount))

  END as totalBilled, 
  (SUM(paidamount) + SUM(paidcopay)) as totalPaid, 


  ((SUM(billed) + SUM(copayamount)) - (SUM(paidamount) + SUM(paidcopay))) as outstanding,
  (SUM(paidamount) / SUM(billed) ) * 100 AS percentPaid
  FROM customers.billing_entries, customers.insurances
  WHERE clientid <> 174263 AND dateofservice > '2016-12-31' AND dateofservice < '2017-02-01'

  AND insurances.id = billing_entries.insurancecompanyid
  GROUP BY insurancecompanyid, name, claimexportcount
  ORDER BY name, claimexportcount DESC;


SELECT name from customers.insurances, customers.billing_entries WHERE clientid = 174263;










--Monthly billing/paid totals by payor //accounts for unsent lines (claimexportcount = 0)
-- really ugly code figure out how to clean it up but good results
--Accurate for cliams > 0; United has 2000 paid for claimcount = 0; not sure why
--SDRC id = 1968 ; NONE = 0
SELECT
CASE WHEN insurancecompanyid <> 0 AND insurancecompanyid <> 1968 AND claimexportcount > 0
  THEN  insurancecompanyid
  WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968
  THEN  insurancecompanyid
  ELSE null
  END AS Id, 
CASE WHEN insurancecompanyid <> 0 AND insurancecompanyid <> 1968 AND claimexportcount > 0
  THEN  name
  WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968
  THEN  name 
  ELSE null
  END AS Insurance,   
CASE WHEN insurancecompanyid <> 0 AND insurancecompanyid <> 1968 AND claimexportcount > 0
  THEN SUM(copayamount)
  WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968
  THEN SUM(copayamount) 
  ELSE Null
  END AS copay, 
CASE WHEN insurancecompanyid <> 0 AND insurancecompanyid <> 1968 AND claimexportcount > 0
  THEN SUM(paidcopay)
WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968
  THEN SUM(paidcopay) 
  Else Null 
  END AS paidcopay,

CASE WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968
  THEN (SUM(billed) + SUM(copayamount))
       
  WHEN claimexportcount <> 0 AND insurancecompanyid <> 0 AND insurancecompanyid <> 1968 
  THEN (SUM(billed) + SUM(copayamount))
    ELSE NULL END as totalBilled, 
  
CASE WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968
  THEN  (SUM(paidamount) + SUM(paidcopay))
       
  WHEN claimexportcount <> 0 AND insurancecompanyid <> 0 AND insurancecompanyid <> 1968 
  THEN  (SUM(paidamount) + SUM(paidcopay))
    ELSE NULL END as totalPaid,  

CASE WHEN insurancecompanyid <> 0 AND insurancecompanyid <> 1968 AND claimexportcount > 0
  THEN ((SUM(billed) + SUM(copayamount)) - (SUM(paidamount) + SUM(paidcopay)))
  
WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968 
  
  THEN ((SUM(billed) + SUM(copayamount)) - (SUM(paidamount) + SUM(paidcopay))) 
  ELSE NULL END AS outstanding,
CASE WHEN insurancecompanyid = 0 OR insurancecompanyid = 1968
  THEN  (SUM(paidamount) / SUM(billed) ) * 100 
       
  WHEN claimexportcount <> 0 AND insurancecompanyid <> 0 AND insurancecompanyid <> 1968 
  THEN  (SUM(paidamount) / SUM(billed) ) * 100 
  ELSE NULL
  END as percentPaid
  FROM customers.billing_entries, customers.insurances
  WHERE clientid <> 174263 AND dateofservice > '2016-12-31' AND dateofservice < '2017-02-01'

  AND insurances.id = billing_entries.insurancecompanyid
  GROUP BY insurancecompanyid, name, claimexportcount
  ORDER BY name DESC;
  

SELECT (fullname), labelid, labelname 
FROM customers.contacts, customers.contact_labels, customers.billing_entries
WHERE isactive = 1 and isemployee = 1 AND labelid = 9053
GROUP BY labelid, labelname;

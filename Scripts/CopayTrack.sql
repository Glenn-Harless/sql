
----CPO{AY TRACK

--Shows all Kiddos with Copays and and how much copayments for the month
SELECT  
        DATEPART(month, billing_entries.dateofservice) AS month,
        contacts.fullname, 
        SUM(billing_entries.copayamount) AS copay,
        SUM(billing_entries.paidcopay) AS coPaid,
        ((SUM(billing_entries.copayamount)) - SUM(billing_entries.paidcopay)) as outstandingcopay,
        DATE(firstcopayinvoicedate) AS InvoiceDate
 
  FROM customers.billing_entries, customers.contacts
  WHERE contacts.id = billing_entries.clientid
  AND dateofservice > '2017-09-30' 
  GROUP BY contacts.fullname, DATEPART(month, billing_entries.dateofservice), firstcopayinvoicedate

  HAVING SUM(copayamount) > 0
  ORDER BY fullname;
  
--Shows all Kiddos with OUTSTANDING Copays and and how much copayments for the month
SELECT  
        DATEPART(month, billing_entries.dateofservice) AS month,
        contacts.fullname, 
        SUM(billing_entries.copayamount) AS copay,
        SUM(billing_entries.paidcopay) AS coPaid,
        ((SUM(billing_entries.copayamount)) - SUM(billing_entries.paidcopay)) as outstandingcopay
 
  FROM customers.billing_entries, customers.contacts
  WHERE contacts.id = billing_entries.clientid
  AND dateofservice > '2017-05-31' 
  GROUP BY contacts.fullname, DATEPART(month, billing_entries.dateofservice)

  HAVING SUM(copayamount) > 0 AND ((SUM(billing_entries.copayamount)) - SUM(billing_entries.paidcopay)) > 0
  ORDER BY fullname;



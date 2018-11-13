-- GRABS BILLABLE HOURS 
SELEcT DISTINCT billing_entries.id,
  DATEPART(month, billing_entries.dateofservice) AS month,
  DATEDIFF( second, timeworkedfrom, timeworkedto) / 3600.00 AS hours,
  billing_codes_and_labels.billinglabelname
  
  
  FROM customers.billing_entries, customers.billing_codes_and_labels, customers.contact_labels

  WHERE billing_entries.billingcodeid = billing_codes_and_labels.billingcodeid
  AND billing_entries.dateofservice > '2016-12-31' AND dateofservice < '2018-01-01'

  AND (billing_codes_and_labels.billinglabelid = 2739
  OR billing_codes_and_labels.billinglabelid = 2740
  OR billing_codes_and_labels.billinglabelid = 3101)
  AND billing_entries.codetype = 'Billable'
  AND billing_entries.isvoid = 0
  AND billing_entries.isdeleted = 0

GROUP BY billing_entries.id, DATEPART(month, billing_entries.dateofservice), timeworkedfrom, timeworkedto, billinglabelname




SELEcT 
DISTINCT
  DATEPART(month, billing_entries.dateofservice) AS month,
  DATEDIFF( second, timeworkedfrom, timeworkedto) / 3600.00 AS hours

   FROM customers.billing_entries, customers.billing_codes_and_labels
   WHERE billing_entries.codetype = 'Billable'
   AND billing_entries.billingcodeid = billing_codes_and_labels.billingcodeid
   AND billing_entries.dateofservice > '2016-12-31' AND dateofservice < '2017-02-01'
   GROUP BY month, timeworkedfrom, timeworkedto


---code to get AOWA billing entries/hours :
---  OR contact_labels.labelid = 147871 OR contact_labels.labelid = 147868)
--AND (contact_labels.labelid = 9053 OR contact_labels.labelid = 9052 OR contact_labels.labelid = 36264)

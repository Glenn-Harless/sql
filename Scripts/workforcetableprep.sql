--Start collecting workforce analytic data: id, name, wage, isactive, gender

SELECT c.id,fullname, c.gender, c.isactive, MAX(be.rateprovider) AS rate,
        c.payrollemployeereference, c.payrollcompany,
         CAST(c.createdon AS date), CAST(c.deletedon AS date)
FROM customers.contacts AS c
LEFT JOIN customers.contact_addresses AS ca
ON c.id = ca.contactid
LEFT JOIN customers.billing_entries AS be
ON c.id = be.providerid
LEFT JOIN customers.billing_codes_and_labels AS bcl
ON bcl.billingcodeid = be.billingcodeid
WHERE isemployee = 1
AND bcl.codetype = 'Billable'
AND be.rateprovider <= 30
GROUP BY c.id, c.payrollemployeereference, fullname,
 c.gender, c.isactive, c.payrollcompany, c.createdon, c.deletedon

SELECT fullname, email, id
FROM customers.contacts
WHERE isemployee = 1
AND isactive = 1


SELECT c.id,fullname, c.gender, c.isactive, be.rateprovider AS rate,
        c.payrollemployeereference, c.payrollcompany,
         CAST(c.createdon AS date), CAST(c.deletedon AS date),
         MIN(be.dateofservice) AS first_billing_day, 
         MAX(be.dateofservice) AS last_billing_day
  FROM customers.contacts AS c
  LEFT JOIN customers.contact_addresses AS ca
  ON c.id = ca.contactid
  LEFT JOIN customers.billing_entries AS be
  ON c.id = be.providerid
  LEFT JOIN customers.billing_codes_and_labels AS bcl
  ON bcl.billingcodeid = be.billingcodeid
  WHERE c.isemployee = 1
  AND isactive = 0
  AND be.rateprovider > 15
  GROUP BY c.id, c.payrollemployeereference, fullname,
 c.gender, c.isactive, c.payrollcompany, c.createdon, c.deletedon, be.rateprovider

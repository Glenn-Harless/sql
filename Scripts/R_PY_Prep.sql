-- FINDS BILLED VS OWED FOR EACH PAYER
SELECT
be.dateofservice, i.name, bcl.billinglabelname, SUM(be.billed) AS billed, SUM(be.paidamount) AS paid
FROM customers.billing_entries AS be
LEFT JOIN customers.insurances as i
ON i.id = be.insurancecompanyid
LEFT JOIN customers.billing_codes_and_labels AS bcl
ON bcl.billingcodeid = be.billingcodeid
WHERE be.dateofservice > '2016-12-31'
AND be.dateofservice < '2018-06-01'
AND (bcl.billinglabelid = 9367 OR bcl.billinglabelid = 9368)
AND bcl.codetype = 'Billable'
GROUP BY be.dateofservice, i.name, bcl.billinglabelname;


---Pulls Claim Info from 2017 to find basic stat.model on payment time/amnt
SELECT 
  DISTINCT
  claim_items.claimid, name,
  DATE(firstbilledon) as First_Claim_Sent,
  DATE(firstpaidon) as First_Paid_On,
  DATE(lastbilledon) AS Last_Billed_On,
  DATE(lastpaidon) AS Last_Paid_On,
  DATEDIFF(day, firstbilledon, firstpaidon) AS Days_To_First_Payment,
  DATEDIFF(day, lastbilledon, lastpaidon) AS Days_To_Last_Payment,
  claimexportcount,paymentsmade,
  claimamount, 
  SUM(billing_payments.amount) AS Paid_Amount,
  ((SUM(billing_payments.amount) / claimamount) * 100) AS Percent_Paid
  

FROM 
  customers.billing_entries, customers.claim_items, 
  customers.insurances, customers.billing_payments,
  customers.claim_item_billing_entries

WHERE 
        ---Date Range---
    dateofservice > '2017-01-01'
AND dateofservice < '2018-01-01'


--  AND paymentsmade = 1
  
      ---Insurance Name ---
  AND insurances.id = claim_items.insurancecompanyid
  
      ---Merging billing/claim tables Paid amount---
  AND claim_items.claimid = billing_entries.lastclaimid
  AND billing_entries.id = billing_payments.billingentryid
  AND billing_payments.billingentryid =  claim_item_billing_entries.billingentryid
  AND claim_items.claimid = claim_item_billing_entries.claimid

      ---get rid of voided payments / Obvious outliers (selman and Aetna/MHN secondary shit)
  AND billing_payments.voidedon IS NULL
  AND claimamount <> 0
---AND percent_paid < 201

GROUP BY
  claim_items.claimid, claim_items.id, name, claimamount, claimexportcount
  ,firstbilledon, firstpaidon, lastbilledon, lastpaidon,
  claimexportcount, paymentsmade
  
ORDER BY claimid, name;




--pulls aosc clients vs aowa clients - need to use to add column to break up cancellation data
SELECT DISTINCT fullname, labelname
FROM customers.contacts
LEFT JOIN customers.contact_labels
ON contact_labels.contactid = contacts.id
WHERE isemployee = 0
AND labelid = 145055 OR labelid = 145054


---monthly coount of clients/providers (be.id for aosc/aowa toggle 145055 and 145044 respectively
SELECT count(DISTINCT(fullname)),
DATEPART(month, be.dateofservice) AS MONTH,
DATEPART(year, be.dateofservice) AS YEAR
FROM customers.billing_entries AS be
LEFT JOIN customers.contacts AS c
ON c.id = be.providerid
LEFT JOIN customers.contact_labels AS cl
ON cl.contactid = c.id
WHERE be.dateofservice >= '2017-01-01'
AND cl.labelid = 145054
GROUP BY MONTH, YEAR



---Try and get Auth INFO
SELECT 
  a.id, a.clientid, c.fullname, a.frequency, a.groupauthorizedhours,
  a.groupauthorizedunits, a.groupauthorizationnumber, a.groupid,
  a.grouptotalhours, a.grouptotalunits,a.billingcodeid,
  a.globalstartdate, a.globalenddate,
  bc.code, bcl.billinglabelname,
    SUM(DATEDIFF(second, timeworkedfrom, timeworkedto)/3600.00) AS hoursWorked,
    SUM(be.unitsofservice) AS unitsWorked

FROM customers.authorizations AS a
  LEFT JOIN customers.contacts AS c
    ON c.id = a.clientid
  LEFT JOIN customers.billing_codes as bc
    ON bc.id = a.billingcodeid
  LEFT JOIN customers.billing_codes_and_labels AS bcl
    ON bcl.billingcodeid = a.billingcodeid
   LEFT JOIN customers.billing_entries AS be
    ON be.authorizationid = a.id AND be.billingcodeid = a.billingcodeid
  WHERE c.isactive = 1
    AND c.isemployee = 0
    AND c.id IS NOT NULL
    AND (bcl.billinglabelname = 'Clinical Supervisor' OR bcl.billinglabelname = 'Program Supervisor'
      OR bcl.billinglabelname = 'Behavior Technician')
  GROUP BY a.id, a.clientid, c.fullname, a.frequency, a.groupauthorizedhours,
    a.groupauthorizedunits, a.groupauthorizationnumber, a.groupid,
    a.grouptotalhours, a.grouptotalunits,a.billingcodeid,
    a.globalstartdate, a.globalenddate,
    bc.code, bcl.billinglabelname;



--SELECTS Unconverted Sessions Day Prior
SELECT DISTINCT c.fullname, c.email, CAST(eventstart AS date)
FROM customers.schedule_segments as ss
LEFT JOIN customers.contacts as c
on c.id = ss.principal1
WHERE CAST(ss.eventstart AS date) = CAST(DATEADD(day, -1, GETDATE()) AS date)
AND ss.iscancelled = 0
AND ss.converted = 0
AND ss.isactive = 1

-- SELECT Outstanding Invoices (Previous Month)
SELECT DISTINCT i.invoiceid, i.invoicetype, c.fullname, c.email, i.invoicedate,
 i.dueday, SUM(i.amountowed) AS owed, SUM(i.amountpaid) as Paid
FROM customers.invoice_items as i
LEFT JOIN customers.contacts as c
ON i.clientid = c.id
WHERE EXTRACT(MONTH FROM i.dueday) = EXTRACT(MONTH FROM DATEADD(month, -2, GETDATE()))
AND EXTRACT(YEAR FROM i.dueday) = EXTRACT(YEAR FROM GETDATE())
AND i.isvoid <> 0
AND fullname <> 'Autism Outreach Southern California'
GROUP BY i.invoiceid, c.fullname, c.email, i.invoicedate, i.dueday, i.invoicetype

--employee count is including inactive BTs
SELECT COUNT(DISTINCT c.id), cl.labelname
FROM customers.contacts AS c
LEFT JOIN customers.contact_labels as cl
ON cl.contactid = c.id
WHERE c.isemployee = 1
AND c.isactive = 1
AND (labelid = 9052 OR labelid = 36264 OR labelid = 9053)
GROUP BY cl.labelname

SELECT fullname, email FROM customers.contacts
WHERE isemployee = 1 AND isactive = 1




--- gets missing signature DF email query for python
SELECT c.fullname AS provider, c.email, be.clientid, be.groupid,

CASE WHEN 
  be.signedbyclient
  THEN 1
  ELSE 0
  END AS client_signed

FROM customers.billing_entries as be
LEFT JOIN customers.contacts as c
on c.id = be.providerid
LEFT JOIN customers.contact_labels AS cl
ON c.id = cl.contactid
WHERE CAST(be.dateofservice AS date) = CAST(DATEADD(day, -1, GETDATE()) AS date)
AND (be.clientid <> 174263 AND be.clientid <> 589252 AND be.clientid <> 627085
AND be.clientid <> 678070 AND be.clientid <> 565476 AND be.clientid <> 598378
AND be.clientid <> 678217 AND be.clientid <> 614734 AND be.clientid <> 653361 
AND be.clientid <> 670807 AND be.clientid <> 577104)
AND be.isvoid = 0
AND be.isdeleted = 0
AND (cl.labelid = 9053 OR cl.labelid = 147871)
GROUP BY provider, c.email, be.clientid, client_signed, groupid

SELECT * FROM customers.billing_codes_and_labels


                                            
--- PULL ALL PAYOR CODES HR / UNIT REF
SELECT DISTINCT bl.name, bcl.code, bcl.shortdesc, bcl.minutesperunit, bcl.modifier1
FROM customers.billing_codes_and_labels AS bcl
LEFT JOIN customers.billing_code_labels as bl
ON bcl.billinglabelid = bl.id
WHERE bcl.codetype = 'Billable'
AND bl.name <> 'Program Supervisor'
AND bl.name <> 'Clinical Supervisor'
AND bl.name <> 'Single Billing'
AND bl.name <> 'San Diego'
AND bl.name <> 'Seattle'
AND bl.name <> 'REG'
AND bl.name <> 'Private ABA'
AND bl.name <> 'Payroll Exclusion'
AND bl.name <> 'Medi-Cal'
AND bl.name <> 'Commercial'
AND bl.name <> 'Cardiff School District'
AND bl.name <> 'Billable'
AND bl.name <> 'Behavior Technician'
AND bl.name <> 'ABA'

SELECT bcl.billinglabelname, bcl.code, bcl.shortdesc FROM customers.billing_codes_and_labels AS bcl
WHERE bcl.billinglabelname = 'San Diego' OR bcl.billinglabelname = 'Seattle'


--- Pulls cancel data: Goal is to find CLIENTS with 4 months in a row of < 80% attendance conversion
SELECT DISTINCT c.fullname, DATEPART(month, CAST(ss.eventstart AS date)) AS MONTH,
DATEPART(year, CAST(ss.eventstart AS date)) AS YEAR,COUNT(ss.eventid),
ss.cancellationreason, ss.cancellationtype, ss.iscancelled, ss.converted
FROM customers.schedule_segments AS ss
LEFT JOIN customers.contacts AS c
ON c.id = ss.principal2
WHERE (ss.isactive = 1 OR ss.iscancelled = 1)
AND DATEPART(month, CAST(ss.eventstart AS date)) >= DATEPART(month,DATEADD(month, -4, GETDATE()))
AND DATEPART(month, CAST(ss.eventstart AS date)) <= DATEPART(month,DATEADD(month, -1, GETDATE()))
AND DATEPART(year, CAST(ss.eventstart AS date)) = DATEPART(year,GETDATE())
AND (ss.cancellationreason <> 'Other' AND ss.cancellationreason <> 'Provider Change'
AND ss.cancellationreason <> 'Appointment made with incorrect client' AND ss.cancellationreason <> 'Company Observed Holiday'
AND ss.cancellationreason <> 'Invalid Admin Client appointment' OR ss.cancellationreason IS NULL) ---maybe add ss.cancellationreason <> 'Services suspended - No authorization'
AND fullname <> 'Admin Client' AND fullname <> 'Leslie Knope'
GROUP BY c.fullname, MONTH, YEAR, 
ss.cancellationreason, ss.cancellationtype, ss.iscancelled, ss.converted




---- For Web App to quickly show claim periods with problems ++ add payroll data for
SELECT be.dateofservice, i.name, bcl.billinglabelname, (be.billed + be.copayamount) AS billed , 
(be.paidamount + be.paidcopay - be.paidadjustment) AS paid,
              CAST(be.firstbilledon AS date), CAST(be.firstpaidon as date),
              be.firstinvoicedate
              FROM customers.billing_entries AS be
              LEFT JOIN customers.insurances as i
              ON i.id = be.insurancecompanyid
              LEFT JOIN customers.billing_codes_and_labels AS bcl
              ON bcl.billingcodeid = be.billingcodeid
              WHERE be.dateofservice > '2017-12-25'
              AND be.dateofservice < GETDATE()
              AND (bcl.billinglabelid = 9367 OR bcl.billinglabelid = 9368)
              AND bcl.codetype = 'Billable'
              AND be.isdeleted = 0;
              




--- For COMPANY METRIC ModeL
WITH sq AS
  (SELECT
      bcl.billingcodeid,
      bcl.billinglabelname AS prov_level
    FROM customers.billing_codes_and_labels AS bcl
    WHERE (bcl.billinglabelid = 2740 OR bcl.billinglabelid = 2739
    OR bcl.billinglabelid = 3101 OR bcl.billinglabelid = 11860)
   ),
emps AS (
SELECT c.id, c.fullname AS provider
FROM customers.contacts AS c
)
SELECT
    be.dateofservice,
    i.name,
    bcl.billinglabelname,
    (be.billed + be.copayamount) AS billed ,
    (be.paidamount + be.paidcopay - be.paidadjustment) AS paid,
    DATEDIFF(second, be.timeworkedfrom, be.timeworkedto)/3600.00 AS hoursworked,
    be.drivetimeinminutes / 60.00 AS drivetime_hours,
    be.mileage,
    c.fullname AS clients,
    emps.provider,
    sq.prov_level,
    CAST(be.firstbilledon AS date),
    CAST(be.firstpaidon as date),
    be.firstinvoicedate
              FROM customers.billing_entries AS be
              LEFT JOIN customers.insurances as i
              ON i.id = be.insurancecompanyid
              LEFT JOIN customers.billing_codes_and_labels AS bcl
              ON bcl.billingcodeid = be.billingcodeid
              LEFT JOIN sq AS sq
              ON sq.billingcodeid = bcl.billingcodeid
              LEFT JOIN customers.contacts AS c
              ON c.id = be.clientid
              LEFT JOIN emps AS emps
              ON emps.id = be.providerid
              WHERE be.dateofservice > '2016-12-25'
              AND be.dateofservice < GETDATE()
              AND (bcl.billinglabelid = 9367 OR bcl.billinglabelid = 9368)
              AND bcl.codetype = 'Billable'
              AND be.isdeleted = 0
              AND be.isvoid = 0;
              

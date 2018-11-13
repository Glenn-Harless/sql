---IT FUCKING WORKS - Shows the amount paid/percentage for each payment 

SELECT 
  DISTINCT
  claim_items.claimid, name, 
  DATE(firstbilledon) as firstClaimSent,
  DATE(firstpaidon) as firstPaymentON,
  
  DATE(lastbilledon) as lastBilledOn,
  DATE(lastpaidon) AS lastPaidOn,
  DATEDIFF(day, firstbilledon, firstpaidon) AS timeToFirstPayment,
  DATEDIFF(day, lastbilledon, lastpaidon) AS timeToLastPayment,
  claimexportcount, paymentsmade,
  claimamount,
  SUM(billing_payments.amount), ((SUM(billing_payments.amount) / claimamount) * 100) AS percentPaid
  

FROM 
  customers.billing_entries, customers.claim_items, 
  customers.insurances, customers.billing_payments,
  customers.claim_item_billing_entries

WHERE 
        ---Date Range---
      claim_items.senton > '2016-12-31'
  AND claim_items.senton < '2017-10-13'

--  AND claimexportcount = 1
--  AND paymentsmade = 1
  
      ---Insurance Name ---
  AND insurances.id = claim_items.insurancecompanyid
  
      ---Merging billing/claim tables Paid amount---
  AND claim_items.claimid = billing_entries.lastclaimid
  AND billing_entries.id = billing_payments.billingentryid
  AND billing_payments.billingentryid =  claim_item_billing_entries.billingentryid
  AND claim_items.claimid = claim_item_billing_entries.claimid

      ---get rid of voided payments
  AND billing_payments.voidedon IS NULL
  
GROUP BY
  claim_items.claimid, claim_items.id, name, claimamount,
  firstbilledon, paymentsmade, 
  lastbilledon, firstpaidon,lastpaidon, 
  claimexportcount
  
ORDER BY claimid, name, timetofirstpayment;






--, claim_items.billingentrygroupid, billing_entries.groupid
*/



SELECT  
  DISTINCT claimamount, DATE(paymentdate),
  SUM(billing_entries.paidamount)
 FROM 
  customers.billing_entries , customers.claim_items, customers.billing_payments
WHERE lastclaimid = 2132206 
AND billing_entries.lastclaimid = claim_items.claimid
AND billing_entries.id = billing_payments.billingentryid

GROUP BY   claimamount, claim_items.id, paymentdate;


SELECT * FROM customers.claim_items
WHERE claimid = 2132206;


----checks what all populates
SELECT * FROM customers.claim_items, customers.billing_entries, customers.billing_payments
WHERE claim_items.claimid = 1168668
AND claim_items.claimid = billing_entries.lastclaimid
AND billing_payments.billingentryid = billing_entries.id


SELECT  SUM(claimamount), DATE(senton)
FROM customers.claim_items
WHERE servicedatefrom > '2017-10-29' AND servicedateto < '2017-11-15'
GROUP BY senton;




---IT FUCKING WORKS - Shows the amount paid/percentage for each payment 

SELECT 
  DISTINCT
  claim_items.claimid, name,
  DATE(firstbilledon) as ogClaimSent,
  DATE(paymentdate) as paymentOn,
  DATEDIFF(day, firstbilledon, paymentdate) AS daysToPayment,
  claimexportcount,
  claimamount,
  SUM(billing_payments.amount), ((SUM(billing_payments.amount) / claimamount) * 100) AS percentPaid
  

FROM 
  customers.billing_entries, customers.claim_items, 
  customers.insurances, customers.billing_payments,
  customers.claim_item_billing_entries

WHERE 
        ---Date Range---
dateofservice > '2017-01-01'


--  AND paymentsmade = 1
  
      ---Insurance Name ---
  AND insurances.id = claim_items.insurancecompanyid
  
      ---Merging billing/claim tables Paid amount---
  AND claim_items.claimid = billing_entries.lastclaimid
  AND billing_entries.id = billing_payments.billingentryid
  AND billing_payments.billingentryid =  claim_item_billing_entries.billingentryid
  AND claim_items.claimid = claim_item_billing_entries.claimid

      ---get rid of voided payments
  AND billing_payments.voidedon IS NULL
  
GROUP BY
  claim_items.claimid, claim_items.id, name, claimamount, claimexportcount
  ,firstbilledon,
  paymentdate,
  claimexportcount
  
ORDER BY claimid, name, daysToPayment;

SELEcT paymentdate FROM customers.billing_payments, customers.billing_entries, customers.claim_items
WHERE firstclaimid = 764957
AND billing_entries.id = billing_payments.billingentryid;

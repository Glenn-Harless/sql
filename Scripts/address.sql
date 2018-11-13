SELECT DISTINCT
fullname, addressline1, addressline2, city, country, zippostalcode
FROM customers.contact_addresses, customers.contacts
WHERE contacts.typeid = 572
AND contacts.id = contact_addresses.contactid
AND contacts.isactive = 1
AND 
    (addressline1 != '3110 Camino Del Rio S'
AND addressline1 != '3110 Camino Del Rio South'
AND addressline1 != '3110 Camino del Rio S'
AND addressline1 != '3110 Camino del Rio South'
AND addressline1 != '3110 Camino del Rio S #307'
AND addressline1 != '10400 NE 4th Street'
AND addressline1 != '10400 NE 4th St.'
AND addressline1 != '10400 NE 4th ST #500'
AND addressline1 != '3336 Talbot Street')
GROUP BY fullname, addressline1, addressline2, city, country, zippostalcode



---gets client address CAN actually include it in the segment below
SELECT DISTINCT
fullname, guardianfirstname, guardianlastname, addressline1, addressline2, city, country, zippostalcode
FROM customers.contact_addresses, customers.contacts
WHERE contacts.typeid = 20
AND contacts.id = contact_addresses.contactid
AND contacts.isactive = 1
AND 
    (addressline1 != '3110 Camino Del Rio S'
AND addressline1 != '3110 Camino Del Rio South'
AND addressline1 != '3110 Camino del Rio S'
AND addressline1 != '3110 Camino del Rio South'
AND addressline1 != '3110 Camino del Rio S #307'
AND addressline1 != '10400 NE 4th Street'
AND addressline1 != '10400 NE 4th St.'
AND addressline1 != '10400 NE 4th ST #500'
AND addressline1 != '3336 Talbot Street')
GROUP BY fullname, guardianfirstname, guardianlastname, addressline1, addressline2, city, country, zippostalcode



--try to pull client schedule with address
SELECT fullname, addressline1, addressline2, city, country, zippostalcode,
---pull providers and session times
schedule_client_availability.name
FROM customers.contact_addresses, customers.contacts, customers.schedule_segments, customers.schedule_client_availability
WHERE contacts.typeid = 20 AND schedule_segments.contactaddressid = contact_addresses.id
AND contacts.id = contact_addresses.contactid AND schedule_segments.principal2 = contact_addresses.contactid
AND contacts.id = schedule_client_availability.clientid AND schedule_segments.principal2 = schedule_client_availability.clientid
 AND schedule_segments.principal2 = contacts.id

GROUP BY fullname, addressline1, addressline2, city, country, zippostalcode, schedule_client_availability.name

---Finds Unconverted Sessions for the DATE RANGE (specific unconverted session)

SELECT contacts.fullname, DATE(eventstart)

FROM customers.contacts, customers.schedule_segments
WHERE contacts.id = schedule_segments.principal1
AND converted < 1
AND schedule_segments.isactive = TRUE
AND segmentstart > '2017-11-11' AND segmentstart < '2017-11-27'
GROUP BY contacts.fullname, eventstart;

---Finds People with Unconverted Sessions for the DATE RANGE (name goes on the list if they have > 0 unconverted sessions

SELECT contacts.fullname

FROM customers.contacts, customers.schedule_segments
WHERE contacts.id = schedule_segments.principal1
AND converted < 1
AND schedule_segments.isactive = TRUE
AND segmentstart > '2017-11-16' AND segmentstart < '2017-12-04'
GROUP BY contacts.fullname;

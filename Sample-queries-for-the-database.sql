--1. Most grown crop in Ahmedabad?
SET SEARCH_PATH TO farmmanagement;
SELECT cname, count AS no_of_farmers
FROM (SELECT cname, count(cname) FROM farm_details 
GROUP BY cname,district HAVING district ='Ahmedabad') as r1
WHERE count = (Select max(count) as avail FROM(SELECT cname, count(cname) 
FROM farm_details GROUP BY cname,district 
HAVING district ='Ahmedabad') as r2);


--2.  What should be the soil type and climate to grow both tomato and potato?
SET SEARCH_PATH TO farmmanagement;
SELECT c1.cname, c2.cname, c1.climate, c1.soil from crops as c1 CROSS JOIN crops as c2 
WHERE c1.cname='Tomato' AND c2.cname='Potato' AND c1.soil=c2.soil AND c1.climate=c2.climate;


--3. Details of farmer who provides best wheat? 
SET SEARCH_PATH TO farmmanagement;
SELECT cname, qfactor, fid, fname, contactnum, address from farmers natural join farm_details 
where qfactor= (SELECT max(qfactor) from farm_details where cname= 'Wheat') and cname = 'Wheat';


--4.  Min cost of buying average quality crops?
SET SEARCH_PATH TO farmmanagement;
SELECT min(r.sellingprice) as min_cost, cname FROM (SELECT f1.* from farm_details as f1 JOIN farm_details as f2 ON f1.cname=f2.cname
WHERE (f1.qfactor=2 or f1.qfactor=3) and (f2.qfactor=2 or f2.qfactor=3) and f1.sellingprice<f2.sellingprice) as r 
GROUP BY cname;


--5. District wise Total Revenue? 
SET SEARCH_PATH TO farmmanagement;
SELECT district, sum(qty*rate) as TotalRevenue FROM Transactions NATURAL JOIN farm_details GROUP BY district;


--6. Give year wise revenue 
Set search_path to farmmanagement;
SELECT EXTRACT(year FROM date), SUM(rate*qty) FROM Transactions GROUP BY EXTRACT(year FROM date);


--7.  Name the farmer that provides cheapest wheat of either qfactor 2 or 3
Set search_path to farmmanagement;
SELECT sellingprice, fid, fname FROM farm_details 
NATURAL JOIN farmers 
WHERE sellingprice=(SELECT min(sellingprice) from farm_details WHERE cname= 'Wheat' AND (qfactor=2 OR qfactor=3)) 
and cname= 'Wheat' AND (qfactor=2 OR qfactor=3);  

--OR (method 2)

Set search_path to farm;
SELECT sellingprice, fid, fname FROM farm_details 
NATURAL JOIN farmers 
WHERE sellingprice=(SELECT min(sellingprice) from farm_details WHERE qfactor=5 AND (cname='Rice' OR cname='Cotton')) 
and qfactor=5 AND (cname='Rice' OR cname='Cotton'); 


--8. Best farmer

--In terms of sq. area:
set search_path to farm;
SELECT fname, sqArea from Farmers NATURAL JOIN Farm_details WHERE sqArea=(SELECT max(sqArea) FROM Farm_details);

--In terms of income:
set search_path to farm;
SELECT fname, income from Farmers WHERE income=(SELECT max(income) FROM Farmers);


--9. Best buyer 
--In terms of gross purchase:
SELECT bid, bname FROM transactions NATURAL JOIN buyers WHERE rate*qty=(SELECT max(rate*qty) FROM transactions);


--10. Total purchase by each company
Set search_path to farm;
SELECT company, sum(rate*qty) as TotalPurchase FROM Buyers NATURAL JOIN Transactions WHERE company IS NOT NULL
GROUP BY company;


--11. Count of current schemes for each farmer 

SET SEARCH_PATH TO farm;
SELECT fid, count(schid) from farmer_schemes WHERE  extract(year from startdate)<=2017 AND extract(year from enddate)>=2017
GROUP BY  fid;


--12. Total stock of each crop in Gujarat

SET SEARCH_PATH TO farm;
SELECT cname, sum(availability) from farm_details GROUP BY cname ;  


--13. Fetch name, id, contact details of all the buyers of company: MILLENNIUM COMMODITIES  

SET SEARCH_PATH TO farm;
SELECT bid, bname, contactnum from buyers where company='MILLENNIUM COMMODITIES'

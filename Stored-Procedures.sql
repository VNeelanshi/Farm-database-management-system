--Stored Procedure 1: Find the profit margin of a farmer

SET SEARCH_PATH to farmmanagement; 

CREATE OR REPLACE  FUNCTION profitMargin(ffid bigint) RETURNS integer as $BODY$

DECLARE

incoming numeric(4,0);
outgoing numeric(10,0);

BEGIN
SELECT sum(costprice) into incoming FROM farm_details WHERE fid=ffid;
SELECT sum(sellingprice) into outgoing FROM farm_details WHERE fid=ffid;
RAISE NOTICE 'fid is %', ffid;
RETURN (outgoing-incoming);

END
$BODY$ LANGUAGE 'plpgsql';

--Stored Procedure 2: Check how many kilos of a crop are available and can be bought 

--SET SEARCH_PATH to farmmanagement; 
CREATE OR REPLACE  FUNCTION checkAvail(purCap bigint, crop varchar, qf integer) RETURNS real as $BODY$

DECLARE
rate numeric;
qty numeric;
no_of_crops real;
 
BEGIN
SELECT min(sellingprice) INTO rate FROM Farm_details where cname=crop and qfactor=qf;
SELECT availability INTO qty FROM Farm_details where cname=crop and qfactor=qf and sellingprice=rate;

no_of_crops = purCap/rate; 
IF no_of_crops <= qty THEN
RAISE NOTICE 'Maximum quantity that can be bought is %', no_of_crops; 
RETURN no_of_crops;

ELSE 
RAISE NOTICE 'Maximum quantity that can be bought is %', qty;
RETURN qty;
END IF;
END;
$BODY$ LANGUAGE 'plpgsql';

--Stored procedure 3:  Find the rise/decrease in the revenue of  a farmer within a span of given months

CREATE OR REPLACE  FUNCTION rise_decrease(indate date, outdate date, ffid bigint) RETURNS real as $BODY$

DECLARE

incoming numeric(4,0);
outgoing numeric(10,0);
growth_rate numeric(5,2);
inmonth integer = EXTRACT(month FROM indate);
outmonth integer= EXTRACT(month FROM outdate);

x integer = outmonth-inmonth;

BEGIN
SELECT sum(qty*rate) into incoming FROM transactions WHERE fid=ffid AND  EXTRACT(month FROM date)= inmonth;
SELECT sum(qty*rate) into outgoing FROM transactions WHERE fid=ffid AND  EXTRACT(month FROM date)= outmonth; 

growth_rate = ((outgoing-incoming)/x);
RETURN growth_rate;

END
$BODY$ LANGUAGE 'plpgsql'; 

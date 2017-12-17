--1] To check that end date is greater than start date

CREATE OR REPLACE FUNCTION farm_scheme() RETURNS TRIGGER AS  $farm_scheme$
BEGIN

IF NEW.startdate > NEW.enddate THEN
RAISE EXCEPTION 'End date has to be after start date';
ELSE
RETURN NEW;
END IF;

END;
$farm_scheme$ LANGUAGE plpgsql;

CREATE TRIGGER farm_scheme BEFORE INSERT OR UPDATE ON farmer_schemes
FOR EACH ROW EXECUTE PROCEDURE farm_scheme();

--check using the instruction following
--INSERT INTO farmer_schemes VALUES(825624756421, 1014, '2009-01-02', '2011-01-02');

--2] Update database as required

CREATE OR REPLACE FUNCTION trans() RETURNS TRIGGER AS  $trans$
BEGIN

IF(TG_OP='INSERT') THEN
UPDATE farm_details SET availability = availability - NEW.qty;
RETURN NEW;
END IF;

END;
$trans$ LANGUAGE plpgsql;

CREATE TRIGGER trans AFTER INSERT OR UPDATE OR DELETE ON transactions
FOR EACH ROW EXECUTE PROCEDURE trans();

--check using the instruction following
--INSERT INTO transactions VALUES(497341613429, 'Jowar', 3, 380343467356, '2016-01-11', 10, 4);

--The DDL Script file used to create tables
-- Tables are: Farmners, Crops, Buyers, Schemes, Quality, Farm_details, Transactions, Farmer_Schemes

CREATE SCHEMA farmManagement;
SET SEARCH_PATH TO farmManagement;

CREATE TABLE Farmers (
fid BIGINT,
fname VARCHAR(50), 
contactNum BIGINT,
address VARCHAR(100),
age SMALLINT, 
income DECIMAL(10,0),
UNIQUE (fid),
PRIMARY KEY (fid)
);


CREATE TABLE Crops (
cname VARCHAR(50), 
climate VARCHAR(50),
soil VARCHAR(50),
fertiliser VARCHAR(50),
UNIQUE (cname),
PRIMARY KEY (cname)
);


CREATE TABLE Buyers (
bid BIGINT,
bname VARCHAR(50), 
contactNum BIGINT,
age SMALLINT, 
address VARCHAR(90),
income DECIMAL(50,0),
companyName VARCHAR(50), 
PRIMARY KEY (bid)
);



CREATE TABLE Schemes (
schid SMALLINT,
sname VARCHAR(50),
type VARCHAR(50),
eligibility DECIMAL(50,0),
issuedby VARCHAR(50), 
PRIMARY KEY (schid)
);

CREATE TABLE Quality (
qfactor SMALLINT,
UNIQUE (qfactor), 
PRIMARY KEY (qfactor)
);

CREATE TABLE Farm_details (
fid BIGINT,
cname VARCHAR(50),
qfactor SMALLINT,
costPrice SMALLINT,
Availability INTEGER,
sellingPrice SMALLINT,
sqArea DECIMAL(50,0),
district VARCHAR(50), 
FOREIGN KEY (fid) REFERENCES Farmers(fid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (cname) REFERENCES Crops(cname) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (qfactor) REFERENCES Quality (qfactor) ON DELETE SET DEFAULT ON UPDATE CASCADE,
PRIMARY KEY (fid,cname,qfactor)
);

CREATE TABLE Transactions (
fid BIGINT,
cname VARCHAR(50),
qfactor SMALLINT,
bid BIGINT,
date DATE,
rate SMALLINT,
qty INTEGER,
FOREIGN KEY (fid) REFERENCES Farmers(fid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (cname) REFERENCES Crops(cname) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (bid) REFERENCES Buyers(bid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (qfactor) REFERENCES Quality (qfactor) ON DELETE SET DEFAULT ON UPDATE CASCADE,
PRIMARY KEY (fid,cname,qfactor,bid,date)
);

CREATE TABLE Farmer_Schemes (
fid BIGINT,
schid SMALLINT,
startDate DATE,
endDate DATE,
FOREIGN KEY (fid) REFERENCES Farmers(fid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
FOREIGN KEY (schid) REFERENCES Schemes(schid) ON DELETE SET DEFAULT ON UPDATE CASCADE,
PRIMARY KEY (fid,schid)
);

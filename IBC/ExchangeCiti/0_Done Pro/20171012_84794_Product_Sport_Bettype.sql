Use bodb02
GO 

/*

Creator: Sophia
Date: 20171017
DB: DBPRO.bodb02
Description: Add sporttype & bettype for CitiBet [redmine :#84794]

Product name: Exchange
Product ID: 31
Sport name: Exchange
Sport type ID: 221
Transfer bet type: 22030: DTRABX (Exchange Transfer); 22031:DCANBX (Exchange Cancel Transfer)


*/ 
----Products
INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun) VALUES (31,'Exchange','Exchange','BX',1,4,NULL,0,0,0)
 

-- Insert sporttype 
INSERT INTO Sports (SportType, SportName) 
SELECT	221, 'Exchange' 



-- Insert bettype
INSERT INTO bettype (typeid, typenamee, typenamec, typedesc, typenamec_uni, ParentTypeid)
SELECT 22030, 'DTRABX', 'DTRABX', 'Exchange Transfer', 'DTRABX', 22030

INSERT INTO bettype (typeid, typenamee, typenamec, typedesc, typenamec_uni, ParentTypeid)
SELECT 22031, 'DCANBX', 'DCANBX', 'Exchange Cancel Transfer', 'DCANBX', 22031


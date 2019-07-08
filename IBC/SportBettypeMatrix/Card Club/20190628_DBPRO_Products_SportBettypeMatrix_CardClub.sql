USE bodb02
GO

/*
	Created: 20190628@Percy
	DB: DBPRO.bodb02
	Task: New product: Card Club
*/

-- Products
INSERT INTO  Products  (ProductID,ProductName,Description,ProductPrefix,Enabled,BalanceType,SubProductBalanceType, GroupType,CasinoType,IsOfferPlayForFun) 
VALUES (34,'Card Club','Card Club','CC',1,3,NULL,0,1,0) 
 
GO


-- SportBettypeMatrix
DELETE dbo.SportBettypeMatrix WITH (ROWLOCK, UPDLOCK)
WHERE SportType IN (163, 165)

INSERT INTO dbo.SportBettypeMatrix (sporttype,bettype,islive,productid,enabled,istest,eventtype,subproduct,RefTable)
	VALUES (165,1901,0,34,1,0,0,'',1)
GO

--------------------------------------------------

USE bodb_Licensee
GO

/*
	Created: 20190628@Percy
	DB: DBCUST.bodb_Licensee
	Task: New product: Card Club/


*/

-- Products

INSERT INTO  Product3rd  (ProductID,ProductName,Description,ProductPrefix,OfferSingle ) VALUES (34,'Card Club','Card Club','CC','1') 
/*<info serverAlias="DBCUST-bodb_Licensee" ></info>*/
/*
	Create : 20210226@Sophia
	Task: Add Products3rd_Habanero [redmine :#145456]
	DB: DBCUST/bodb_Licensee
*/


USE bodb_Licensee

GO 


INSERT INTO  Product3rd  (ProductID,ProductName,Description,ProductPrefix,OfferSingle,ApplyDCS ) VALUES (61,'Habanero','Habanero','HB','1',1)
GO
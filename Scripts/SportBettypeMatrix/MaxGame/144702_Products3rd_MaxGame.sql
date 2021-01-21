/*<info serverAlias="DBCUST-bodb_Licensee" ></info>*/
/*
	Create : 20210121@Sol
	Task: Add MaxGame Product3rd [redmine :#144702]
	DB: DBCUST/bodb_Licensee
*/


USE bodb_Licensee

GO 

INSERT INTO Product3rd(ProductID,ProductName,Description,ProductPrefix,OfferSingle,ApplyDCS ) VALUES (60,'MaxGame','MaxGame','MXG','1',1)

GO
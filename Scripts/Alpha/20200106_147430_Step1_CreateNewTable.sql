/*<info serverAlias="DBTXN-bodb02, DBACC-bodb02"></info>*/
/*
Created: 
Task : Create new table [RedmineID: #147430]
DB: DBTXN/bodb02, DBACC-bodb02
 

*/

CREATE TABLE dbo.BonusTrans
(
	BonusTransId	BIGINT IDENTITY(1000, 1) NOT FOR REPLICATION
	,CustID			INT
	,Recommend		INT
	,Mrecommend		INT
	,Srecommend		INT
	,Amount			MONEY
	,StatusId		TINYINT
	,Creator		INT
	,CreatedDate	DATETIME
	,PaymentDate	SMALLDATETIME
	,IsComplained	BIT
	,CONSTRAINT PK_BonusTrans PRIMARY KEY NONCLUSTERED (BonusTransId)
)

CREATE CLUSTERED INDEX CIX_CreatedDate_Srecommend ON dbo.BonusTrans (CreatedDate, Srecommend)



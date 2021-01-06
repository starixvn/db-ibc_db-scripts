/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
Created: 
Task : Create new table
DB: DBTXN/bodb02

Revisions:
	- 20200106@Malcolm: Create new table [RedmineID: #147430]

*/

CREATE TABLE dbo.BonusTrans
(
	TransId			BIGINT IDENTITY(1000, 1)
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
	,PRIMARY KEY(TransId)
)

CREATE CLUSTERED INDEX cix_CreationDate_CustID ON dbo.BonusTrans (CreatedDate, CustId)

CREATE NONCLUSTERED INDEX ix_Srecommend ON dbo.BonusTrans (Srecommend, CreatedDate) 

CREATE NONCLUSTERED INDEX ix_Mrecommend ON dbo.BonusTrans (Mrecommend, CreatedDate) 

CREATE NONCLUSTERED INDEX ix_Recommend ON dbo.BonusTrans (Recommend, CreatedDate) 



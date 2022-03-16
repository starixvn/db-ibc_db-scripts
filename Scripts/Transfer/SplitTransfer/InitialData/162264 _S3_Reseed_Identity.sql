/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211230@Sol
	DB : DBTRANS-bodb02
	Task: copy data to new table transfer and transferinfo - [Redmine: #162264]
*/

---get latest transid from bettrans
DECLARE @MaxTransId BIGINT

SELECT @MaxTransId = MAX(b.transid) FROM dbo.bettrans b WITH(NOLOCK)

--reseed identity
DBCC CHECKIDENT ('Transfer', RESEED, @MaxTransId);  

GO 
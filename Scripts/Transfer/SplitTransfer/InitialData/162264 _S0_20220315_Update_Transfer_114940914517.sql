/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20220315@Sol
	DB : DBTRANS-bodb02
	Task: update data table transfer and transferinfo - [Redmine: #162264]
*/

USE bodb02;

GO  

DECLARE
	@TransId BIGINT = 114940914517

---update transfer table
UPDATE t
	SET
		t.SerialNo = b.betcheck
FROM dbo.Transfer t
	INNER JOIN dbo.bettrans b WITH(NOLOCK)
		ON t.TransId = b.transid
WHERE t.TransId = @TransId

---insert into transferinfo table for bettype > 20000
UPDATE t
	SET
		t.CheckerName = NULL
FROM dbo.TransferInfo t
WHERE t.TransId = @TransId

GO
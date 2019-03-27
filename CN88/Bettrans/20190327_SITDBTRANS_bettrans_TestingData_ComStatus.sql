USE bodb02
GO

/*
	Created: 20190327@Percy
	DB: SITDBTRANS.bodb02
	Task: Testing data for CN88 - Set comstatus = 0 (no doublecomm)
*/

UPDATE b WITH (ROWLOCK, UPDLOCK)
SET b.comstatus = '0'
FROM dbo.bettrans b
	INNER JOIN CustDB.dbo.Customer c WITH (NOLOCK) ON b.recommend = c.custid
WHERE c.roleid = 2 AND c.site = 'CN88' AND b.bettype < 19999
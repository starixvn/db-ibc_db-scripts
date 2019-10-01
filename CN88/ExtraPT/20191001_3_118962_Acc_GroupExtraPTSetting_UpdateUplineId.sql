
/*
Create: 20191001@Sophia
Task: Update UplineId [redmine: #118962]
DB: DBUCST.CUSTDB
*/

 

 
---5466 rows
  
WHILE (1=1)
BEGIN
	UPDATE TOP (1000) e
	SET e.UplineId = c.UplineId
	FROM Acc_GroupExtraPTSetting e WITH (ROWLOCK)
	INNER JOIN CustSuper c WITH (NOLOCK) 
		ON c.CustID = e.SuperId
	WHERE c.uplineID IS NOT NULL

	IF @@ROWCOUNT = 0 
		BREAK;
END
GO
  
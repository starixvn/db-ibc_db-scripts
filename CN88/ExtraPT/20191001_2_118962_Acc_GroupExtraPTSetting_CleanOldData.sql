
/*
Create: 20191001@Sophia
Task: Clean data ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss', 'MG-SuperLive') [redmine: #118962]
DB: DBUCST.CUSTDB
*/


---Clean data ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss', 'MG-SuperLive')

SELECT COUNT (*) FROM Acc_GroupExtraPT_Product WITH (NOLOCK) WHERE SubProduct IN ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')
SELECT COUNT (*) FROM Acc_GroupExtraPTSetting  WITH (NOLOCK) WHERE SubProduct IN ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')


--- 177 rows
DELETE FROM Acc_GroupExtraPT_Product WITH (ROWLOCK)  WHERE SubProduct IN ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss')

 
---42040 rows
WHILE (1=1)
BEGIN
	DELETE TOP (1000) FROM Acc_GroupExtraPTSetting WITH (ROWLOCK) WHERE SubProduct IN ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss') 

	IF @@ROWCOUNT = 0 
		BREAK;
END
GO
  
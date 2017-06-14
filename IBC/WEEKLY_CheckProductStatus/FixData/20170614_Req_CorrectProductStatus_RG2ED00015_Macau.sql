/*
	Created: 20170614@Helen
	Task: Correct PT Macau
	DB:DBCUST/CUSTDB
	Execution Date:
*/
USE CUSTDB
GO

DECLARE @BitOrder TINYINT

SELECT @BitOrder = bitmapOrder
FROM dbo.ProductStatusProfile WITH (NOLOCK)
WHERE Sporttype = 212 

UPDATE cs
	SET cs.bitmapHasSynced = dbo.f_GenerateProductStatus (cs.bitmapHasSynced,@BitOrder,1)
FROM custProductStatus cs WITH (ROWLOCK,UPDLOCK)
WHERE cs.CustID = 22293220	

GO
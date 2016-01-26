/*
	Created: Helen
	Date: 2016-01-20
	Task: Update LockUpd = 0 
	DB: DBCust.CustDB
*/ 

DECLARE @max_custid INT

SELECT @max_custid = xxx
--custInfo
UPDATE custInfo WITH(ROWLOCK, UPDLOCK)
   SET LockUpd = 0
 WHERE custid >= @maxcustid
	   


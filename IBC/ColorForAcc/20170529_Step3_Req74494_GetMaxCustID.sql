
/*
	Created: Winnie	
	Task:  get max logID
	DB: DBCUST/CUSTDB
	Date: 20170529
*/ 

SELECT MAX (CUSTID) FROM CUSTOMER WITH(NOLOCK)
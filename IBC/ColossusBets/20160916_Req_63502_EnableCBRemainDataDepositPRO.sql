/*
	Created: Winnie
	Date: 2016-09-05
	Task:colossus settings: enable status for remain deposit customers
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------
DECLARE @maxcustid INT
SELECT @maxcustid= xx

UPDATE custInfo WITH(ROWLOCK,UPDLOCK)	
	SET DisableColossusBet=0,HideColossusBet=0
	WHERE srecommend IN  (SELECT custid FROM Dep_CustSuper cs WITH(NOLOCK)							
							WHERE cs.site IN ('HAIFA','asiabet88','alog',
											'TCL',
											'Vwin',
											'MayFair',
											'12Bet',
											'spondemo'
											))
	AND Enabled=1 AND custid > @maxcustid
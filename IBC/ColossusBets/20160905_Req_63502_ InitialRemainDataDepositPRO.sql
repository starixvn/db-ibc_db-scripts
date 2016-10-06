/*
	Created: Winnie
	Date: 2016-09-05
	Task: Insert colossus settings for deposit customers
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------	
DECLARE @maxcustid INT
SELECT @maxcustid= xx
		
	INSERT INTO Dep_AgentCommRate 
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[CommRate])
	SELECT  custid,204,18001,0.1215 FROM custInfo a WITH(NOLOCK) 
	WHERE a.srecommend IN  (SELECT custid FROM Dep_CustSuper cs WITH(NOLOCK)							
							WHERE cs.site IN ('HAIFA','asiabet88','alog',
											'TCL',
											'Vwin',
											'MayFair',
											'12Bet',
											'spondemo'
											))
	AND  a.custid > @maxcustid AND a.roleid IN(2,3,4) AND Enabled=1

	UNION ALL
	SELECT  custid,204,18002,0.45 FROM custInfo a WITH(NOLOCK) 
	WHERE a.srecommend IN (SELECT custid FROM Dep_CustSuper cs WITH(NOLOCK)							
							WHERE cs.site IN ('HAIFA','asiabet88','alog',
											'TCL',
											'Vwin',
											'MayFair',
											'12Bet',
											'spondemo'
											))
	AND  a.custid > @maxcustid AND a.roleid IN(2,3,4) AND Enabled=1


	INSERT INTO [Dep_CustCommRate]
			   ([CustId]
			   ,[Sporttype]
			   ,[Bettype]
			   ,[sdiscount]
			   ,[adiscount]
			   ,[discount]
			   ,[playerdiscount])    
	SELECT  a.custid,204,18001,0.1215,0.1215,0.1215,0 FROM custInfo a WITH(NOLOCK) 
	 WHERE srecommend IN (SELECT custid FROM Dep_CustSuper cs WITH(NOLOCK)							
							WHERE cs.site IN ('HAIFA','asiabet88','alog',
											'TCL',
											'Vwin',
											'MayFair',
											'12Bet',
											'spondemo'
											)) AND  custid > @maxcustid AND a.roleid =1	AND Enabled=1
	UNION ALL
	SELECT  a.custid,204,18002,0.45,0.45,0.45,0 FROM custInfo a WITH(NOLOCK) 
	 WHERE srecommend IN (SELECT custid FROM Dep_CustSuper cs WITH(NOLOCK)							
							WHERE cs.site IN ('HAIFA','asiabet88','alog',
											'TCL',
											'Vwin',
											'MayFair',
											'12Bet',
											'spondemo'
											)) AND  custid > @maxcustid AND a.roleid =1	AND Enabled=1


-------------------------------------------------


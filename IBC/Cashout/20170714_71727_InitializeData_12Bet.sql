  /*
	Created: 20170714@Elodie
	Task : Initial data 12Bet for CashOut [RedmineID: #71727]
	DB: DBCust/CustDB
*/

CREATE TABLE #supers (custid INT PRIMARY KEY, isfinished bit default(0))

INSERT INTO #supers(custid)
SELECT ci.custid
FROM Customer ci WITH(NOLOCK)
	INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE ci.roleid = 4 	
	AND ci.custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
	AND c.Enabled=1	
	AND ci.site IN ('12Bet')
	AND ci.currency = 20

DECLARE @srecommend INT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_3rdProductUpdSuperStatus
			@CustID = @srecommend 
			,@ProductID = 25
			,@IsEnable = 1
			,@ApplyToMember = 1
			,@UserID = 10278938
			,@IP = '202.78.231.3'

	WAITFOR DELAY '00:00:0.280'
END


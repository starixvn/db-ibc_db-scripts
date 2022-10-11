/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20221011@Sophia
	DB: DBTXN-bodb02 -- DBTRANS only
	Task: Clear balance of BGCV licensee- do withrawal transaction [redmine: #178957]
*/

/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20221011@Sophia
	DB: DBTXN-bodb02 -- DBTRANS only
	Task: Clear balance of BGCV licensee- do withrawal transaction [redmine: #178957]
*/

CREATE TABLE #Balance (ID INT Identity(1,1), Balance MONEY, currency INT, CustID INT)

INSERT INTO #Balance (Balance, currency, CustID)
SELECT - (Winlost - actual_Stake) AS Balance , c.currency , c.CustID
from bodb02.dbo.transfer r WITH (NOLOCK) 
INNER JOIN CUSTDB.dbo.custinfo c WITH (NOLOCK) 
ON c.custID = r.CustID
WHERE r.mrecommend in (56947944, 56947977) 
and Winlostdate  = '20220930'   -- BU day
and Bettype IN (20000) 
and c.roleID = 1
    

-------
DECLARE @i INT = 1 , @Max INT 
SELECT @Max = MAX(ID) FROM #Balance

DECLARE @p5 bigint 
, @p6 int 
, @p7 nvarchar(200) 
, @p11 bigint 
, @p13 bigint 
, @p14 datetime
, @amount MONEY
, @custid INT
, @bal_custid INT

WHILE @i <= @Max 
BEGIN
	SELECT	@amount = Balance, @CustID = CustID, @bal_custid = CASE WHEN currency = 124 THEN 56947987 ELSE 56947953 END 
	FROM	#Balance
	WHERE	ID = @i


	EXEC Dot_Dep_BettransInsTransaction_V2_cust @amount = @amount, @custid = @custid, @bal_custid = @bal_custid,
	@transdesc=N'Reset balance for reopening',
	@transid=@p5 output,@ErrCode=@p6 output,@ErrMsg=@p7 output
	,@bettype=22002,@IsCharge=0,@ip=default,@RefNo=@p11 output,@ExchangeRate=default,@bal_transid=@p13 output,@transdate=@p14 output,@BetCheck=default,@BonusID=default
	
	SELECT @p5, @p6, @p7, @p11, @p13, @p14

	SELECT @i = @i + 1
END

DROP TABLE #Balance
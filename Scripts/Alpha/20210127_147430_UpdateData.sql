/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
Created: 
Task : Update data [RedmineID: #147430]
DB: DBTXN/bodb02
 
*/
DECLARE @Username VARCHAR(30) = 'twpgmyikhunchiu01',@CustId INT, @Recommend INT, @Mrecommend INT, @Srecommend INT

SELECT 
	@CustId = custid
	,@Recommend = recommend
	,@Mrecommend = mrecommend
	,@Srecommend= srecommend
FROM CustDB.dbo.Customer c WITH(NOLOCK)
WHERE c.username = @Username

UPDATE dbo.BonusTrans WITH(ROWLOCK)
SET CustID = @CustId
	,Recommend = @Recommend
	,Mrecommend = @Mrecommend
	,Srecommend = @Srecommend
WHERE BonusTransId BETWEEN 1000 AND 1002
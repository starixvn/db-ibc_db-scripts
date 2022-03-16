/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Create: 20220225@Sol
	DB : DBRPT-bodb_Report
	Task: insert data - [Redmine: #162264]
*/

USE bodb_Report;

GO  

/*
Batch 1
	- @custid = 24975966
	- @MinSumDate = 2022-01-21 00:00:00
	- @archivedate = 20220210

###
Batch 2
	- @custid = 24975967
	- @MinSumDate = 2022-01-24 00:00:00
	- @archivedate = 20220210

###
Batch 3
	- @custid = 24976000
	- @MinSumDate = 2022-02-07 00:00:00
	- @archivedate = 20220210

###
Batch 4
	- @custid = 24975035
	- @MinSumDate = 2022-01-25 00:00:00
	- @archivedate = 20220210
*/

GO

DECLARE @MinSumDate SMALLDATETIME = '20220121'
DECLARE @MinSumDateBk SMALLDATETIME = '20220121'
DECLARE @archivedate SMALLDATETIME = '20220213'
DECLARE @custid INT = 24975966	
		
CREATE table #tblMain 
(
	Winlostdate	SMALLDATETIME
	,CustID	INT
	,OpeningBalance	MONEY
	,ClosingBalance MONEY
	,actualrate	FLOAT
	,srecommend	INT
	,mrecommend	INT
	,recommend	INT
	,currency	INT
)

--------------------------------------
--loop
WHILE @MinSumDate <= @archivedate
BEGIN
			
	IF NOT EXISTS (SELECT 1 FROM bodb_Report.dbo.rptStatement r WHERE winlostdate = @MinSumDate and r.Custid = @custid)
	BEGIN
		
		INSERT INTO #tblMain
		(Winlostdate , OpeningBalance, actualrate, currency, srecommend, mrecommend, recommend, CustID, ClosingBalance)
		SELECT @MinSumDate, ClosingBalance, actualrate, currency, srecommend, mrecommend, recommend, CustID , ClosingBalance
		FROM #tblMain
		where Winlostdate = DATEADD(d, -1, @MinSumDate)

		INSERT INTO dbo.rptDepWinlost_Main
		(Winlostdate , OpeningBalance, actualrate, currency, srecommend, mrecommend, recommend, CustID)
		SELECT @MinSumDate, t.ClosingBalance, r.actualrate, r.currency, r.srecommend, r.mrecommend, r.recommend, r.CustID
		FROM dbo.rptDepWinlost_Main r
			INNER JOIN #tblMain t
				ON r.Winlostdate = t.Winlostdate
		WHERE r.Winlostdate = DATEADD(d, -1, @MinSumDate)
	END
	ELSE
	BEGIN

		INSERT INTO #tblMain
		(Winlostdate , OpeningBalance, actualrate, currency, srecommend, mrecommend, recommend, CustID, ClosingBalance)
		SELECT @MinSumDate , 
			r.openingbalance, 
			t.actualrate, t.currency, t.srecommend, t.mrecommend, t.recommend, t.CustID, r.closingbalance
		FROM bodb_Report.dbo.rptStatement r
			LEFT JOIN ( SELECT TOP 1 * FROM rptDepWinlost_Main m WHERE m.CustID = @custid) t
				on r.Custid = t.CustID 
		WHERE r.Custid = @custid 
			AND r.WinlostDate = @MinSumDate

		INSERT INTO rptDepWinlost_Main
		(Winlostdate , OpeningBalance, actualrate, currency, srecommend, mrecommend, recommend, CustID)
		SELECT @MinSumDate , 
			r.openingbalance, 
			t.actualrate, t.currency, t.srecommend, t.mrecommend, t.recommend, t.CustID
		FROM bodb_Report.dbo.rptStatement r
			LEFT JOIN ( SELECT TOP 1 * FROM rptDepWinlost_Main m WHERE m.CustID = @custid) t
				on r.Custid = t.CustID 
		WHERE r.Custid = @custid 
			AND r.WinlostDate = @MinSumDate
	END

	SELECT @MinSumDate = DATEADD(DAY,1,@MinSumDate)

END

---run archive process manually
--3.Copy data for rptDepWinlost

INSERT INTO dbo.rptDepWinlost_bk (
	winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss, 
	ClosingBalance, recommend, mrecommend, srecommend, actualrate, Transfer3rd, DrawGame, Turnover_tdate, Turnover_BA, Comm_BA, 
	AmountDueTo_BA, playercomm, Transfer3rdOthers, comm_bettrade, amountdueto_bettrade,Promotion)
SELECT winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss, 
		ClosingBalance, recommend, mrecommend, srecommend, actualrate, Transfer3rd, DrawGame, NULL, Turnover_BA, Comm_BA, 
		AmountDueTo_BA, playercomm, Transfer3rdOthers, comm_bettrade, amountdueto_bettrade,Promotion
FROM dbo.rptDepWinlost r WITH (NOLOCK)
WHERE winlostdate BETWEEN @MinSumDateBk AND @archivedate
	AND r.custid = @custid
							
--3.Copy data for rptDepWinlostByProduct
INSERT INTO dbo.rptDepWinlostByProduct_bk (
	winlostdate, custid, sporttype, currency, turnover, drawTO, winlost, playercomm, BetCount, outstanding)
SELECT winlostdate, custid, sporttype, currency, turnover, drawTO, winlost, playercomm, BetCount, outstanding
FROM dbo.rptDepWinlostByProduct r WITH (NOLOCK) 
WHERE winlostdate BETWEEN @MinSumDateBk AND @archivedate
	AND r.custid = @custid
					
--3.Copy data for rptDepWinlost_Transfer3rdOthers
INSERT INTO dbo.rptDepWinlost_Transfer3rdOthers_Bk (
		winlostdate,CustId,Currency,PartnerId,Recommend,MRecommend,SRecommend,TransferAmount,TransferIn,TransferOut)
SELECT winlostdate,CustId,Currency,PartnerId,Recommend,MRecommend,SRecommend,TransferAmount,TransferIn,TransferOut
FROM dbo.rptDepWinlost_Transfer3rdOthers r WITH (NOLOCK)
WHERE winlostdate BETWEEN @MinSumDateBk AND @archivedate
	AND r.custid = @custid

GO				
/*
	Created: 20191022@Percy
	DB: DB05x
	Task: Gen data for bodb_LicenseeReport.dbo.rpt_BettingColossusBets on 2019-01-12 and 2019-02-25
*/

select custid, recommend, refno, winlostdate, currency, ISNULL(currency2, 0) as TicketType, stake, winlost, actual_stake, status, statusID
		,bmbettype, bmWinlost, bmstake, bmoddsspread, bmacomm
into #__bettrans
from openquery(dbarc, 'select b.custid, b.recommend, b.refno, b.winlostdate, b.currency, b.currency2, b.stake, b.winlost, b.actual_stake, b.status, b.statusID
								,bm.bettype as bmbettype, bm.Winlost AS bmWinlost, bm.stake as bmstake, bm.oddsspread as bmoddsspread, bm.acomm as bmacomm
						from bodb_archive.dbo.bettrans_bk b with (nolock)
							inner join bodb_archive.dbo.bettransm bm with (nolock) on bm.refno = b.refno
						where b.winlostdate in (''2019-01-12'', ''2019-02-25'')
							and b.bettype = 18000
							and b.statusid in (111,112,113)
							and bm.bettype between 18001 and 18006')

SELECT	b.CustId
		, b.refno
		, b.winlostdate
		, b.Currency
		, b.TicketType
		, SUM(ABS(b.Stake)) TurnOver
		, COUNT(DISTINCT b.refno) TotalTrans
		, b.Winlost
		, b.Actual_Stake
		, b.STATUS
		, b.statusID
INTO #__tmpBettrans
FROM #__bettrans b
	INNER JOIN bodb_licensee.dbo.LicenseeCust t WITH (NOLOCK) ON b.recommend = t.CustID AND b.Currency = t.Currency
GROUP BY b.CustId
		, b.refno
		, b.winlostdate
		, b.Currency
		, b.TicketType
		, b.Winlost
		, b.Actual_Stake
		, b.STATUS
		, b.statusID

SELECT	winlostdate AS rptDate
		,custid
		,18000 AS bettype
		,currency AS CurrencyID
		,TicketType
		,StatusID
		, COUNT(DISTINCT refno) TotalTrans
		, 0 TurnOver
		, SUM(CASE WHEN (winlost - actual_stake ) < 0 AND statusID = 112 THEN 0
				ELSE CASE WHEN bmbettype IN (18004,18005,18006) THEN bmWinlost - bmstake ELSE 0 END
				END) AS WinningPrize
		, SUM(CASE WHEN (winlost - actual_stake ) < 0 AND statusID = 112 THEN 0
				ELSE CASE WHEN bmbettype = 18002 THEN bmwinlost - bmstake ELSE 0 END
				END) AS CashOutAmt
		, SUM(CASE WHEN bmbettype = 18002 THEN bmoddsspread ELSE 0 END) AS CashInAmt
		, SUM(CASE WHEN bmbettype = 18002 THEN bmacomm ELSE 0 END) AS CashInShare
		, SUM(CASE WHEN bmbettype = 18001 THEN bmacomm ELSE 0 END) CommAmt
		, 0 AS GrandAmt
INTO #__tmpRawData
FROM #__bettrans
GROUP BY winlostdate
		,custid
		,currency
		,TicketType
		,StatusID

;WITH cte_TO AS (
	SELECT Currency
		, TicketType
		, winlostdate
		, custid
		, StatusID
		, SUM(TurnOver) TurnOver
	FROM #__tmpBettrans
	GROUP BY Currency
		, TicketType
		, winlostdate
		, custid
		, StatusID
)
UPDATE d
SET TurnOver = s.TurnOver
FROM #__tmpRawData d
	INNER JOIN cte_TO s ON d.CurrencyID = s.Currency
				AND d.TicketType = s.TicketType
				AND d.rptDate = s.Winlostdate 
				AND d.custId = s.CustID
				AND d.StatusID = s.StatusID

INSERT INTO bodb_LicenseeReport.dbo.rpt_BettingColossusBets
(
	rptDate,
	CustID,
	Bettype,
	CurrencyID,
	TicketType,
	StatusID,
	TotalTrans,
	Turnover,
	WinningPrize,
	CashOutAmt,
	CashInAmt,
	CashInShare,
	CommAmt,
)
SELECT rptDate,
		CustID,
		Bettype,
		CurrencyID,
		TicketType,
		StatusID,
		SUM(TotalTrans),
		SUM(Turnover),
		SUM(WinningPrize),
		SUM(CashOutAmt),
		SUM(CashInAmt),
		SUM(CashInShare),
		SUM(CommAmt)
FROM #__tmpRawData			
GROUP BY rptDate,
		CustID,
		Bettype,
		CurrencyID,
		TicketType,
		StatusID

DROP TABLE #__bettrans
DROP TABLE #__tmpBettrans
DROP TABLE #__tmpRawData
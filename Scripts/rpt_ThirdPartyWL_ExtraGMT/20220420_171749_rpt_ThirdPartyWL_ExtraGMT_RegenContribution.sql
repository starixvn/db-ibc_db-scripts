/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Creator: 20220420@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: Regen data for rpt_ThirdPartyWL_ExtraGMT from 2022-04-07 to 2022-04-09
	
	Revisions: 		
		- 20220420@Percy: Initialize SP [RedmineID: #171749]
*/
-- run both DB052 & DB053
USE bodb_LicenseeReport
GO

-- Get data from bettrans
CREATE TABLE #tmpBettrans (transid BIGINT,custid INT,currency INT,statusID TINYINT,winlostdate DATE,transdate3rd DATE,stake MONEY,actual_stake MONEY,winlost MONEY,playercomm MONEY,awinlost MONEY,comm MONEY,ContributionStake3rd DECIMAL(19,8))

BEGIN
	-- bettransRnG_bk (2981 rows)
	INSERT INTO #tmpBettrans (transid, custid, currency, statusID, winlostdate, transdate3rd, stake, actual_stake, winlost, playercomm, awinlost, comm, ContributionStake3rd)
	SELECT b.transid, b.CustId, b.currency, b.statusID, b.winlostdate, b.transdate3rd, b.stake, b.actual_stake, b.winlost, b.playercomm, b.awinlost, b.comm, b.ContributionStake3rd
	FROM DBARC.bodb_Archive.dbo.bettransRnG_bk b WITH (NOLOCK)
	WHERE b.winlostdate = '2022-04-07'
		AND b.gameID = 4599
		AND b.statusID IN (111, 112, 113)

	-- bettransRnG14 (8450 rows)
	INSERT INTO #tmpBettrans (transid, custid, currency, statusID, winlostdate, transdate3rd, stake, actual_stake, winlost, playercomm, awinlost, comm, ContributionStake3rd)
	SELECT b.transid, b.CustId, b.currency, b.statusID, b.winlostdate, b.transdate3rd, b.stake, b.actual_stake, b.winlost, b.playercomm, b.awinlost, b.comm, b.ContributionStake3rd
	FROM bodb02.dbo.bettransRnG14 b WITH (NOLOCK)
	WHERE b.winlostdate BETWEEN '2022-04-08' AND '2022-04-10'
		AND b.gameID = 4599
		AND b.statusID IN (111, 112, 113)
END

-- Sum data
CREATE TABLE #rpt_ThirdPartyWL_ExtraGMT (RptDate DATE,RptDate3rd DATE,SiteId INT,BetTypeId INT,CurrencyId INT,StatusId INT,BetCount INT,Turnover MONEY,Winloss MONEY,AComm MONEY,PComm MONEY,ProgressiveContribution MONEY,ProgressivePayout MONEY,ValidBetAmount MONEY,AWinloss MONEY)

-- 35 rows
INSERT INTO #rpt_ThirdPartyWL_ExtraGMT (RptDate,RptDate3rd,SiteId,BetTypeId,CurrencyId,StatusId,BetCount,Turnover,Winloss,AComm,PComm,ProgressiveContribution,ProgressivePayout,ValidBetAmount,AWinloss)
SELECT b.winlostdate
	,b.transdate3rd
	,ISNULL(sl.SiteId, -1) AS SiteId
	,4599 AS BetTypeId
	,b.Currency
	,b.StatusId
	,COUNT(1) AS BetCount
	,SUM(ABS(b.stake)) AS Turnover
	,SUM(b.winlost - b.actual_stake) AS Winloss
	,SUM(b.comm) AS AComm
	,SUM(b.playercomm) AS PComm
	,SUM(b.ContributionStake3rd) AS ProgressiveContribution
	,SUM(ISNULL(p.WinAmount, 0)) AS ProgressivePayout
	,0 AS ValidBetAmount
	,SUM(b.awinlost) AS AWinloss
FROM #tmpBettrans b
	LEFT JOIN DBTXN.bodb02.dbo.PayoutTrans p WITH (NOLOCK) ON b.transid = p.RefNo
	LEFT JOIN bodb02.dbo.Customer c WITH (NOLOCK) ON b.custid = c.custid
	LEFT JOIN bodb02.dbo.Site s WITH (NOLOCK) ON c.site = s.site
	LEFT JOIN bodb_licensee.dbo.view_site_list sl (NOLOCK) ON s.siteid = sl.IbcSiteID
GROUP BY b.winlostdate
	,b.transdate3rd
	,ISNULL(sl.SiteId, -1)
	,b.Currency
	,b.StatusId

-- Update real data (35 rows)
-- SELECT COUNT(1) FROM dbo.rpt_ThirdPartyWL_ExtraGMT WITH (NOLOCK) WHERE RptDate BETWEEN '2022-04-07' AND '2022-04-10' AND BetTypeId = 4599 -- ORDER BY 1, 2, 3, 5
DELETE dbo.rpt_ThirdPartyWL_ExtraGMT WITH (ROWLOCK) WHERE RptDate BETWEEN '2022-04-07' AND '2022-04-10' AND BetTypeId = 4599

INSERT INTO dbo.rpt_ThirdPartyWL_ExtraGMT (RptDate,RptDate3rd,SiteId,BetTypeId,CurrencyId,StatusId,BetCount,Turnover,Winloss,AComm,PComm,ProgressiveContribution,ProgressivePayout,ValidBetAmount,AWinloss)
SELECT RptDate,RptDate3rd,SiteId,BetTypeId,CurrencyId,StatusId,BetCount,Turnover,Winloss,AComm,PComm,ProgressiveContribution,ProgressivePayout,ValidBetAmount,AWinloss
FROM #rpt_ThirdPartyWL_ExtraGMT

DROP TABLE #rpt_ThirdPartyWL_ExtraGMT
DROP TABLE #tmpBettrans
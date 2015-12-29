USE bodb_Account
GO

SET NOCOUNT ON

DECLARE @datestart DATETIME
	,@dateend DATETIME

SELECT *
INTO #tmpBettrans
FROM DBACC.bodb02.dbo.bettrans14 b WITH (NOLOCK)
WHERE b.winlostdate >= @datestart
	AND b.winlostdate < @dateend
	AND b.bettype BETWEEN 81 AND 120

SELECT b.winlostdate rptDate
	,b.custid
	,b.[recommend]
	,b.[mrecommend]
	,b.[srecommend]
	,CASE WHEN b.[recommend] = 52466 THEN - 2 WHEN b.[recommend] = 5707545 THEN - 4 WHEN cat.CategoryID = 30 THEN - 3 ELSE isnull(site.siteid, - 1) END siteid
	,b.[currency]
	,b.liveindicator isLive
	,b.bettype
	,isnull(match.leagueid, - 1) leagueid
	,isnull(b.matchid, 0) matchid
	,isnull(st.statusid, 0) [status]
	,--Stake
	sum(abs(b.actual_stake)) actual_stake
	,sum(abs(stake)) Stake
	,sum(CASE WHEN b.betteam = 'h' THEN b.stake ELSE 0 END) StakeH
	,sum(CASE WHEN b.betteam = 'a' THEN b.stake ELSE 0 END) StakeA
	,--Winloss	
	sum(b.awinlost + b.mwinlost + b.swinlost + b.scomm + b.winlost - b.actual_stake) WinlossIBC
	,sum(b.swinlost) WinlossS
	,sum(b.mwinlost) WinlossM
	,sum(b.awinlost) WinlossA
	,sum(b.winlost - b.actual_stake) WinlossP
	,sum((b.awinlost + b.mwinlost + b.swinlost + b.scomm + b.winlost - b.actual_stake) * b.virtualrate) WinlossIBCVirtual
	,sum((((b.winlost - b.actual_stake)) * b.virtualrate)) WinlossPVirtual
	,--Turnover
	sum(CASE WHEN b.winlostdate > '2011-8-31' THEN abs(b.stake) ELSE b.stake END * (1 - b.tpositiontaking)) TurnoverIBC
	,sum(b.stake * b.spositiontaking) TurnoverS
	,sum(b.stake * b.mpositiontaking) TurnoverM
	,sum(b.stake * b.apositiontaking) TurnoverA
	,sum(CASE WHEN b.winlostdate > '2011-8-31' THEN abs(b.stake) ELSE b.stake END * b.virtualrate * (1 - b.tpositiontaking)) TurnoverIBCVirtual
	,--Commission
	sum(b.scomm) CommissionS
	,--total comm
	sum(b.acomm) CommissionM
	,sum(b.comm) CommissionA
	,sum(b.playercomm) CommissionP
	,sum(b.scomm * b.virtualrate) CommissionSVirtual
	,--BetCount
	count(1) BetCount
	,sum(CASE WHEN b.betteam = 'h' THEN 1 ELSE 0 END) BetCountH
	,sum(CASE WHEN b.betteam = 'a' THEN 1 ELSE 0 END) BetCountA
INTO #tmpmcCustNumGameDaily
FROM #tmpBettrans b WITH (NOLOCK)
	LEFT JOIN bodb_Account.dbo.tbl_Status st WITH (NOLOCK) ON b.STATUS = st.STATUS
	LEFT JOIN bodb_Staging.dbo.match match WITH (NOLOCK) ON b.matchid = match.matchid
	LEFT JOIN bodb_Account.dbo.customer ag WITH (NOLOCK) ON b.recommend = ag.custid
	AND ag.roleid = 2
	LEFT JOIN bodb_Account.dbo.tbl_site site WITH (NOLOCK) ON ag.site = site.site
	LEFT JOIN bodb_Account.dbo.view_Customer_Exclusion cat WITH (NOLOCK) ON (
		b.custid = cat.custid
		AND cat.roleid = 1
		)
	OR (
		b.mrecommend = cat.custid
		AND cat.roleid = 3
		)
	OR (
		b.recommend = cat.custid
		AND cat.roleid = 2
		)
GROUP BY b.winlostdate
	,b.custid
	,b.[recommend]
	,b.[mrecommend]
	,b.[srecommend]
	,CASE WHEN b.[recommend] = 52466 THEN - 2 WHEN b.[recommend] = 5707545 THEN - 4 WHEN cat.CategoryID = 30 THEN - 3 ELSE isnull(site.siteid, - 1) END
	,b.[currency]
	,b.liveindicator
	,b.bettype
	,isnull(match.leagueid, - 1)
	,isnull(b.matchid, 0)
	,isnull(st.statusid, 0)

DROP TABLE #tmpBettrans

DELETE [dbo].[mcCustNumGameDaily_tmp]
WHERE [rptDate] >= @datestart
	AND [rptDate] < @dateend

INSERT INTO [dbo].[mcCustNumGameDaily_tmp] (
	[rptDate]
	,[CustID]
	,[recommend]
	,[mrecommend]
	,[srecommend]
	,[SiteID]
	,[currency]
	,[isLive]
	,[bettype]
	,[leagueid]
	,[matchid]
	,[status]
	,[Actual_Stake]
	,[Stake]
	,[StakeH]
	,[StakeA]
	,[WinlossIBC]
	,[WinlossS]
	,[WinlossM]
	,[WinlossA]
	,[WinlossP]
	,[WinlossIBCVirtual]
	,[WinlossPVirtual]
	,[TurnoverIBC]
	,[TurnoverS]
	,[TurnoverM]
	,[TurnoverA]
	,[TurnoverIBCVirtual]
	,[CommissionS]
	,[CommissionM]
	,[CommissionA]
	,[CommissionP]
	,[CommissionSVirtual]
	,[BetCount]
	,[BetCountH]
	,[BetCountA]
	)
SELECT [rptDate]
	,[CustID]
	,[recommend]
	,[mrecommend]
	,[srecommend]
	,[SiteID]
	,[currency]
	,[isLive]
	,[bettype]
	,[leagueid]
	,[matchid]
	,[status]
	,[Actual_Stake]
	,[Stake]
	,[StakeH]
	,[StakeA]
	,[WinlossIBC]
	,[WinlossS]
	,[WinlossM]
	,[WinlossA]
	,[WinlossP]
	,[WinlossIBCVirtual]
	,[WinlossPVirtual]
	,[TurnoverIBC]
	,[TurnoverS]
	,[TurnoverM]
	,[TurnoverA]
	,[TurnoverIBCVirtual]
	,[CommissionS]
	,[CommissionM]
	,[CommissionA]
	,[CommissionP]
	,[CommissionSVirtual]
	,[BetCount]
	,[BetCountH]
	,[BetCountA]
FROM #tmpmcCustNumGameDaily

DROP TABLE #tmpmcCustNumGameDaily

USE [bodb02]
GO

/*
	Created: 20180914@Percy
	DB: DBTXN.bodb02
	Task: Regen data sum_winloss - Step 2: Gen data into temp table
*/

CREATE TABLE #tmp_bettrans
(
	winlostdate SMALLDATETIME, custid INT, recommend INT, mrecommend INT, srecommend INT,
	stake MONEY, winlost MONEY, actual_stake MONEY,
	awinlost MONEY, mwinlost MONEY,	swinlost MONEY,
	playercomm MONEY, comm MONEY, acomm MONEY, scomm MONEY,
	apositiontaking MONEY, mpositiontaking MONEY, spositiontaking MONEY
)

DECLARE @n INT = 1000000
DECLARE @transid TABLE (winlostdate SMALLDATETIME, custid INT)
INSERT INTO @transid (winlostdate, custid)
SELECT DISTINCT winlostdate, custid FROM dbo.bettrans14 WITH (NOLOCK) WHERE matchid = 163 -- index matchid

INSERT INTO #tmp_bettrans
(
	winlostdate, custid, recommend, mrecommend, srecommend,
	stake, winlost, actual_stake, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm,
	apositiontaking, mpositiontaking, spositiontaking
)
SELECT
	t.winlostdate, t.custid, recommend, mrecommend, srecommend,
	stake, winlost, actual_stake, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm,
	apositiontaking, mpositiontaking, spositiontaking
FROM @transid t
	CROSS APPLY (
		SELECT TOP (@n)
			winlostdate, custid, recommend, mrecommend, srecommend,
			stake, winlost, actual_stake, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm,
			apositiontaking, mpositiontaking, spositiontaking
		FROM dbo.bettrans14 b WITH (NOLOCK)
		WHERE t.winlostdate = b.winlostdate
			AND t.custid = b.custid
			AND b.matchid = 163
			AND b.bettype BETWEEN 1401 AND 1499
			AND b.statusID NOT IN (0,1,102,101,103)
	) AS bt
	OPTION (OPTIMIZE FOR (@n=1))

-- Member
INSERT INTO dbo.sum_winloss_GrossComm
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
	turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, betcount, grosscomm,
	sporttype, bettype, netTurnover, TunroverNoDraw
)
SELECT
	winlostdate, 1 AS roleid, c.custid, c.recommend, c.mrecommend, c.srecommend, c.username,
	SUM(ABS(stake)) AS turnover, SUM(winlost-actual_stake) AS winlost, SUM(awinlost) AS awinlost, SUM(mwinlost) AS mwinlost, SUM(swinlost) AS swinlost,
	SUM(playercomm) AS playercomm, SUM(comm) AS comm, SUM(acomm) AS acomm, SUM(scomm) AS scomm, COUNT(1), SUM(comm) AS grosscomm,
	163 AS sporttype, 0 AS bettype, 0 AS netTurnover, SUM(ABS(stake)) TunroverNoDraw
FROM #tmp_bettrans b
	INNER JOIN CustDB.dbo.Customer c WITH (NOLOCK) ON b.custid = c.custid
WHERE c.roleId = 1
GROUP BY
	winlostdate, c.custid, c.recommend, c.mrecommend, c.srecommend, c.username

-- Agent
INSERT INTO dbo.sum_winloss_GrossComm
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
	turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, betcount, grosscomm,
	sporttype, bettype, netTurnover, TunroverNoDraw
)
SELECT
	winlostdate, 2 AS roleid, c.custid, c.recommend, c.mrecommend, c.srecommend, c.username,
	SUM(ABS(stake)) AS turnover, SUM(winlost-actual_stake) AS winlost, SUM(awinlost) AS awinlost, SUM(mwinlost) AS mwinlost, SUM(swinlost) AS swinlost,
	SUM(playercomm) AS playercomm, SUM(comm) AS comm, SUM(acomm) AS acomm, SUM(scomm) AS scomm, COUNT(1), SUM(acomm) AS grosscomm,
	163 AS sporttype, 0 AS bettype, SUM(ABS(stake*apositiontaking)) AS netTurnover, SUM(ABS(stake)) TunroverNoDraw
FROM #tmp_bettrans b
	INNER JOIN CustDB.dbo.Customer c WITH (NOLOCK) ON b.recommend = c.custid
WHERE c.roleId = 2
GROUP BY
	winlostdate, c.custid, c.recommend, c.mrecommend, c.srecommend, c.username

-- Master
INSERT INTO dbo.sum_winloss_GrossComm
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
	turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, betcount, grosscomm,
	sporttype, bettype, netTurnover, TunroverNoDraw
)
SELECT
	winlostdate, 3 AS roleid, c.custid, 0 AS recommend, c.mrecommend, c.srecommend, c.username,
	SUM(ABS(stake)) AS turnover, SUM(winlost-actual_stake) AS winlost, SUM(awinlost) AS awinlost, SUM(mwinlost) AS mwinlost, SUM(swinlost) AS swinlost,
	SUM(playercomm) AS playercomm, SUM(comm) AS comm, SUM(acomm) AS acomm, SUM(scomm) AS scomm, COUNT(1), SUM(scomm) AS grosscomm,
	163 AS sporttype, 0 AS bettype, SUM(ABS(stake*mpositiontaking)) AS netTurnover, SUM(ABS(stake)) TunroverNoDraw
FROM #tmp_bettrans b
	INNER JOIN CustDB.dbo.Customer c WITH (NOLOCK) ON b.mrecommend = c.custid
WHERE c.roleId = 3
GROUP BY
	winlostdate, c.custid, c.mrecommend, c.srecommend, c.username

-- Super
INSERT INTO dbo.sum_winloss_GrossComm
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
	turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, betcount, grosscomm,
	sporttype, bettype, netTurnover, TunroverNoDraw
)
SELECT
	winlostdate, 4 AS roleid, c.custid, 0 AS recommend, 0 AS mrecommend, c.srecommend, c.username,
	SUM(ABS(stake)) AS turnover, SUM(winlost-actual_stake) AS winlost, SUM(awinlost) AS awinlost, SUM(mwinlost) AS mwinlost, SUM(swinlost) AS swinlost,
	SUM(playercomm) AS playercomm, SUM(comm) AS comm, SUM(acomm) AS acomm, SUM(scomm) AS scomm, COUNT(1), SUM(scomm) AS grosscomm,
	163 AS sporttype, 0 AS bettype, SUM(ABS(stake*spositiontaking)) AS netTurnover, SUM(ABS(stake)) TunroverNoDraw
FROM #tmp_bettrans b
	INNER JOIN CustDB.dbo.Customer c WITH (NOLOCK) ON b.srecommend = c.custid
WHERE c.roleId = 4
GROUP BY
	winlostdate, c.custid, c.srecommend, c.username

DROP TABLE #tmp_bettrans

--TRUNCATE TABLE dbo.sum_winloss_GrossComm
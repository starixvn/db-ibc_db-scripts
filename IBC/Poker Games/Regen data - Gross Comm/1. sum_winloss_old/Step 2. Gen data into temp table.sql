USE [bodb_Archive]
GO

/*
	Created: 20180914@Percy
	DB: DBARC.bodb_Archive
	Task: Regen data sum_winloss_old - Step 2: Gen data into temp table
*/

CREATE TABLE #tmp_bettrans_bk
(
	winlostdate SMALLDATETIME, custid INT, recommend INT, mrecommend INT, srecommend INT,
	stake MONEY, winlost MONEY, actual_stake MONEY,
	awinlost MONEY, mwinlost MONEY,	swinlost MONEY,
	playercomm MONEY, comm MONEY, acomm MONEY, scomm MONEY,
	apositiontaking MONEY, mpositiontaking MONEY, spositiontaking MONEY
)

INSERT INTO #tmp_bettrans_bk
(
	winlostdate, custid, recommend, mrecommend, srecommend,
	stake, winlost, actual_stake, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm,
	apositiontaking, mpositiontaking, spositiontaking
)
SELECT
	winlostdate, custid, recommend, mrecommend, srecommend,
	stake, winlost, actual_stake, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm,
	apositiontaking, mpositiontaking, spositiontaking
FROM dbo.bettrans_bk b WITH (NOLOCK)
WHERE winlostdate >= '2018-09-02'
	AND bettype BETWEEN 1401 AND 1499
	AND statusID NOT IN (0,1,102,101,103)

-- Member
INSERT INTO dbo.sum_winloss_old_GrossComm
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
FROM #tmp_bettrans_bk b
	INNER JOIN bodb02.dbo.Customer c WITH (NOLOCK) ON b.custid = c.custid
WHERE c.roleId = 1
GROUP BY
	winlostdate, c.custid, c.recommend, c.mrecommend, c.srecommend, c.username

-- Agent
INSERT INTO dbo.sum_winloss_old_GrossComm
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
FROM #tmp_bettrans_bk b
	INNER JOIN bodb02.dbo.Customer c WITH (NOLOCK) ON b.recommend = c.custid
WHERE c.roleId = 2
GROUP BY
	winlostdate, c.custid, c.recommend, c.mrecommend, c.srecommend, c.username

-- Master
INSERT INTO dbo.sum_winloss_old_GrossComm
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
FROM #tmp_bettrans_bk b
	INNER JOIN bodb02.dbo.Customer c WITH (NOLOCK) ON b.mrecommend = c.custid
WHERE c.roleId = 3
GROUP BY
	winlostdate, c.custid, c.mrecommend, c.srecommend, c.username

-- Super
INSERT INTO dbo.sum_winloss_old_GrossComm
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
FROM #tmp_bettrans_bk b
	INNER JOIN bodb02.dbo.Customer c WITH (NOLOCK) ON b.srecommend = c.custid
WHERE c.roleId = 4
GROUP BY
	winlostdate, c.custid, c.srecommend, c.username

DROP TABLE #tmp_bettrans_bk
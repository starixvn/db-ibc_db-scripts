USE [bodb02]
GO

/*
	Created: 20180914@Percy
	DB: DBTXN.bodb02
	Task: Regen data sum_winloss - Step 3: Regen data into real table
*/

DELETE dbo.sum_winloss WITH (ROWLOCK, UPDLOCK)
WHERE sporttype = 163 AND bettype = 0

INSERT INTO dbo.sum_winloss
(
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
	turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, betcount, grosscomm,
	sporttype, bettype, netTurnover, TunroverNoDraw
)
SELECT
	winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
	turnover, winlost, awinlost, mwinlost, swinlost,
	playercomm, comm, acomm, scomm, betcount, grosscomm,
	sporttype, bettype, netTurnover, TunroverNoDraw
FROM dbo.sum_winloss_GrossComm
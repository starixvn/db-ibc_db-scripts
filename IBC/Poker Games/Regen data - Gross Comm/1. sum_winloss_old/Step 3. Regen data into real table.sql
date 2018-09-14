USE [bodb_Summary]
GO

/*
	Created: 20180914@Percy
	DB: DBSUM.bodb_Summary
	Task: Regen data sum_winloss_old - Step 3: Regen data into real table
*/

DELETE dbo.sum_winloss_old WITH (ROWLOCK, UPDLOCK)
WHERE winlostdate >= '2018-09-04' AND sporttype = 163 AND bettype = 0

INSERT INTO dbo.sum_winloss_old
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
FROM DBARC.bodb_Archive.dbo.sum_winloss_old_GrossComm
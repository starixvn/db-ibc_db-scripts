/*
	Created: 20190307@Helen
	Task: Missing data in bettransm14 on winlostdate 2019-03-03
	DB: DB054/bodb02
*/
USE bodb02
GO

SELECT *
INTO #tmp_MissingData
FROM OPENQUERY (DB06, 'SELECT transid, custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, winlost, livehomescore, liveawayscore, liveindicator, betteam, creator, refno, comstatus, winlostdate, betfrom, betcheck, checktime, oddsspread, apositiontaking, mpositiontaking, tpositiontaking, awinlost, mwinlost, playerdiscount, discount, adiscount, playercomm, comm, acomm, actualrate, matchid, matchdate, finalodds, isfinish, statuswinlost, ruben, bettype, spositiontaking, swinlost, sdiscount, scomm, statusID, recommdate, transdesc, SecAcceptFlag
						FROM bodb02.dbo.bettransm14 WITH (NOLOCK) WHERE winlostdate = ''2019-03-03''')

INSERT INTO bettransm14 (transid, custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, winlost, livehomescore, liveawayscore, liveindicator, betteam, creator, refno, comstatus, winlostdate, betfrom, betcheck, checktime, oddsspread, apositiontaking, mpositiontaking, tpositiontaking, awinlost, mwinlost, playerdiscount, discount, adiscount, playercomm, comm, acomm, actualrate, matchid, matchdate, finalodds, isfinish, statuswinlost, ruben, bettype, spositiontaking, swinlost, sdiscount, scomm, statusID, recommdate, transdesc, SecAcceptFlag)
SELECT transid, custid, transdate, oddsid, hdp1, hdp2, odds, stake, status, winlost, livehomescore, liveawayscore, liveindicator, betteam, creator, refno, comstatus, winlostdate, betfrom, betcheck, checktime, oddsspread, apositiontaking, mpositiontaking, tpositiontaking, awinlost, mwinlost, playerdiscount, discount, adiscount, playercomm, comm, acomm, actualrate, matchid, matchdate, finalodds, isfinish, statuswinlost, ruben, bettype, spositiontaking, swinlost, sdiscount, scomm, statusID, recommdate, transdesc, SecAcceptFlag
FROM #tmp_MissingData

DROP TABLE #tmp_MissingData


USE [bodb_Archive]
GO

ALTER PROCEDURE [dbo].[DBA_CopyData_14_bk]
	@winlostdate	SMALLDATETIME,
	@srecommend		INT,
	@bettype		INT,
	@sporttype		INT
AS

/*
	Created by Percy
	Date: 2017-06-28
	DB: DBACC.bodb_Archive
	Task: Creating testing data of Betradar Virtual Sports

	Revisions:
		- 20170628@Percy: Create new

	Param's Explanation:
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @match TABLE (matchid INT)
	INSERT INTO @match (matchid)
	SELECT matchid
	FROM DBTXN.bodb02.dbo.match14 m WITH(NOLOCK)
	WHERE eventdate = @winlostdate AND sporttype = @sporttype

	DELETE dbo.match_bk WITH(ROWLOCK, UPDLOCK) WHERE matchid IN (SELECT matchid FROM @match)

	INSERT INTO dbo.match_bk
	(
		[matchid], [leagueid], [homeid], [awayid],
		[eventdate], [eventstatus],
		[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
		[creator], [matchcode], [kickofftime], [closedtime], [showtime],
		[hthomescore], [htawayscore], [ruben], [multiple],
		[sporttype], [IsNeutral], [GlobalShowTime], [ParentID]
	)
	SELECT
		[matchid], [leagueid], [homeid], [awayid],
		[eventdate], [eventstatus],
		[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
		[creator], [matchcode], [kickofftime], [closedtime], [showtime],
		[hthomescore], [htawayscore], [ruben], [multiple],
		[sporttype], [IsNeutral], [GlobalShowTime], [ParentID]
	FROM DBTXN.bodb02.dbo.match14 m WITH(NOLOCK)
	WHERE eventdate = @winlostdate AND sporttype = @sporttype

	DECLARE @bettrans TABLE (transid BIGINT)
	INSERT INTO @bettrans (transid)
	SELECT transid
	FROM DBTXN.bodb02.dbo.bettrans14 bt WITH(NOLOCK)
	WHERE srecommend = @srecommend AND bettype = @bettype AND winlostdate = @winlostdate

	DELETE dbo.bettrans_bk WITH(ROWLOCK, UPDLOCK) WHERE transid IN (SELECT transid FROM @bettrans)

	DELETE dbo.bettrans_bk WITH(ROWLOCK, UPDLOCK) WHERE srecommend = @srecommend AND bettype = @bettype AND winlostdate = @winlostdate

	INSERT INTO dbo.bettrans_bk
	(
		transid, matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
		winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
		apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
		sdiscount, adiscount, discount, playerdiscount,
		livehomescore, liveawayscore, betteam, creator, refno,
		winlostdate, betfrom, checktime, oddsspread, oddstype,
		currency, actualrate, virtualrate,
		srecommend, mrecommend, recommend, custid,
		ip, bettype, transdesc
	)
	SELECT
		transid, matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
		winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
		apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
		sdiscount, adiscount, discount, playerdiscount,
		livehomescore, liveawayscore, betteam, creator, refno,
		winlostdate, betfrom, checktime, oddsspread, oddstype,
		currency, actualrate, virtualrate,
		srecommend, mrecommend, recommend, custid,
		ip, bettype, transdesc
	FROM DBTXN.bodb02.dbo.bettrans14 bt WITH(NOLOCK)
	WHERE srecommend = @srecommend AND bettype = @bettype AND winlostdate = @winlostdate

	IF @sporttype = 160 -- Lucky 3
	BEGIN
		DELETE dbo.bingoBall_bk WITH (ROWLOCK, UPDLOCK) WHERE Matchid IN (SELECT matchid FROM @match)

		INSERT INTO dbo.bingoBall_bk (Matchid, Seq, Number)
		SELECT Matchid, seq, number
		FROM DBTXN.bodb02.dbo.bingoBall14 WITH (NOLOCK)
		WHERE Matchid IN (SELECT matchid FROM @match)
		
		INSERT INTO dbo.BetLucky3Result_bk
		(
			MatchId,TransId,CustId,Bettype,Currency,Hdp1,Odds,StatusId,Hits,Prize,PrizeAmount,Winlost,aWinlost,mWinlost,sWinlost,
			PlayerComm,Comm,aComm,sComm,aPositionTaking,mPositionTaking,sPositionTaking,PlayerDiscount,Discount,aDiscount,sDiscount,TransDesc
		)
		SELECT
			MatchId,TransId,CustId,Bettype,Currency,Hdp1,Odds,StatusId,Hits,Prize,PrizeAmount,Winlost,aWinlost,mWinlost,sWinlost,
			PlayerComm,Comm,aComm,sComm,aPositionTaking,mPositionTaking,sPositionTaking,PlayerDiscount,Discount,aDiscount,sDiscount,TransDesc
		FROM DBTXN.bodb02.dbo.BetLucky3Result14 WITH (NOLOCK)
		WHERE matchid IN (SELECT matchid FROM @match)
	END
END
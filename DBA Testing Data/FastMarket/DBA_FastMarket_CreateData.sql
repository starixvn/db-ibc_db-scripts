USE [bodb02]
GO

ALTER PROCEDURE dbo.DBA_FastMarket_CreateData
	@CustId				INT,
	-- ticket
	@bettype			INT,
	@Winlostdate		SMALLDATETIME = NULL,
	@stake				MONEY = 100,
	@hdp1				SMALLMONEY = NULL,
	@hdp2				SMALLMONEY = NULL,
	@betteam			NVARCHAR(20) = NULL,
	@oddsspread			MONEY = NULL,
	@isLive				BIT = 0,
	-- match info
	@leagueId			INT = 0, -- 0: random, 1: create new, <> 0, 1: input exist league
	@matchId			INT = 0, -- 0: random, 1: create new, <> 0, 1: input exist match
	@matchStatus		VARCHAR(20) = 'running', -- 'running, Completed'
	-- for settled match (Completed)
	@ListEventCounter	VARCHAR(MAX) = '0-4-2,1-0-1,5-2-2,5-5-1' -- see EventCounter Matrix

	/*
		EventCounter Matrix	

		Event Counter		|0:None	|1:Goal	|2:Corner	|3:Free Kick|4:Goal Kick|5:Throw In	|6:Booking	|7:Penalty	|
		
		0: 00:00 --> 00:59	|0		|1		|0			|0			|2			|0			|0			|	0		|	0-1-1,0-4-2
		1: 01:00 --> 01:59	|1		|0		|0			|0			|0			|0			|0			|	0		|	1-0-1
		.......
		5: 05:00 --> 05:59	|0		|0		|2			|0			|0			|1			|0			|	0		|	5-2-2,5-5-1
	*/
AS

/*
	Created by Percy
	Date: 2018-03-15
	Task: Create testing data of Fast Market
	DB: DB206

	Params:
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @BetOption TABLE (bettype INT, hdp2 SMALLMONEY, betteam NVARCHAR(20))

	INSERT INTO @BetOption (bettype, hdp2, betteam)
	VALUES
		-- 221
		(221, 2, '2'),(221, 4, '4'),(221, 8, '8'),(221, 16, '16'),(221, 32, '32'),
		(221, 2, '0'),(221, 4, '0'),(221, 8, '0'),(221, 16, '0'),(221, 32, '0'),
		-- 222
		(222, 2, '2'),(222, 4, '4'),(222, 8, '8'),(222, 16, '16'),(222, 32, '32'),(222, 128, '128'),
		(222, 2, '0'),(222, 4, '0'),(222, 8, '0'),(222, 16, '0'),(222, 32, '0'),(222, 128, '0'),
		-- 223
		(223, 1, '1'),(223, 2, '2'),(223, 4, '4'),(223, 8, '8'),(223, 16, '16'),(223, 32, '32'),
		-- 224
		(224, 1, '1'),(224, 2, '2'),(224, 4, '4'),(224, 64, '64'),(224, 128, '128'),
		-- 225
		(225, 1, '1'),(225, 44, '44'),
		-- 226
		(226, 26, '26'),(226, 36, '36'),(226, 1, '1'),
		-- 227
		(227, 194, '194'),(227, 4, '4'),(227, 1, '1')

	------------
	DECLARE @recommend INT, @mrecommend INT, @srecommend INT, @currency INT, @actualrate FLOAT, @username VARCHAR(50)
	
	SELECT
		@custid = custid, @currency = currency, @username = username,
		@recommend = recommend, @mrecommend = mrecommend, @srecommend = srecommend
	FROM CustDB.dbo.custInfo WITH(NOLOCK)
	WHERE roleid = 1 AND custid = @custid

	IF @recommend IS NULL
	BEGIN
		SELECT 'Invalid @CustId! Create ticket failed!'
		RETURN
	END

	SELECT @actualrate = actualrate FROM dbo.exchange WITH(NOLOCK) WHERE exchangeid = @currency

	IF @bettype NOT BETWEEN 221 AND 227
	BEGIN
		SELECT '@bettype should be 221 --> 227! Create ticket failed!'
		RETURN
	END

	IF @winlostdate IS NULL
		SELECT @winlostdate = CONVERT(DATE, GETDATE())

	DECLARE @datetime DATETIME
	SELECT  @datetime = CONVERT(VARCHAR(10), @winlostdate, 120) + ' ' + CONVERT(VARCHAR(10), GETDATE(), 108)

	IF @oddsspread = NULL
		SELECT @oddsspread = 0.5

	IF @hdp1 IS NULL
		SELECT @hdp1 = 0

	IF @bettype IN (221, 223, 225, 226)
	BEGIN
		IF @hdp1 NOT BETWEEN 0 AND 89
		BEGIN
			SELECT '@hdp1 is not suitable with @bettype! Create ticket failed!'
			RETURN
		END
	END
	ELSE IF @bettype IN (222, 224, 227)
	BEGIN
		IF @hdp1 NOT BETWEEN 0 AND 85
		BEGIN
			SELECT '@hdp1 is not suitable with @bettype! Create ticket failed!'
			RETURN
		END
	END

	IF @hdp2 IS NOT NULL AND @betteam IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM @BetOption WHERE bettype = @bettype AND hdp2 = @hdp2 AND betteam = @betteam)
		BEGIN
			SELECT '@hdp2/@betteam is not suitable with @bettype! Create ticket failed!'
			RETURN
		END
	END
	ELSE IF @hdp2 IS NULL AND @betteam IS NOT NULL
	BEGIN
		SELECT TOP 1 @hdp2 = hdp2 FROM @BetOption WHERE bettype = @bettype AND betteam = @betteam

		IF @hdp2 IS NULL
		BEGIN
			SELECT '@betteam is not suitable with @bettype! Create ticket failed!'
			RETURN
		END
	END
	ELSE IF @hdp2 IS NOT NULL AND @betteam IS NULL
	BEGIN
		SELECT TOP 1 @betteam = betteam FROM @BetOption WHERE bettype = @bettype AND hdp2 = @hdp2

		IF @betteam IS NULL
		BEGIN
			SELECT '@hdp2 is not suitable with @bettype! Create ticket failed!'
			RETURN
		END
	END
	ELSE
	BEGIN
		SELECT TOP 1 @betteam = betteam, @hdp2 = hdp2 FROM @BetOption WHERE bettype = @bettype
	END

	IF @matchStatus NOT IN ('running', 'Completed')
	BEGIN
		SELECT 'Invalid @matchStatus! Create ticket failed!'
		RETURN
	END

	DECLARE @MBDay SMALLDATETIME, @BUDay SMALLDATETIME

	SELECT @MBDay = MAX(eventdate) FROM dbo.match14 WITH (NOLOCK)
	SELECT TOP 1 @BUDay = winlostdate FROM dbo.bettrans WITH (NOLOCK) WHERE bettype = 20000 AND matchid = 0 AND custid = 3

	IF @leagueId NOT IN (0,1)
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM dbo.League WITH (NOLOCK) WHERE sporttype = 1 AND leagueid = @leagueId)
		BEGIN
			SELECT 'Invalid @leagueId! Create ticket failed!'
			RETURN
		END

		IF @matchId NOT IN (0,1)
		BEGIN
			SELECT @winlostdate = NULL
			
			SELECT @winlostdate = eventdate FROM dbo.match WITH (NOLOCK)
			WHERE sporttype = 1 AND leagueid = @leagueId AND matchid = @matchid

			IF @winlostdate IS NULL
				SELECT @winlostdate = eventdate FROM dbo.match14 WITH (NOLOCK)
				WHERE sporttype = 1 AND leagueid = @leagueId AND matchid = @matchid

			IF @winlostdate IS NULL
				SELECT @winlostdate = eventdate FROM DBARC.bodb_Archive.dbo.match_bk WITH (NOLOCK)
				WHERE sporttype = 1 AND leagueid = @leagueId AND matchid = @matchid

			IF @winlostdate IS NULL
			BEGIN
				SELECT 'Invalid @matchId! Create ticket failed!'
				RETURN
			END
		END
	END
	ELSE IF @matchId NOT IN (0,1)
	BEGIN
		SELECT @winlostdate = NULL
			
		SELECT @winlostdate = eventdate FROM dbo.match WITH (NOLOCK)
		WHERE sporttype = 1 AND matchid = @matchid

		IF @winlostdate IS NULL
			SELECT @winlostdate = eventdate FROM dbo.match14 WITH (NOLOCK)
			WHERE sporttype = 1 AND matchid = @matchid

		IF @winlostdate IS NULL
			SELECT @winlostdate = eventdate FROM DBARC.bodb_Archive.dbo.match_bk WITH (NOLOCK)
			WHERE sporttype = 1 AND matchid = @matchid

		IF @winlostdate IS NULL
		BEGIN
			SELECT 'Invalid @matchId! Create ticket failed!'
			RETURN
		END
	END
	ELSE
	BEGIN
		IF @matchStatus = 'running' AND @winlostdate <= @MBDay
		BEGIN
			SELECT '@matchStatus is not suitable with @winlostdate! Create ticket failed!'
			RETURN
		END

		IF @LeagueId = 0
		BEGIN
			SELECT @LeagueId = NULL

			SELECT TOP 1 @leagueId = leagueid FROM dbo.League WITH (NOLOCK) WHERE sporttype = 1
		END

		IF @leagueId IS NULL OR @LeagueId = 1
		BEGIN
			INSERT INTO dbo.League (leaguename, creator, sporttype, createdate, DisplayMode, isTest, isActive)
			VALUES ('Fast Market testing ' + CONVERT(VARCHAR(30), @datetime, 120), 1, 1, @datetime, 0, 1, 1)

			SELECT @leagueId = SCOPE_IDENTITY()
		END

		IF @matchid = 0
		BEGIN
			SELECT @matchid = NULL

			IF @winlostdate > @MBDay
				SELECT TOP 1 @matchId = matchId FROM dbo.match WITH (NOLOCK) WHERE eventdate = @winlostdate AND sporttype = 1 AND leagueid = @leagueId
			ELSE IF @winlostdate >= @BUDay
				SELECT TOP 1 @matchId = matchId FROM dbo.match14 WITH (NOLOCK) WHERE eventdate = @winlostdate AND sporttype = 1 AND leagueid = @leagueId
			ELSE
				SELECT TOP 1 @matchId = matchId FROM DBARC.bodb_Archive.dbo.match_bk WITH (NOLOCK) WHERE eventdate = @winlostdate AND sporttype = 1 AND leagueid = @leagueId
		END

		IF @matchId IS NULL OR @matchid = 1
		BEGIN
			INSERT INTO dbo.match
			(
				[leagueid], [homeid], [awayid],[eventdate], [eventstatus],
				[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
				[creator], [matchcode], [kickofftime], [closedtime], [showtime],
				[hthomescore], [htawayscore], [ruben], [multiple],
				[sporttype], [IsNeutral], [GlobalShowTime], [changetime], [settletime], [ParentID]
			)
			SELECT TOP 1
				@leagueId, homeid, awayid, @winlostdate, @matchstatus,
				0, 0, 2, 0,
				1, '{3} 23, {4} 6666', @datetime, @datetime, @datetime,
				0, 0, 0, 0,
				1, 0, @datetime, @datetime, @datetime, 1127222095
			FROM dbo.match WITH(NOLOCK) WHERE sporttype = 1

			SELECT @matchId = SCOPE_IDENTITY()
		END
	END
	------------
	DECLARE @transid BIGINT

	-- insert running ticket
	INSERT INTO dbo.bettrans
	(
		matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
		winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
		apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
		sdiscount, adiscount, discount, playerdiscount,
		livehomescore, liveawayscore, betteam, creator, refno,
		winlostdate, betfrom, checktime, oddsspread, oddstype,
		currency, actualrate, virtualrate,
		srecommend, mrecommend, recommend, custid, Username,
		ip, bettype, transdesc, liveindicator
	)
	SELECT @matchid, @datetime, 98344397, @hdp1, @hdp2, 0.9, @stake, @stake, 'running', 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,
		0.4, 0.3, 0.15, 0.85,
		0, 0, 0, 0,
		0, 0, @betteam, 8, 100000000000,
		@winlostdate, 'd', @datetime, @oddsspread, 1,
		@currency, @actualrate, @actualrate,
		@srecommend, @mrecommend, @recommend, @custid, @username,
		'127.1.1.0', @bettype, '', @islive

	SELECT @transid = SCOPE_IDENTITY()

	IF NOT EXISTS (SELECT 1 FROM dbo.ResultDetail WITH (NOLOCK) WHERE MatchId = @matchid)
	BEGIN
		EXEC DBA_Fast_Market_ResultDetailUpd @MatchId = @matchid
											,@bettype = 0
											,@mode = 1
	END

	-- oddsid
	INSERT INTO odds (matchid, bettype, sporttype, liveindicator, TBRepKey)
	SELECT t.matchid, t.bettype, t.sporttype, t.liveindicator, 1
	FROM (
		SELECT @matchid matchid, number + 220 bettype, 1 sporttype, 0 liveindicator
		FROM master.dbo.spt_values
		WHERE  number BETWEEN 1 AND 7 AND type = 'p'
		UNION ALL
		SELECT @matchid matchid, number + 220 bettype, 1 sporttype, 1 liveindicator
		FROM master.dbo.spt_values
		WHERE  number BETWEEN 1 AND 7 AND type = 'p'
	)t
	LEFT JOIN odds o 
		ON o.matchid = t.matchid
			AND o.sporttype = t.sporttype
			AND o.bettype = t.bettype
			AND o.liveindicator = t.liveindicator
	WHERE o.matchid IS NULL

	-- Result Detail
	IF @matchstatus = 'Completed'
	BEGIN
		DECLARE @EventCounterMatrix TABLE (ID INT IDENTITY (1,1), EventCounter TINYINT, Actions TINYINT, Results TINYINT)

		DECLARE @EventCounterActionsXML TABLE (EventCounter TINYINT, Actions BIGINT)

		INSERT INTO @EventCounterMatrix (EventCounter, Actions, Results)
		SELECT SUM([1]) AS EventCounter, SUM([2]) AS Actions, SUM([3]) AS Results
		FROM
		(
			SELECT
				d.lrank,
				CASE WHEN d.rank = 1 THEN d.val ELSE 0 END AS [1],
				CASE WHEN d.rank = 2 THEN d.val ELSE 0 END AS [2],
				CASE WHEN d.rank = 3 THEN d.val ELSE 0 END AS [3]
			FROM
			(
				SELECT list.rank as lrank, data.rank, CONVERT(TINYINT, data.val) AS val, data.id
				FROM dbo.strSplit(@ListEventCounter, ',') list
					CROSS APPLY dbo.strSplit(list.val, '-') data
			) AS d
		) AS A
		GROUP BY lrank
		ORDER BY EventCounter

		DECLARE @ID INT, @EventCounter TINYINT, @Actions TINYINT, @Results TINYINT
		SELECT  @ID = 1

		WHILE EXISTS (SELECT 1 FROM @EventCounterMatrix WHERE ID = @ID)
		BEGIN
			SELECT @EventCounter = EventCounter, @Actions = Actions, @Results = Results
			FROM @EventCounterMatrix WHERE ID = @ID

			IF NOT EXISTS (SELECT 1 FROM @EventCounterActionsXML WHERE EventCounter = @EventCounter)
			BEGIN
				INSERT INTO @EventCounterActionsXML (EventCounter, Actions)
				SELECT @EventCounter, POWER(10, @Actions)
			END
			ELSE
			BEGIN
				UPDATE @EventCounterActionsXML
				SET Actions = Actions + POWER(10, @Actions)
				WHERE EventCounter = @EventCounter
			END

			SELECT @ID = @ID + 1
		END

		UPDATE @EventCounterActionsXML
		SET Actions = dbo.BinaryToDecimal(CONVERT(VARCHAR(255), Actions))

		DECLARE @ResultsXML VARCHAR(MAX) = '', @EventCountersXML VARCHAR(MAX)

		SELECT @ResultsXML = CONVERT(VARCHAR(MAX), (
			SELECT EventCounter '@p', Actions '@r'
			FROM @EventCounterActionsXML
			FOR XML PATH ('r'), ROOT ('b'), TYPE)
		)

		SELECT @ResultsXML = '<r>' + @ResultsXML + '</r>'

		SELECT @ResultsXML = REPLACE (@ResultsXML, '<b>', '<b Id="' + CONVERT(VARCHAR(10), @bettype) + '">')

		IF @bettype IN (221, 222)
		BEGIN
			DECLARE @EventCounterActionResultsXML TABLE (ActionID TINYINT, EventCounter TINYINT, Results TINYINT)
			
			INSERT INTO @EventCounterActionResultsXML (ActionID, EventCounter, Results)
			SELECT A.ActionID, E.EventCounter, 0 AS Results
			FROM
			(
				SELECT DISTINCT EventCounter
				FROM @EventCounterMatrix
			) AS E
				CROSS APPLY
				(
					SELECT * FROM (VALUES (2), (3), (4), (5), (6), (8)) AS A(ActionID)
				) AS A

			UPDATE eXML
			SET eXML.Results = eM.Results
			FROM @EventCounterActionResultsXML eXML
				INNER JOIN @EventCounterMatrix eM ON eXML.EventCounter = eM.EventCounter AND eXML.ActionID - 1 = eM.Actions

			SELECT @EventCountersXML = CONVERT(VARCHAR(MAX), (
				SELECT
					ActionID '@Id',
					(
						SELECT
							EventCounter '@p',
							Results '@r'
						FROM @EventCounterActionResultsXML sub
						WHERE sub.ActionID = main.ActionID
						FOR XML PATH ('r'), TYPE
					)
				FROM @EventCounterActionResultsXML main
				FOR XML PATH ('e'), ROOT ('r'), TYPE)
			)

			SELECT @EventCountersXML = REPLACE (@EventCountersXML, 'Id="', 'Id="221CNT0')
		END

		DECLARE @ErrCode INT = 0, @ErrMsg VARCHAR(200) = ''

		EXEC dbo.NAP_Admin_Settlement_Fast_Market_Auto_1s_xtest
			@MatchId = @matchid,
			@AdminId = 8,
			@Action = 'CAL',
			@Results = @ResultsXML,
			@EventCounters = @EventCountersXML,
			@ErrCode = @ErrCode OUTPUT,
			@ErrMsg = @ErrMsg OUTPUT

		IF @ErrCode <> 0
		BEGIN
			SELECT @ErrMsg
			RETURN
		END

		--SELECT 2 AS 'End'
	END

	SELECT matchid, bettype, *
	FROM dbo.bettrans WITH (NOLOCK)
	WHERE matchid = @matchid

	-- bettrans14
	IF @winlostdate BETWEEN @BUDay AND @MBDay
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.match14 WITH (NOLOCK) WHERE matchid = @matchId)
		BEGIN
			INSERT INTO dbo.match14
			(
				[matchid], [leagueid], [homeid], [awayid],[eventdate], [eventstatus],
				[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
				[creator], [matchcode], [kickofftime], [closedtime], [showtime],
				[hthomescore], [htawayscore], [ruben], [multiple],
				[sporttype], [IsNeutral], [GlobalShowTime], [settletime], [ParentID]
			)
			SELECT
				[matchid], [leagueid], [homeid], [awayid],[eventdate], [eventstatus],
				[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
				[creator], [matchcode], [kickofftime], [closedtime], [showtime],
				[hthomescore], [htawayscore], [ruben], [multiple],
				[sporttype], [IsNeutral], [GlobalShowTime], [settletime], [ParentID]
			FROM dbo.match WITH(NOLOCK) WHERE matchid = @matchId

			DELETE dbo.match WITH (ROWLOCK, UPDLOCK) WHERE matchid = @matchId
		END

		INSERT INTO dbo.bettrans14
		(
			transid, matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
			winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
			apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
			sdiscount, adiscount, discount, playerdiscount,
			livehomescore, liveawayscore, betteam, creator, refno,
			winlostdate, betfrom, checktime, oddsspread, oddstype,
			currency, actualrate, virtualrate,
			srecommend, mrecommend, recommend, custid, Username,
			ip, bettype, transdesc, liveindicator
		)
		SELECT
			transid, matchid, transdate, oddsid, hdp1, hdp2, odds, stake, actual_stake, status, statusID, ruben,
			winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
			apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
			sdiscount, adiscount, discount, playerdiscount,
			livehomescore, liveawayscore, betteam, creator, refno,
			winlostdate, betfrom, checktime, oddsspread, oddstype,
			currency, actualrate, virtualrate,
			srecommend, mrecommend, recommend, custid, Username,
			ip, bettype, transdesc, liveindicator
		FROM dbo.bettrans WITH (NOLOCK)
		WHERE transid = @transid

		DELETE dbo.ResultDetail14 WITH (ROWLOCK, UPDLOCK) WHERE matchid = @matchid

		INSERT INTO dbo.ResultDetail14
		(
			MatchId,ResourceId,HomeValue,AwayValue,ResultStatusID,SettlementStatusID,
			CreateDate,LastModifyDate,CreateBy,LastModifyBy,OtherInfo
		)
		SELECT
			MatchId,ResourceId,HomeValue,AwayValue,ResultStatusID,SettlementStatusID,
			CreateDate,LastModifyDate,CreateBy,LastModifyBy,OtherInfo
		FROM dbo.ResultDetail WITH (NOLOCK)
		WHERE matchid = @matchid

		-- rptStatement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement @winlostdate = @winlostdate
												   ,@custid = @custid
												   ,@recommend = @recommend
												   ,@mrecommend = @mrecommend
												   ,@srecommend = @srecommend
												   ,@BalanceUpDay = @BUDay
												   ,@statementdate = @winlostdate

		-- sum_winloss
		;WITH tmp_sum_winloss AS
		(
			SELECT
				b.custid,b.recommend,b.mrecommend,b.srecommend,
				SUM(b.stake) AS turnover, COUNT(b.transid) AS betcount,
				SUM(b.winlost) AS winlost, SUM(b.awinlost) AS awinlost, SUM(b.mwinlost) AS mwinlost, SUM(b.swinlost) AS swinlost,
				SUM(CASE WHEN statusID = 111 THEN 0 ELSE b.stake END) AS turnoverNoDraw
			FROM dbo.bettrans b WITH (NOLOCK)
			WHERE b.transid = @transid
			GROUP BY b.custid,b.recommend,b.mrecommend,b.srecommend
		)
		MERGE dbo.sum_winloss AS s
		USING (
			SELECT custid, roleId, recommend, mrecommend, srecommend, @winlostdate AS winlostdate, 0 AS sporttype,
				turnover, betcount, winlost, awinlost, mwinlost, swinlost, turnoverNoDraw
			FROM (
				SELECT custid, 1 AS roleId, recommend, mrecommend, srecommend,
					turnover, betcount, winlost, awinlost, mwinlost, swinlost, turnoverNoDraw
				FROM tmp_sum_winloss
				UNION ALL
				SELECT recommend, 2 AS roleId, @recommend, @mrecommend, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw)
				FROM tmp_sum_winloss
				GROUP BY recommend
				UNION ALL
				SELECT mrecommend, 3 AS roleId, 0, @mrecommend, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw)
				FROM tmp_sum_winloss
				GROUP BY mrecommend
				UNION ALL
				SELECT srecommend, 4 AS roleId, 0, 0, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw)
				FROM tmp_sum_winloss
				GROUP BY srecommend
			) AS A
		) AS src
			ON s.custid = src.custid AND s.winlostdate = src.winlostdate AND s.sporttype = src.sporttype
		WHEN MATCHED THEN
			UPDATE SET
				s.turnover = s.turnover + src.turnover,
				s.BetCount = s.BetCount + src.betcount,
				s.winlost = s.winlost + src.winlost,
				s.awinlost = s.awinlost + src.awinlost,
				s.mwinlost = s.mwinlost + src.mwinlost,
				s.swinlost = s.swinlost + src.swinlost,
				s.TunroverNoDraw = s.TunroverNoDraw + src.turnoverNoDraw
		WHEN NOT MATCHED THEN
			INSERT
			(
				winlostdate,username,custid,roleid,recommend,mrecommend,srecommend,turnover,winlost,awinlost,mwinlost,swinlost,
				playercomm,comm,acomm,scomm,BetCount,grosscomm,sporttype,bettype,netTurnover,TunroverNoDraw
			)
			VALUES
			(
				src.winlostdate, '',src.custId,src.roleId,src.recommend,src.mrecommend,src.srecommend,src.turnover,
				src.winlost,src.awinlost,src.mwinlost,src.swinlost,0,0,0,0,src.betcount,0,src.sporttype,0,0,turnoverNoDraw
			);

		-- 
		DELETE dbo.bettrans WITH (ROWLOCK, UPDLOCK) WHERE transid = @transid

		DELETE dbo.ResultDetail WITH (ROWLOCK, UPDLOCK) WHERE MatchId = @matchid
	END
	ELSE IF @winlostdate < @BUDay
	BEGIN
		SELECT 'bettrans_bk'

		DECLARE @transids VARCHAR(MAX)
		SELECT  @transids = CONVERT(VARCHAR(20), @transid)
		-- bettrans_bk
		EXEC DBARC.bodb_Archive.dbo.DBA_ArchiveTickets
			@transids = @transids,
			@matchid = @matchid

		-- sum_winloss_old
		EXEC DBAGE.bodb_Summary.dbo.DBA_sum_winloss_old_Ins
			@transids		= @transids,
			@recommend		= @recommend,
			@mrecommend		= @mrecommend,
			@srecommend		= @srecommend,
			@winlostdate	= @winlostdate,
			@sporttype		= 0

		-- Statement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement_Old @winlostdate = @winlostdate
													   ,@custid = @custid
													   ,@recommend = @recommend
													   ,@mrecommend = @mrecommend
													   ,@srecommend = @srecommend

		-- delete data
		DELETE dbo.match WITH (ROWLOCK, UPDLOCK) WHERE matchid = @matchId

		DELETE bettrans WITH (ROWLOCK, UPDLOCK) WHERE transid = @transid

		DELETE dbo.ResultDetail WITH (ROWLOCK, UPDLOCK) WHERE MatchId = @matchid
	END
END
GO
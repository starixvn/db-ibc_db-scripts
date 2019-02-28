USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_PokerGames_CreateData]
	@CustId					INT,
	@Bettype				INT,
	@Status					VARCHAR(100) = 'running',
	@Stake					MONEY = 100,
	@winlost				MONEY = 0,
	@RemainingAmount		MONEY = 0,
	@winlostdate			SMALLDATETIME = NULL,
	@TableNumber			INT = 21573,
	@Seat					TINYINT = 1, -- 1-->8
	@Perpoint				MONEY = 1,
	@Mode					TINYINT = 1, -- 1-->15
	@Turnover				MONEY = 3,
	@Tax					MONEY = 0.15,
	@TransId3rd				BIGINT = 12345,
	@NoOfRound				INT = 1,
	-- game bought
	@TotalGems				INT = 1200,
	@Gembought				INT = 1000,
	-- discount
	@oddsspread				MONEY = 10,
	@sdiscount				DECIMAL(9,8) = 0,  
	@adiscount				DECIMAL(9,8) = 0,  
	@discount				DECIMAL(9,8) = 0,  
	@playerdiscount			DECIMAL(9,8) = 0
AS

/*
	20180711@Percy
*/

BEGIN
	SET NOCOUNT ON

	SELECT @winlostdate = CONVERT(DATE, ISNULL(@winlostdate, GETDATE()))

	DECLARE @transdate SMALLDATETIME

	SELECT  @transdate = DATEADD(MILLISECOND, DATEDIFF(MILLISECOND, CONVERT(DATE, GETDATE()), GETDATE()), @winlostdate)

	-- PT = all 0
	DECLARE @tpositiontaking MONEY, @apositiontaking MONEY = 0,@mpositiontaking MONEY = 0, @spositiontaking MONEY = 0
	SELECT  @tpositiontaking = @apositiontaking + @mpositiontaking + @spositiontaking

	IF @tpositiontaking > 1
	BEGIN
		SELECT 'Invalid PT'
		RETURN
	END

	IF @Mode NOT BETWEEN 1 AND 15
	BEGIN
		SELECT 'Invalid mode'
		RETURN
	END

	IF @Bettype NOT BETWEEN 1401 AND 1499
	BEGIN
		SELECT 'Invalid bettype'
		RETURN
	END

	IF @Status NOT IN ('running','WON','LOSE','DRAW','Void')
	BEGIN
		SELECT 'Invalid status'
		RETURN
	END

	DECLARE @statusID TINYINT
	SELECT  @statusID = CASE @status
			WHEN 'running' THEN 0
			WHEN 'waiting' THEN 1
			WHEN 'WON' THEN 112
			WHEN 'LOSE' THEN 113
			WHEN 'DRAW' THEN 111
			WHEN 'VOID' THEN 102
			WHEN 'Reject' THEN 101
			WHEN 'Refund' THEN 103
			END  

	DECLARE @sporttype INT = 163

	DECLARE @BUDate SMALLDATETIME, @MBDate SMALLDATETIME

	SELECT  @BUDate = winlostdate FROM dbo.bettrans WITH (NOLOCK) WHERE matchid = 0 AND bettype = 20000 AND custid = 3
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT 'Invalid Balance Up Day'
		RETURN
	END

	SELECT  @MBDate = MAX(eventdate) FROM dbo.match14 WITH (NOLOCK)
	IF @@ROWCOUNT = 0
	BEGIN
		SELECT 'Invalid Move Bets Day'
		RETURN
	END

	IF @status = 'running' AND @winlostdate <= @MBDate
	BEGIN
		SELECT 'Status param not match with winlostdate param. Creating ticket failed!'
		RETURN
	END

	IF @status IN ('Void', 'Reject', 'Refund')
		SET @oddsspread = 0

	DECLARE @amount MONEY
	SELECT  @amount = @winlost - @stake

	IF (@status = 'WON' AND @amount <= 0)
		OR (@status = 'LOSE' AND @amount >= 0)
		OR (@status = 'running' AND @winlost <> 0)
		OR (@status NOT IN ('WON', 'LOSE', 'running') AND @amount <> 0)
	BEGIN
		SELECT 'Status param not match with winlost/stake param. Creating ticket failed!'
		RETURN
	END

	-- Get custinfo
	DECLARE @username VARCHAR(50), @recommend INT, @mrecommend INT, @srecommend INT, @currency INT, @actualrate FLOAT

	SELECT
		@username = c.username,
		@recommend = c.recommend,
		@mrecommend = c.mrecommend,
		@srecommend = c.srecommend,
		@currency = c.currency
	FROM CustDB.dbo.custInfo c WITH (NOLOCK)
	WHERE c.custid = @CustId AND c.roleid = 1

	IF @@ROWCOUNT = 0
	BEGIN
		SELECT 'Invalid member'
		RETURN
	END

	SELECT @actualrate = actualrate FROM dbo.exchange WITH (NOLOCK) WHERE exchangeid = @currency

	-- Create data
	DECLARE @betcheck NVARCHAR(50), @comstatus NVARCHAR(20)
	SELECT  @betcheck = CONVERT(NVARCHAR(50), @TransId3rd),
			@comstatus = 'Mode' + CONVERT(NVARCHAR(2), @Mode)

	DECLARE @ExtraInfo NVARCHAR(MAX)

	DECLARE @modds MONEY
	SELECT  @modds = NumberValue FROM DBCUST.CustDB.dbo.VendorGlobalSetting WITH (NOLOCK)
	WHERE VendorId = 33 AND VName = '3rdCommShareRate'

	DECLARE @betId BIGINT
	SELECT  @betId = @NoOfRound

	DECLARE
		@scomm MONEY,@acomm MONEY,@comm MONEY,@playercomm MONEY

	 SELECT
		 @playercomm = @oddsspread * @playerdiscount
		,@comm = @oddsspread * @discount
		,@acomm = @oddsspread * @adiscount
		,@scomm = @oddsspread * @sdiscount

	DECLARE @ruben TINYINT

	IF @Status = 'running'
	BEGIN
		IF @bettype = 1499
		BEGIN
			SELECT @ExtraInfo = N'<p33 tg="' + CONVERT(NVARCHAR(20), @TotalGems) + '" gb="' + CONVERT(NVARCHAR(20), @Gembought) + '"/>'
		END
		ELSE
		BEGIN
			SELECT @ExtraInfo = N'<p33 ra="' + CONVERT(NVARCHAR(20), @RemainingAmount) + '" tn="' + CONVERT(NVARCHAR(20), @TableNumber) + '"/>'
		END

		SELECT @ruben = 0
	END
	ELSE
	BEGIN
		IF @bettype = 1499
		BEGIN
			SELECT @ExtraInfo = N'<p33 tg="' + CONVERT(NVARCHAR(20), @TotalGems) + '" gb="' + CONVERT(NVARCHAR(20), @Gembought) + '" fc="0" rc="0"/>'
		END
		ELSE
		BEGIN
			SELECT @ExtraInfo = N'<p33 to="' + CONVERT(NVARCHAR(20), @Turnover) + '" tx="' + CONVERT(NVARCHAR(20), @Tax)
								+ '" is="0" ra="' + CONVERT(NVARCHAR(20), @RemainingAmount) + '" tn="' + CONVERT(NVARCHAR(20), @TableNumber) + '" fc="0" rc="0"/>'
		END

		SELECT @ruben = 1
	END

	-- Insert data into bettrans
	DECLARE @transid BIGINT
	
	BEGIN
		INSERT INTO dbo.bettrans
		(
			custid,currency,username,recommend,mrecommend,srecommend,
			actualrate,virtualrate,
			transdate,winlostdate,
			stake,actual_stake,winlost,oddsspread,
			bettype,status,statusID,ruben,
			livehomescore,
			hdp1,
			comstatus,
			betcheck,
			ip,
			spositiontaking,mpositiontaking,apositiontaking,tpositiontaking,
			sdiscount,adiscount,discount,playerdiscount,
			scomm,acomm,comm,playercomm,
			swinlost,mwinlost,awinlost,
			ExtraInfo,modds,betId,
			-- columns not null
			oddsid,creator,refno,matchid,liveindicator
		)
		VALUES
		(
			@custid,@currency,@username,@recommend,@mrecommend,@srecommend,
			@actualrate,@actualrate,
			@transdate,@winlostdate,
			@stake,@stake,@winlost,@oddsspread,
			@bettype,@status,@statusID,@ruben,
			@Seat, -- livehomescore
			@Perpoint, -- hdp1
			@comstatus,
			@betcheck,
			'', -- IP
			@spositiontaking,@mpositiontaking,@apositiontaking,@tpositiontaking,
			@sdiscount,@adiscount,@discount,@playerdiscount,
			@scomm,@acomm,@comm,@playercomm,
			0,0,0,
			@ExtraInfo,@modds,@betId,
			-- columns not null
			0,8,1000000000,@sporttype,0
		)

		SELECT @transid = SCOPE_IDENTITY()
	END

	-- range bettrans14
	IF @winlostdate BETWEEN @BUDate AND @MBDate
	BEGIN
		INSERT INTO dbo.bettrans14
		(
			transid,custid,currency,username,recommend,mrecommend,srecommend,
			actualrate,virtualrate,
			transdate,winlostdate,
			stake,actual_stake,winlost,oddsspread,
			bettype,status,statusID,ruben,
			livehomescore,
			hdp1,
			comstatus,
			betcheck,
			ip,
			spositiontaking,mpositiontaking,apositiontaking,tpositiontaking,
			sdiscount,adiscount,discount,playerdiscount,
			scomm,acomm,comm,playercomm,
			swinlost,mwinlost,awinlost,
			ExtraInfo,modds,betId,
			-- columns not null
			oddsid,creator,refno,matchid,liveindicator
		)
		SELECT
			transid,custid,currency,username,recommend,mrecommend,srecommend,
			actualrate,virtualrate,
			transdate,winlostdate,
			stake,actual_stake,winlost,oddsspread,
			bettype,status,statusID,ruben,
			livehomescore,
			hdp1,
			comstatus,
			betcheck,
			ip,
			spositiontaking,mpositiontaking,apositiontaking,tpositiontaking,
			sdiscount,adiscount,discount,playerdiscount,
			scomm,acomm,comm,playercomm,
			0,0,0,
			ExtraInfo,@modds,@betId,
			-- columns not null
			oddsid,creator,refno,matchid,0
		FROM dbo.bettrans WITH (NOLOCK)
		WHERE transid = @transId

		-- sum_winloss
		;WITH tmp_sum_winloss AS
		(
			SELECT
				b.custid,b.recommend,b.mrecommend,b.srecommend,
				SUM(b.stake) AS turnover, COUNT(b.transid) AS betcount,
				SUM(b.winlost-b.actual_stake) AS winlost, SUM(b.awinlost) AS awinlost, SUM(b.mwinlost) AS mwinlost, SUM(b.swinlost) AS swinlost,
				SUM(b.stake) AS turnoverNoDraw,
				SUM(b.oddsspread) AS oddsspread,
				SUM(b.scomm) AS scomm, SUM(b.acomm) AS acomm, SUM(b.comm) AS comm, SUM(b.playercomm) AS playercomm,
				SUM(CASE tpositiontaking WHEN 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommSuper,
				SUM(CASE tpositiontaking WHEN 1 THEN 0 ELSE scomm / (1-tpositiontaking) END) AS GrossCommMaster,
				SUM(CASE WHEN apositiontaking+mpositiontaking = 1 THEN 0 ELSE acomm/(1-apositiontaking-mpositiontaking) END) AS GrossCommAgent,
				SUM(CASE WHEN apositiontaking = 1 THEN 0 ELSE ISNULL(comm/(1-apositiontaking),0) END) AS GrossCommMember
			FROM dbo.bettrans b WITH (NOLOCK)
			WHERE b.transid = @transid
			GROUP BY b.custid,b.recommend,b.mrecommend,b.srecommend
		)
		MERGE dbo.sum_winloss AS s
		USING (
			SELECT custid, roleId, recommend, mrecommend, srecommend, @winlostdate AS winlostdate, @sporttype AS sporttype,
				turnover, betcount, winlost, awinlost, mwinlost, swinlost, turnoverNoDraw,
				oddsspread, scomm, acomm, comm, playercomm, GrossComm
			FROM (
				SELECT custid, 1 AS roleId, recommend, mrecommend, srecommend,
					turnover, betcount, winlost, awinlost, mwinlost, swinlost, turnoverNoDraw,
					oddsspread, scomm, acomm, comm, playercomm, GrossCommMember AS GrossComm
				FROM tmp_sum_winloss
				UNION ALL
				SELECT recommend, 2 AS roleId, @recommend, @mrecommend, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw),
					SUM(oddsspread), SUM(scomm), SUM(acomm), SUM(comm), SUM(playercomm), SUM(GrossCommAgent)
				FROM tmp_sum_winloss
				GROUP BY recommend
				UNION ALL
				SELECT mrecommend, 3 AS roleId, 0, @mrecommend, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw),
					SUM(oddsspread), SUM(scomm), SUM(acomm), SUM(comm), SUM(playercomm), SUM(GrossCommMaster)
				FROM tmp_sum_winloss
				GROUP BY mrecommend
				UNION ALL
				SELECT srecommend, 4 AS roleId, 0, 0, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(turnoverNoDraw),
					SUM(oddsspread), SUM(scomm), SUM(acomm), SUM(comm), SUM(playercomm), SUM(GrossCommSuper)
				FROM tmp_sum_winloss
				GROUP BY srecommend
			) AS A
		) AS src
			ON s.custid = src.custid AND s.winlostdate = src.winlostdate AND s.sporttype = src.sporttype
		WHEN MATCHED THEN
			UPDATE SET
			s.turnover = ISNULL(s.turnover, 0) + ISNULL(src.turnover, 0),
			s.BetCount = ISNULL(s.BetCount, 0) + ISNULL(src.betcount, 0),
			s.winlost = ISNULL(s.winlost, 0) + ISNULL(src.winlost, 0),
			s.awinlost = ISNULL(s.awinlost, 0) + ISNULL(src.awinlost, 0),
			s.mwinlost = ISNULL(s.mwinlost, 0) + ISNULL(src.mwinlost, 0),
			s.swinlost = ISNULL(s.swinlost, 0) + ISNULL(src.swinlost, 0),
			s.playercomm = ISNULL(s.playercomm, 0) + ISNULL(src.playercomm, 0),
			s.comm = ISNULL(s.comm, 0) + ISNULL(src.comm, 0),
			s.acomm = ISNULL(s.acomm, 0) + ISNULL(src.acomm, 0),
			s.scomm = ISNULL(s.scomm, 0) + ISNULL(src.scomm, 0),
			s.TunroverNoDraw = ISNULL(s.TunroverNoDraw, 0) + ISNULL(src.turnoverNoDraw, 0),
			s.grosscomm = ISNULL(s.grosscomm, 0) + ISNULL(src.grosscomm, 0)
		WHEN NOT MATCHED THEN
			INSERT
			(
				winlostdate,username,custid,roleid,recommend,mrecommend,srecommend,turnover,
				winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
				BetCount,grosscomm,sporttype,bettype,netTurnover,TunroverNoDraw
			)
			VALUES
			(
				src.winlostdate, '',src.custId,src.roleId,src.recommend,src.mrecommend,src.srecommend,src.turnover,
				src.winlost,src.awinlost,src.mwinlost,src.swinlost,src.playercomm,src.comm,src.acomm,src.scomm,
				src.betcount,src.GrossComm,src.sporttype,0,0,src.turnoverNoDraw
			);

		-- bettype 19999
		MERGE dbo.bettrans AS b
		USING
		(
			SELECT @winlost, @stake, @scomm, @acomm, @comm,@playercomm
		) AS s
		(
			winlost, stake, scomm, acomm, comm,playercomm
		)
		ON b.custid = @custid AND b.matchid = 0 AND b.bettype = 19999
		WHEN MATCHED THEN UPDATE SET
			b.winlost = b.winlost + s.winlost,
			b.stake = b.stake + s.stake,
			b.actual_stake = b.actual_stake + s.stake,
			b.scomm = b.scomm + s.scomm,
			b.acomm = b.acomm + s.acomm,
			b.comm = b.comm + s.comm,
			b.playercomm = b.playercomm + s.playercomm
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				custid,currency,username,recommend,mrecommend,srecommend,
				actualrate,virtualrate,
				transdate,winlostdate,
				stake,actual_stake,winlost,
				bettype,status,statusID,ruben,
				spositiontaking,mpositiontaking,apositiontaking,tpositiontaking,
				sdiscount,adiscount,discount,playerdiscount,
				scomm,acomm,comm,playercomm,
				swinlost,mwinlost,awinlost,
				-- columns not null
				oddsid,creator,refno,matchid,liveindicator
			)
			VALUES
			(
				@custid,@currency,@username,@recommend,@mrecommend,@srecommend,
				@actualrate,@actualrate,
				@MBDate,@MBDate,
				@stake,@stake,@winlost,
				19999,'SUM',142,1,
				0,0,0,0,
				0,0,0,0,
				@scomm,@acomm,@comm,@playercomm,
				0,0,0,
				-- columns not null
				0,8,100000000,0,0
			);

		-- rptStatement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement
			@winlostdate = @winlostdate,
			@custid = @custid,
			@recommend = @recommend,
			@mrecommend = @mrecommend,
			@srecommend = @srecommend,
			@BalanceUpDay = @BUDate,
			@statementdate = @winlostdate

		-- delete data
		DELETE b WITH (ROWLOCK, UPDLOCK)
		FROM dbo.bettrans b
		WHERE b.transid = @transid
	END
	-- range bettrans_bk
	ELSE IF @winlostdate < @BUDate
	BEGIN
		-- bettype 20000
		MERGE dbo.bettrans AS b
		USING
		(
			SELECT @custid AS custId, @recommend AS recommend, @mrecommend AS mrecommend, @srecommend AS srecommend, @winlost - @stake + @playercomm AS balance UNION ALL
			SELECT @recommend, @recommend, @mrecommend, @srecommend, 0 + @comm - @playercomm UNION ALL
			SELECT @mrecommend, 0, @mrecommend, @srecommend, 0 + @acomm - @comm UNION ALL
			SELECT @srecommend, 0, 0, @srecommend, 0 + @scomm - @acomm
		) AS s
		(
			custid, recommend, mrecommend, srecommend, balance
		)
		ON b.custid = s.custid AND b.matchid = 0 AND b.bettype = 20000
		WHEN MATCHED THEN UPDATE SET
			b.winlost = CASE WHEN b.winlost - b.actual_stake + s.balance > 0 THEN b.winlost - b.actual_stake + s.balance ELSE 0 END,
			b.actual_stake = CASE WHEN b.winlost - b.actual_stake + s.balance < 0 THEN b.winlost - b.actual_stake + s.balance ELSE 0 END
		WHEN NOT MATCHED BY TARGET THEN INSERT
			(
				custid,currency,username,recommend,mrecommend,srecommend,
				actualrate,virtualrate,
				transdate,winlostdate,
				stake,actual_stake,winlost,
				bettype,status,statusID,ruben,
				spositiontaking,mpositiontaking,apositiontaking,tpositiontaking,
				sdiscount,adiscount,discount,playerdiscount,
				scomm,acomm,comm,playercomm,
				swinlost,mwinlost,awinlost,
				-- columns not null
				oddsid,creator,refno,matchid,liveindicator
			)
			VALUES
			(
				custid,@currency,@username,recommend,mrecommend,srecommend,
				@actualrate,@actualrate,
				@BUDate,@BUDate,
				0,CASE WHEN Balance < 0 THEN Balance ELSE 0 END,CASE WHEN Balance > 0 THEN Balance ELSE 0 END,
				20000,'BALANCE',141,1,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,
				-- columns not null
				0,8,100000000,0,0
			);

		-- rptStatement
		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement
			@winlostdate = @winlostdate,
			@custid = @custid,
			@recommend = @recommend,
			@mrecommend = @mrecommend,
			@srecommend = @srecommend,
			@BalanceUpDay = @BUDate,
			@statementdate = @winlostdate

		EXEC DBRPT.bodb_Report.dbo.DBA_RptStatement_Old
			@winlostdate = @winlostdate,
			@custid = @custid,
			@recommend = @recommend,
			@mrecommend = @mrecommend,
			@srecommend = @srecommend

		DECLARE @transids VARCHAR(MAX)
		SELECT  @transids = CONVERT(VARCHAR(20), @transid)
		-- bettrans_bk
		EXEC DBARC.bodb_Archive.dbo.DBA_ArchiveTickets
			@transids = @transids

		-- sum_winloss_old
		EXEC DBAGE.bodb_Summary.dbo.DBA_sum_winloss_old_Ins
			@transids		= @transids,
			@recommend		= @recommend,
			@mrecommend		= @mrecommend,
			@srecommend		= @srecommend,
			@winlostdate	= @winlostdate,
			@sporttype		= @sporttype

		-- delete data
		DELETE b WITH (ROWLOCK, UPDLOCK)
		FROM dbo.bettrans b
		WHERE b.transid = @transid
	END

	-- OUTPUT
	SELECT @transid AS transid, @winlostdate AS winlostdate, @status AS status
END
GO
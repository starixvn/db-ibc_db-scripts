USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_Pragmatic_CreateData]
	@CustId				INT,
	@WinlostDate		SMALLDATETIME = NULL,
	@BetType			INT,
	@Status				VARCHAR(50) = 'running',
	@Stake				MONEY = 100,
	@Winlost			MONEY = 0,
	@apositiontaking	MONEY = 0.4,
	@mpositiontaking	MONEY = 0.3,
	@spositiontaking	MONEY = 0.2,
	@sdiscount			DECIMAL(9,8) = 0,
	@adiscount			DECIMAL(9,8) = 0,
	@discount			DECIMAL(9,8) = 0,
	@playerdiscount		DECIMAL(9,8) = 0,
	@TranId3rd			BIGINT = 100000
AS

/*
	Created: Percy
	DB: DB206.bodb02
	Task: PP
*/

BEGIN
	SET NOCOUNT ON

	IF @status NOT IN ('running', 'WON', 'LOSE', 'DRAW', 'VOID', 'Reject', 'Refund')
	BEGIN
		SELECT 'Invalid status!'
		RETURN
	END

	IF
		(@status IN ('running', 'LOSE') AND @winlost <> 0)
		OR (@status IN ('DRAW', 'VOID', 'Reject', 'Refund') AND @winlost <> @stake)
		OR (@status = 'WON' AND @winlost = 0)
	BEGIN
		SELECT 'Status is not consistent with winlost!'
		RETURN
	END

	SELECT @WinlostDate = ISNULL(@WinlostDate, CONVERT(DATE, GETDATE()))

	DECLARE @MBDate SMALLDATETIME, @BUDate SMALLDATETIME

	SELECT @MBDate = MAX(eventdate) FROM dbo.match14 WITH (NOLOCK)
	SELECT TOP 1 @BUDate = winlostdate FROM dbo.bettrans WITH (NOLOCK) WHERE custid = 3 AND matchid = 0 AND bettype = 20000

	IF @MBDate IS NULL OR @BUDate IS NULL
	BEGIN
		SELECT 'Can not get MoveBetsDay/BalanceUpDay, please contact DBA team'
		RETURN
	END

	IF @status = 'running' AND @WinlostDate <= @MBDate
	BEGIN
		SELECT 'status is not consistent with winlostdate'
		RETURN
	END

	DECLARE
		@Username		VARCHAR(50) = '',
		@Currency		INT = 0,
		@CurrencyName	VARCHAR(10) = '',
		@Actualrate		FLOAT = 0,
		@srecommend		INT = 0,
		@mrecommend		INT = 0,
		@recommend		INT = 0

	EXEC dbo.DBA_Customer_GetInfo
		@CustId = @CustId,
		@Username = @Username OUTPUT,
		@Currency = @Currency OUTPUT,
		@CurrencyName = @CurrencyName OUTPUT,
		@Actualrate = @Actualrate OUTPUT,
		@srecommend = @srecommend OUTPUT,
		@mrecommend	= @mrecommend OUTPUT,
		@recommend = @recommend OUTPUT

	IF ISNULL(@recommend, 0) = 0
	BEGIN
		SELECT 'Invalid custid!'
		RETURN
	END

	IF @bettype NOT BETWEEN 4101 AND 4300
	BEGIN
		SELECT 'Invalid bettype!'
		RETURN
	END

	DECLARE @sporttype INT = 248, @statusID INT, @transdate DATETIME

	SELECT @statusID = CASE @status
		WHEN 'running' THEN 0
		WHEN 'WON' THEN 112
		WHEN 'LOSE' THEN 113
		WHEN 'DRAW' THEN 111
		WHEN 'VOID' THEN 102
		WHEN 'Reject' THEN 101
		WHEN 'Refund' THEN 103
	END

	SELECT @transdate = DATEADD(MILLISECOND, DATEDIFF(MILLISECOND, CONVERT(DATE, GETDATE()), GETDATE()), @winlostdate)

	DECLARE @transidRnG BIGINT, @transid BIGINT

	DECLARE @odds MONEY = 0
	DECLARE @awinlost MONEY, @mwinlost MONEY, @swinlost MONEY
	DECLARE @tpositiontaking MONEY

	DECLARE @winlost_s MONEY, @awinlost_s MONEY, @mwinlost_s MONEY, @swinlost_s MONEY,
			@stake_s MONEY, @actual_stake_s MONEY,
			@playerdiscount_s MONEY, @discount_s MONEY, @adiscount_s MONEY, @sdiscount_s MONEY,
			@playercomm_s MONEY, @comm_s MONEY, @acomm_s MONEY, @scomm_s MONEY

	SELECT
		@awinlost = -(@winlost - @stake) * @apositiontaking,
		@mwinlost = -(@winlost - @stake) * @mpositiontaking,
		@swinlost = -(@winlost - @stake) * @spositiontaking

	SELECT	@tpositiontaking = @apositiontaking + @mpositiontaking + @spositiontaking

	DECLARE @playercomm MONEY, @comm MONEY, @acomm MONEY, @scomm MONEY

	SELECT  @playercomm = @stake * @playerdiscount,
			@comm = @stake * @discount * (1 - @apositiontaking),
			@acomm = @stake * @adiscount * (1 - @apositiontaking - @mpositiontaking),
			@scomm = @stake * @sdiscount * (1 - @tpositiontaking)

	--- bettransRnG
	INSERT INTO dbo.bettransRnG
	(
		custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,spositiontaking,tpositiontaking,
		playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,
		actual_stake,currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,
		transdesc,productID,gameID,vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,
		playercomm,comm,acomm,scomm
	)
	VALUES
	(
		@custid,@transdate,@odds,@stake,@status,@apositiontaking,@mpositiontaking,@spositiontaking,@tpositiontaking,
		@playerdiscount,@discount,@adiscount,@sdiscount,8,@winlostdate,'d',@actualrate,@actualrate,
		@stake,@currency,@CurrencyName,@recommend,@mrecommend,@srecommend,'',@statusID,0,@Username,
		CONVERT(VARCHAR(20), @bettype),@sporttype,@bettype,0,0,@TranId3rd,0,1,@winlost,@awinlost,@mwinlost,@swinlost,
		@playercomm,@comm,@acomm,@scomm
	)
	
	SELECT @transidRnG = SCOPE_IDENTITY()

	IF @winlostdate > @MBDate -- bettrans
	BEGIN
		SELECT 'bettrans'

		SELECT @transid = transid FROM dbo.bettrans WITH (NOLOCK)
		WHERE custid = @custid AND winlostdate = @winlostdate AND bettype = @bettype

		IF @statusID = 0
		BEGIN
			IF @transid IS NULL
			BEGIN
				INSERT INTO dbo.bettrans
				(
					custid,transdate,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,
					apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,
					liveindicator,creator,refno,winlostdate,betfrom,actualrate,matchid,recommend,mrecommend,
					ruben,bettype,actual_stake,currency,ip,transdesc,sdiscount,scomm,spositiontaking,
					swinlost,srecommend,Username,CurrencyName,virtualrate,statusID,balance
				)
				VALUES
				(
					@custid,@transdate,@odds,@stake,@status,@winlost,@awinlost,@mwinlost,0,0,0,
					@apositiontaking,@mpositiontaking,@tpositiontaking,0,0,0,
					0,8,0,@winlostdate,'d',@actualrate,@sporttype,@recommend,@mrecommend,
					0,@bettype,@stake,@currency,'',CONVERT(VARCHAR(20), @bettype),0,0,@spositiontaking,
					@swinlost,@srecommend,@Username,@CurrencyName,@actualrate,@statusID,0
				)

				SELECT @transid = SCOPE_IDENTITY()
			END
		END
		ELSE
		BEGIN
			SELECT
				@winlost_s = SUM(ISNULL(winlost, 0)),
				@swinlost_s = SUM(ISNULL(swinlost, 0)),
				@mwinlost_s = SUM(ISNULL(mwinlost, 0)),
				@awinlost_s = SUM(ISNULL(awinlost, 0)),
				@stake_s = SUM(ISNULL(stake, 0)),
				@actual_stake_s = SUM(ISNULL(actual_stake, 0)),
				@playerdiscount_s = SUM(ISNULL(playerdiscount, 0)),
				@discount_s = SUM(ISNULL(discount, 0)),
				@adiscount_s = SUM(ISNULL(adiscount, 0)),
				@sdiscount_s = SUM(ISNULL(sdiscount, 0)),
				@playercomm_s = SUM(ISNULL(playercomm, 0)),
				@comm_s = SUM(ISNULL(comm, 0)),
				@acomm_s = SUM(ISNULL(acomm, 0)),
				@scomm_s = SUM(ISNULL(scomm, 0))
			FROM dbo.bettransRnG WITH (NOLOCK)
			WHERE custid = @custid AND winlostdate = @winlostdate AND gameId = @bettype
				AND statusID NOT IN (0,1)

			IF @transid IS NOT NULL
			BEGIN
				UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
				SET
					winlost = @winlost_s,
					swinlost = @swinlost_s,
					mwinlost = @mwinlost_s,
					awinlost = @awinlost_s,
					stake = @stake_s,
					actual_stake = @actual_stake_s,
					playerdiscount = @playerdiscount_s,
					discount = @discount_s,
					adiscount = @adiscount_s,
					sdiscount = @sdiscount_s,
					playercomm = @playercomm_s,
					comm = @comm_s,
					acomm = @acomm_s,
					scomm = @scomm_s,
					ruben = 1
				WHERE transid = @transid
			END
			ELSE
			BEGIN
				INSERT INTO dbo.bettrans
				(
					custid,transdate,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,
					apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,
					liveindicator,creator,refno,winlostdate,betfrom,actualrate,matchid,recommend,mrecommend,
					ruben,bettype,actual_stake,currency,ip,transdesc,sdiscount,scomm,spositiontaking,
					swinlost,srecommend,Username,CurrencyName,virtualrate,statusID,balance
				)
				VALUES
				(
					@custid,@transdate,@odds,@stake_s,@status,@winlost_s,@awinlost_s,@mwinlost_s,@playercomm_s,@comm_s,@acomm_s,
					@apositiontaking,@mpositiontaking,@tpositiontaking,@playerdiscount_s,@discount_s,@adiscount_s,
					0,8,0,@winlostdate,'d',@actualrate,@sporttype,@recommend,@mrecommend,
					1,@bettype,@actual_stake_s,@currency,'',CONVERT(VARCHAR(20), @bettype),@sdiscount_s,@scomm_s,@spositiontaking,
					@swinlost_s,@srecommend,@Username,@CurrencyName,@actualrate,@statusID,0
				)

				SELECT @transid = SCOPE_IDENTITY()
			END

			UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
			SET
				status = CASE
					WHEN winlost > actual_stake THEN 'WON'
					WHEN winlost < actual_stake THEN 'LOSE'
					ELSE 'DRAW' END,
				statusID = CASE
					WHEN winlost > actual_stake THEN 112
					WHEN winlost < actual_stake THEN 111
					ELSE 113 END
			WHERE transid = @transid
		END

		UPDATE dbo.bettransRnG WITH (ROWLOCK, UPDLOCK)
		SET RefNo = @transid
		WHERE transid = @transidRnG
	END
	ELSE IF @winlostdate >= @BUDate -- bettrans14
	BEGIN
		SELECT 'bettrans14'

		SELECT @transid = transid FROM dbo.bettrans14 WITH (NOLOCK)
		WHERE custid = @custid AND winlostdate = @winlostdate AND bettype = @bettype

		-- move bettransRnG to bettransRnG14
		INSERT INTO dbo.bettransRnG14
		(
			transid,custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,tpositiontaking,spositiontaking,
			playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,actual_stake,
			currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,transdesc,productID,gameID,
			vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			Transdate3rd,Additional,SiteId,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		)
		SELECT
			transid,custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,tpositiontaking,spositiontaking,
			playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,actual_stake,
			currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,transdesc,productID,gameID,
			vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			Transdate3rd,Additional,SiteId,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		FROM dbo.bettransRnG WITH (NOLOCK)
		WHERE transid = @transidRnG

		DELETE dbo.bettransRnG WITH (ROWLOCK, UPDLOCK)
		WHERE transid = @transidRnG

		-- sum data
		SELECT
			@winlost_s = SUM(ISNULL(winlost, 0)),
			@swinlost_s = SUM(ISNULL(swinlost, 0)),
			@mwinlost_s = SUM(ISNULL(mwinlost, 0)),
			@awinlost_s = SUM(ISNULL(awinlost, 0)),
			@stake_s = SUM(ISNULL(stake, 0)),
			@actual_stake_s = SUM(ISNULL(actual_stake, 0)),
			@playerdiscount_s = SUM(ISNULL(playerdiscount, 0)),
			@discount_s = SUM(ISNULL(discount, 0)),
			@adiscount_s = SUM(ISNULL(adiscount, 0)),
			@sdiscount_s = SUM(ISNULL(sdiscount, 0)),
			@playercomm_s = SUM(ISNULL(playercomm, 0)),
			@comm_s = SUM(ISNULL(comm, 0)),
			@acomm_s = SUM(ISNULL(acomm, 0)),
			@scomm_s = SUM(ISNULL(scomm, 0))
		FROM dbo.bettransRnG14 WITH (NOLOCK)
		WHERE custid = @custid AND winlostdate = @winlostdate AND gameId = @bettype
			AND statusID NOT IN (0,1)

		IF @transid IS NOT NULL
		BEGIN
			UPDATE dbo.bettrans14 WITH (ROWLOCK, UPDLOCK)
			SET
				winlost = @winlost_s,
				swinlost = @swinlost_s,
				mwinlost = @mwinlost_s,
				awinlost = @awinlost_s,
				stake = @stake_s,
				actual_stake = @actual_stake_s,
				playerdiscount = @playerdiscount_s,
				discount = @discount_s,
				adiscount = @adiscount_s,
				sdiscount = @sdiscount_s,
				playercomm = @playercomm_s,
				comm = @comm_s,
				acomm = @acomm_s,
				scomm = @scomm_s,
				ruben = 1
			WHERE transid = @transid
		END
		ELSE
		BEGIN
			SELECT @transid = dbo.f_GetMinTransId()

			INSERT INTO dbo.bettrans14
			(
				transid,custid,transdate,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,
				apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,
				liveindicator,creator,refno,winlostdate,betfrom,actualrate,matchid,recommend,mrecommend,
				ruben,bettype,actual_stake,currency,ip,transdesc,sdiscount,scomm,spositiontaking,
				swinlost,srecommend,Username,CurrencyName,virtualrate,statusID,balance,oddsid
			)
			VALUES
			(
				@transid,@custid,@transdate,@odds,@stake_s,@status,@winlost_s,@awinlost_s,@mwinlost_s,@playercomm_s,@comm_s,@acomm_s,
				@apositiontaking,@mpositiontaking,@tpositiontaking,@playerdiscount_s,@discount_s,@adiscount_s,
				0,8,0,@winlostdate,'d',@actualrate,@sporttype,@recommend,@mrecommend,
				1,@bettype,@actual_stake_s,@currency,'',CONVERT(VARCHAR(20), @bettype),@sdiscount_s,@scomm_s,@spositiontaking,
				@swinlost_s,@srecommend,@Username,@CurrencyName,@actualrate,@statusID,0,0
			)
		END

		UPDATE dbo.bettrans14 WITH (ROWLOCK, UPDLOCK)
		SET
			status = CASE
				WHEN winlost > actual_stake THEN 'WON'
				WHEN winlost < actual_stake THEN 'LOSE'
				ELSE 'DRAW' END,
			statusID = CASE
				WHEN winlost > actual_stake THEN 112
				WHEN winlost < actual_stake THEN 111
				ELSE 113 END
		WHERE transid = @transid

		UPDATE dbo.bettransRnG14 WITH (ROWLOCK, UPDLOCK)
		SET RefNo = @transid
		WHERE transid = @transidRnG

		-- sum_winloss
		;WITH tmp_sum_winloss AS
		(
			SELECT
				@custid AS custid, @recommend AS recommend, @mrecommend AS mrecommend, @srecommend AS srecommend,
				@stake AS turnover, 1 AS betcount,
				@winlost AS winlost, @awinlost AS awinlost, @mwinlost AS mwinlost, @swinlost AS swinlost,
				@playercomm AS playercomm, @comm AS comm, @acomm AS acomm, @scomm AS scomm,
				CASE WHEN @statusID = 111 THEN 0 ELSE @stake END AS turnoverNoDraw
		)
		MERGE dbo.sum_winloss AS s
		USING (
			SELECT custid, roleId, recommend, mrecommend, srecommend, @winlostdate AS winlostdate, @sporttype AS sporttype,
				turnover, betcount, winlost, awinlost, mwinlost, swinlost, playercomm, comm, acomm, scomm, turnoverNoDraw
			FROM (
				SELECT custid, 1 AS roleId, recommend, mrecommend, srecommend,
					turnover, betcount, winlost, awinlost, mwinlost, swinlost,
					playercomm, comm, acomm, scomm, turnoverNoDraw
				FROM tmp_sum_winloss
				UNION ALL
				SELECT recommend, 2 AS roleId, @recommend, @mrecommend, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
					SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(turnoverNoDraw)
				FROM tmp_sum_winloss
				GROUP BY recommend
				UNION ALL
				SELECT mrecommend, 3 AS roleId, 0, @mrecommend, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
					SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(turnoverNoDraw)
				FROM tmp_sum_winloss
				GROUP BY mrecommend
				UNION ALL
				SELECT srecommend, 4 AS roleId, 0, 0, @srecommend,
					SUM(turnover), SUM(betcount), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost),
					SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm), SUM(turnoverNoDraw)
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
				s.playercomm = s.playercomm + src.playercomm,
				s.comm = s.comm + src.comm,
				s.acomm = s.acomm + src.acomm,
				s.scomm = s.scomm + src.scomm,
				s.TunroverNoDraw = s.TunroverNoDraw + src.turnoverNoDraw
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
				src.betcount,0,src.sporttype,0,0,turnoverNoDraw
			);
	END
	ELSE -- bettrans_bk
	BEGIN
		SELECT 'bettrans_bk'

		DECLARE @list_transidRnG VARCHAR(MAX)

		SELECT  @list_transidRnG = CONVERT(VARCHAR(MAX), @transidRnG)

		EXEC DBARC.bodb_Archive.dbo.DBA_ArchiveTickets
			@transids = '',
			@transidsRnG = @list_transidRnG,
			@isSumbettrans = 1

		-- sum_winloss_old
		EXEC DBAGE.bodb_Summary.dbo.DBA_sum_winloss_old_Ins
			@transidsRnG	= @list_transidRnG,
			@recommend		= @recommend,
			@mrecommend		= @mrecommend,
			@srecommend		= @srecommend,
			@winlostdate	= @winlostdate,
			@sporttype		= @sporttype

		DELETE dbo.bettransRnG WITH (ROWLOCK, UPDLOCK)
		WHERE transid = @transidRnG
	END
END
GO
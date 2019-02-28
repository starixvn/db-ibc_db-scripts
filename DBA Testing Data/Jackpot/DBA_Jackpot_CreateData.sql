USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_Jackpot_CreateData]
	@CustId					INT,
	-- for main ticket
	@GameType				TINYINT = 1,
	@Status					VARCHAR(100) = 'running',
	@Stake					MONEY = 100,
	@betStake				MONEY = 1, -- stake of jackpot game
	@contributionRate		FLOAT = 0.005,
	@winlostdate			SMALLDATETIME = NULL,
	-- pt
	@apositiontaking		MONEY = 0.4,
	@mpositiontaking		MONEY = 0.3,
	@spositiontaking		MONEY = 0.2,
	-- for jackpot game
	@WinningJackpotType		TINYINT = 0,
	@WinningJackpotAmount	MONEY = 123456789000,
	@WinningJackpotStatus	VARCHAR(100) = 'Completed'
AS

/*
	Created by Percy
	Date: 2017-01-08
	DB: DB206.bodb02
	Task: Create data for Jackpot

	Param's Explanation:
		@GameType: PC/Mobile/Tablet
			1: PC
			2: Mobile
			3: Tablet
		@Status: for main ticket: running, WON, LOSE, DRAW
		@WinningJackpotType: for Jackpot game
			0: not win
			1 --> 6: Fixed Prize:
				1: Natural 6 - 10x
				2: Natural 7 - 15x
				3: Natural 8 - 20x
				4: Natural 9 - 25x
				5: Player & Banker Ace +8 - 1,000x
				6: Player suited Ace +8 / Banker suited Ace +8 - 10,000x
			7: Mega Jackpot
		@WinningJackpotAmount: for mega jackpot
		@WinningJackpotStatus: for mega jackpot
			Open, Verified, Disbursed, Completed, Expired, Cancelled
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @tpositiontaking MONEY
	SELECT  @tpositiontaking = @apositiontaking + @mpositiontaking + @spositiontaking

	IF @tpositiontaking > 1
	BEGIN
		SELECT 'Invalid PT'
		RETURN
	END

	DECLARE @username VARCHAR(50), @recommend INT, @mrecommend INT, @srecommend INT, @currency INT, @actualrate FLOAT, @isDeposit BIT

	SELECT
		@username = c.username,
		@recommend = c.recommend,
		@mrecommend = c.mrecommend,
		@srecommend = c.srecommend,
		@currency = c.currency,
		@isDeposit = CASE WHEN s.custid IS NULL THEN 0 ELSE 1 END
	FROM CustDB.dbo.custInfo c WITH (NOLOCK)
		LEFT JOIN CustDB.dbo.Dep_CustSuper s WITH (NOLOCK) ON c.srecommend = s.custid
	WHERE c.custid = @CustId AND c.roleid = 1

	IF @@ROWCOUNT = 0
	BEGIN
		SELECT 'Invalid member'
		RETURN
	END


	SELECT @actualrate = actualrate
	FROM dbo.exchange WITH (NOLOCK)
	WHERE exchangeid = @currency

	DECLARE @main_bettype INT, @jackpot_bettype INT, @contribution_bettype INT, @megaJackpot_bettype INT, @sporttype INT

	/* sporttype */
	-- 2101:2199 --> 208
	-- 2201:2299 --> 209
	-- 2301:2399 --> 210
	-- 2901:2999 --> 210

	IF @GameType = 1
		SELECT @main_bettype = 2178, @jackpot_bettype = 2179, @contribution_bettype = 2198, @megaJackpot_bettype = 2199, @sporttype = 208
	ELSE IF @GameType = 2
		SELECT @main_bettype = 2319, @jackpot_bettype = 2320, @contribution_bettype = 2398, @megaJackpot_bettype = 2399, @sporttype = 210
	ELSE
		SELECT @main_bettype = 2919, @jackpot_bettype = 2920, @contribution_bettype = 2998, @megaJackpot_bettype = 2999, @sporttype = 210

	DECLARE @main_transdesc NVARCHAR(2000), @jackpot_transdesc NVARCHAR(2000), @contribution_transdesc NVARCHAR(2000), @megaJackpot_transdesc NVARCHAR(2000)

	DECLARE @WinningJackpotStatusId TINYINT

	SELECT
		@main_transdesc = CASE WHEN GameType2 = CONVERT(VARCHAR(2000), @main_bettype) THEN RefResourceId ELSE @main_transdesc END,
		@jackpot_transdesc = CASE WHEN GameType2 = CONVERT(VARCHAR(2000), @jackpot_bettype) THEN RefResourceId ELSE @jackpot_transdesc END,
		@contribution_transdesc = CASE WHEN GameType2 = CONVERT(VARCHAR(2000), @contribution_bettype) THEN RefResourceId ELSE @contribution_transdesc END,
		@megaJackpot_transdesc = CASE WHEN GameType2 = CONVERT(VARCHAR(2000), @megaJackpot_bettype) THEN RefResourceId ELSE @megaJackpot_transdesc END
	FROM dbo.GameListRNG WITH (NOLOCK)
	WHERE GameType2 IN
		(
			CONVERT(VARCHAR(2000), @main_bettype), CONVERT(VARCHAR(2000), @jackpot_bettype),
			CONVERT(VARCHAR(2000), @contribution_bettype), CONVERT(VARCHAR(2000), @megaJackpot_bettype)
		)
	 
	-- winlostdate range
	DECLARE @MBDate SMALLDATETIME, @BUDate SMALLDATETIME
	SELECT  @winlostdate = ISNULL(@winlostdate, CONVERT(DATE, GETDATE()))
	SELECT  @MBDate = MAX(eventdate) FROM dbo.match14 WITH (NOLOCK)
	SELECT  TOP 1 @BUDate = winlostdate FROM dbo.bettrans WITH (NOLOCK) WHERE custid = 3 AND matchid = 0 AND bettype = 20000

	DECLARE @transid TABLE (transid BIGINT, bettype INT)
	DECLARE @transidRnG TABLE (transid BIGINT, bettype INT)

	-- insert into bettrans
	IF @status = 'running' AND @winlostdate <= @MBDate
	BEGIN
		SELECT 'Status param not match with winlostdate param. Creating ticket failed!'
		RETURN
	END

	IF @status NOT IN ('running','WON','LOSE','DRAW','Refund')
	BEGIN
		SELECT 'Status param should be running/WON/LOSE/DRAW/Refund. Creating ticket failed!'
		RETURN
	END

	IF @WinningJackpotType = 7 AND @WinningJackpotStatus NOT IN ('Open', 'Verified', 'Disbursed', 'Completed', 'Expired', 'Cancelled')
	BEGIN
		SELECT 'Status of winning jackpot should be Open/Verified/Disbursed/Completed/Expired/Cancelled. Creating ticket failed!'
		RETURN
	END

	IF @status = 'running'
	BEGIN
		INSERT INTO dbo.bettransRnG
		(
			custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,tpositiontaking,spositiontaking,
			playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,actual_stake,
			currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,transdesc,productID,gameID,
			vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			Transdate3rd,SiteID,Additional,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		)
		OUTPUT INSERTED.transid, INSERTED.gameID
			INTO @transidRnG (transid, bettype)
		SELECT
			@custId,GETDATE(),0,stake,'running',@apositiontaking,@mpositiontaking,@tpositiontaking,@spositiontaking,
			0,0,0,0,8,@winlostdate,'i',@actualrate,@actualrate,stake,
			@currency,'',@recommend,@mrecommend,@srecommend,'',0,1000,@username,transdesc,@sporttype,bettype,
			0,0,0,0,0,0,0,0,0,0,0,0,0,
			GETDATE(),0,Additional,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		FROM (
			-- jackpot
			SELECT
				@betStake AS stake,
				@jackpot_bettype AS bettype, 'ForcedCompleted=0*ReasonCode=0*RemainingAmount=0*BuyAmount=0*JPType=0' AS Additional,
				'jp=0' AS JackpotInfo, 0 AS RefNo2, @contributionRate AS ContributionRate,@betStake AS BetStake,@betStake*@contributionRate AS ContributionStake3rd,
				@jackpot_transdesc AS transdesc
			-- main ticket
			UNION ALL
			SELECT
				@stake,
				@main_bettype,NULL,NULL,NULL,NULL,NULL,NULL,
				@main_transdesc
		) AS A

		MERGE dbo.bettrans AS s
		USING (
			SELECT b.custid, b.winlostdate, b.gameID, b.productID, b.stake, b.actual_stake, b.transdesc, b.BetStake, b.ContributionStake3rd
			FROM dbo.bettransRnG b WITH (NOLOCK)
			WHERE EXISTS (SELECT 1 FROM @transidRnG t WHERE b.transid = t.transid)
		) AS src
			ON s.custid = src.custid AND s.winlostdate = src.winlostdate AND s.bettype = src.gameID AND s.matchid = src.productID
		WHEN NOT MATCHED THEN
			INSERT
			(
				custid,transdate,oddsid,hdp1,hdp2,odds,stake,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,
				mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,
				creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid,recommend,mrecommend,ruben,betid,
				statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,sdiscount,scomm,spositiontaking,swinlost,srecommend,
				virtualrate,Username,CurrencyName,oddstype,currency2,balance,SecAcceptFlag,transid2,status,statusID
			)
			VALUES
			(
				src.custid,GETDATE(),0,0,@contributionRate,0,src.stake,0,0,0,0,0,0,@apositiontaking,
				@mpositiontaking,@tpositiontaking,0,0,0,0,0,0,0,
				8,100000000000,'',src.winlostdate,'i','',GETDATE(),1,src.BetStake,src.productID,@recommend,@mrecommend,0,src.ContributionStake3rd*100000000,
				'',0,src.gameID,0,src.actual_stake,@currency,'',src.transdesc,0,0,@spositiontaking,0,@srecommend,
				@actualrate,@username,'',0,0,100000,1,1,'running',0
			)
		OUTPUT INSERTED.transid, INSERTED.bettype
			INTO @transid (transid, bettype);

		UPDATE b WITH (ROWLOCK, UPDLOCK)
		SET b.refno = t.transid
		FROM dbo.bettransRnG b
			INNER JOIN @transidRnG tr ON b.transid = tr.transid
			INNER JOIN @transid t ON tr.bettype = t.bettype
	END
	ELSE
	BEGIN
		-- main ticket and jackpot ticket
		INSERT INTO dbo.bettransRnG
		(
			custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,tpositiontaking,spositiontaking,
			playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,actual_stake,
			currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,transdesc,productID,gameID,
			vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			Transdate3rd,SiteID,Additional,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		)
		OUTPUT INSERTED.transid, INSERTED.gameID
			INTO @transidRnG (transid, bettype)
		SELECT
			@custId,GETDATE(),0,stake,status,@apositiontaking,@mpositiontaking,@tpositiontaking,@spositiontaking,
			0,0,0,0,8,@winlostdate,'i',@actualrate,@actualrate,stake,
			@currency,'',@recommend,@mrecommend,@srecommend,'',statusID,1000,@username,transdesc,@sporttype,bettype,
			0,0,0,0,1,winlost,0,0,0,0,0,0,0,
			GETDATE(),0,Additional,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		FROM (
			-- jackpot
			SELECT
				@betStake AS stake, CASE WHEN @WinningJackpotType IN (0,5,6,7) THEN 'LOSE' ELSE 'WON' END AS status,
				CASE WHEN @WinningJackpotType IN (0,5,6,7) THEN 113 ELSE 112 END AS statusID,
				@jackpot_bettype AS bettype, 'ForcedCompleted=0*ReasonCode=0*RemainingAmount=0*BuyAmount=0*JPType=0' AS Additional,
				'jp=0' AS JackpotInfo, 0 AS RefNo2, @contributionRate AS ContributionRate,@betStake AS BetStake,@betStake*@contributionRate AS ContributionStake3rd,
				CASE @WinningJackpotType
					WHEN 1 THEN 10 + 1
					WHEN 2 THEN 15 + 1
					WHEN 3 THEN 20 + 1
					WHEN 4 THEN 25 + 1
					WHEN 5 THEN 1000 + 1
					WHEN 6 THEN 10000 + 1
					ELSE 0 -- LOSE or WON over 200k
					END AS winlost,
				@jackpot_transdesc AS transdesc
			-- main ticket
			UNION ALL
			SELECT
				@stake, @status,
				CASE @status WHEN 'WON' THEN 112 WHEN 'DRAW' THEN 111 WHEN 'LOSE' THEN 113 WHEN 'Refund' THEN 103 END,
				@main_bettype,NULL,NULL,NULL,NULL,NULL,NULL,
				@stake * CASE @status WHEN 'WON' THEN 2 WHEN 'DRAW' THEN 1 WHEN 'LOSE' THEN 0 WHEN 'Refund' THEN 1 END,
				@main_transdesc
			-- contribution ticket
			UNION ALL
			SELECT
				0,'DRAW',
				111,
				@contribution_bettype, 'ForcedCompleted=0*ReasonCode=0*RemainingAmount=0*BuyAmount=0*JPType=0',
				'', 0, @contributionRate, @betStake,@betStake*@contributionRate,
				0,
				@contribution_transdesc
			-- progressive jackpot
			UNION ALL
			SELECT
				0,'WON',
				112,
				@megaJackpot_bettype, NULL,
				'', 0, @contributionRate, @betStake AS BetStake,@betStake*@contributionRate,
				CASE WHEN @WinningJackpotAmount > 200000 THEN 0 ELSE @WinningJackpotAmount END,
				@megaJackpot_transdesc
			WHERE @WinningJackpotType = 7
		) AS A

		IF @isDeposit = 1
			UPDATE b WITH (ROWLOCK, UPDLOCK)
			SET b.apositiontaking = 1, b.mpositiontaking = 0, b.spositiontaking = 0, b.tpositiontaking = 1
			FROM dbo.bettransRnG b
				INNER JOIN @transidRnG tr ON b.transid = tr.transid
			WHERE tr.bettype = @contribution_bettype

		UPDATE b WITH (ROWLOCK, UPDLOCK)
		SET b.apositiontaking = 0, b.mpositiontaking = 0, b.spositiontaking = 0, b.tpositiontaking = 0
		FROM dbo.bettransRnG b
			INNER JOIN @transidRnG tr ON b.transid = tr.transid
		WHERE tr.bettype = @megaJackpot_bettype

		UPDATE b WITH (ROWLOCK, UPDLOCK)
		SET b.awinlost = b.apositiontaking * CASE b.statusID WHEN 112 THEN b.actual_stake-b.winlost WHEN 113 THEN b.stake ELSE 0 END,
			b.mwinlost = b.mpositiontaking * CASE b.statusID WHEN 112 THEN b.actual_stake-b.winlost WHEN 113 THEN b.stake ELSE 0 END,
			b.swinlost = b.spositiontaking * CASE b.statusID WHEN 112 THEN b.actual_stake-b.winlost WHEN 113 THEN b.stake ELSE 0 END
		FROM dbo.bettransRnG b
			INNER JOIN @transidRnG t ON b.transid = t.transid
		WHERE t.bettype <> @contribution_bettype

		UPDATE b WITH (ROWLOCK, UPDLOCK)
		SET b.awinlost = -b.apositiontaking * ContributionStake3rd,
			b.mwinlost = -b.mpositiontaking * ContributionStake3rd,
			b.swinlost = -b.spositiontaking * ContributionStake3rd
		FROM dbo.bettransRnG b
			INNER JOIN @transidRnG t ON b.transid = t.transid
		WHERE t.bettype = @contribution_bettype

		DECLARE @RefNo2_Jackpot BIGINT, @RefNo2_Contribution BIGINT, @RefNo2_Megajackpot BIGINT

		SELECT
			@RefNo2_Jackpot = CASE WHEN bettype = @contribution_bettype THEN transid ELSE @RefNo2_Jackpot END,
			@RefNo2_Contribution = CASE WHEN bettype = @jackpot_bettype THEN transid ELSE @RefNo2_Contribution END,
			@RefNo2_Megajackpot = CASE WHEN bettype = @jackpot_bettype THEN transid ELSE @RefNo2_Megajackpot END
		FROM @transidRnG
		
		UPDATE b WITH (ROWLOCK, UPDLOCK)
		SET b.RefNo2 = CASE b.gameID
			WHEN @jackpot_bettype THEN @RefNo2_Jackpot
			WHEN @contribution_bettype THEN @RefNo2_Contribution
			WHEN @megaJackpot_bettype THEN @RefNo2_Megajackpot
			ELSE b.RefNo2 END
		FROM dbo.bettransRnG b
			INNER JOIN @transidRnG t ON b.transid = t.transid

		IF @WinningJackpotType = 7
		BEGIN
			DECLARE @jackpot_transid BIGINT
			SELECT  @jackpot_transid = transid FROM @transidRnG WHERE bettype = @megaJackpot_bettype

			UPDATE b WITH (ROWLOCK, UPDLOCK)
			SET b.JackpotInfo = 'jp=1,jpw=' + CONVERT(VARCHAR(20), @jackpot_transid)
			FROM dbo.bettransRnG b
				INNER JOIN @transidRnG t ON b.transid = t.transid
			WHERE t.bettype = @jackpot_bettype

			SELECT @WinningJackpotStatusId = CASE @WinningJackpotStatus
				WHEN 'Open' THEN 1
				WHEN 'Verified' THEN 2
				WHEN 'Disbursed' THEN 3
				WHEN 'Completed' THEN 4
				WHEN 'Expired' THEN 5
				WHEN 'Cancelled' THEN 6
				ELSE 0 END
		END

		MERGE dbo.bettrans AS s
		USING (
			SELECT b.custid, b.winlostdate, b.gameID, b.productID, b.transdesc,
				b.apositiontaking, b.mpositiontaking, b.spositiontaking, b.tpositiontaking,
				SUM(b.stake) AS stake,
				SUM(b.winlost) AS winlost,
				SUM(b.actual_stake) AS actual_stake,
				SUM(b.awinlost) AS awinlost,
				SUM(b.mwinlost) AS mwinlost, SUM(b.swinlost) AS swinlost,
				SUM(ISNULL(b.ContributionStake3rd, 0)) AS ContributionStake3rd,
				SUM(ISNULL(b.BetStake, 0)) AS BetStake
			FROM dbo.bettransRnG b WITH (NOLOCK)
			WHERE EXISTS (SELECT 1 FROM @transidRnG t WHERE b.transid = t.transid)
			GROUP BY b.custid, b.winlostdate, b.gameID, b.productID, b.transdesc,
				b.apositiontaking, b.mpositiontaking, b.spositiontaking, b.tpositiontaking
		) AS src
			ON s.custid = src.custid AND s.winlostdate = src.winlostdate AND s.bettype = src.gameID AND s.matchid = src.productID
		WHEN MATCHED THEN
			UPDATE SET
				s.stake = s.stake + src.stake,
				s.actual_stake = s.actual_stake + src.actual_stake,
				s.winlost = s.winlost + src.winlost,
				s.awinlost = s.awinlost + src.awinlost,
				s.mwinlost = s.mwinlost + src.mwinlost,
				s.swinlost = s.swinlost + src.swinlost,
				s.betid = s.betid + src.ContributionStake3rd*100000000,
				s.oddsspread = s.oddsspread + src.BetStake
		WHEN NOT MATCHED THEN
			INSERT
			(
				custid,transdate,oddsid,hdp1,hdp2,odds,stake,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,
				mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,
				creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid,recommend,mrecommend,ruben,betid,
				statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,sdiscount,scomm,spositiontaking,swinlost,srecommend,
				virtualrate,Username,CurrencyName,oddstype,currency2,balance,SecAcceptFlag,transid2
			)
			VALUES
			(
				src.custid,GETDATE(),0,0,0,@contributionRate,src.stake,src.winlost,src.awinlost,src.mwinlost,0,0,0,src.apositiontaking,
				src.mpositiontaking,src.tpositiontaking,0,0,0,0,0,0,'',
				8,100000000000,'',src.winlostdate,'i','',GETDATE(),src.BetStake,@actualrate,src.productID,@recommend,@mrecommend,1,src.ContributionStake3rd*100000000,
				'',0,src.gameID,0,src.actual_stake,@currency,'',src.transdesc,0,0,src.spositiontaking,src.swinlost,@srecommend,
				@actualrate,@username,'',0,0,100000,1,1
			)
		OUTPUT INSERTED.transid, INSERTED.bettype
			INTO @transid (transid, bettype);

		UPDATE b WITH (ROWLOCK, UPDLOCK)
		SET b.status = CASE WHEN b.winlost-b.actual_stake = 0 THEN 'DRAW' WHEN b.winlost-b.actual_stake > 0 THEN 'WON' ELSE 'LOSE' END,
			b.statusID = CASE WHEN b.winlost-b.actual_stake = 0 THEN 111 WHEN b.winlost-b.actual_stake > 0 THEN 112 ELSE 113 END
		FROM dbo.bettrans b
			INNER JOIN @transid t ON b.transid = t.transid

		UPDATE b WITH (ROWLOCK, UPDLOCK)
		SET b.refno = t.transid
		FROM dbo.bettransRnG b
			INNER JOIN @transidRnG tr ON b.transid = tr.transid
			INNER JOIN @transid t ON tr.bettype = t.bettype
	END

	-- bettrans_bk
	IF @winlostdate < @BUDate
	BEGIN
		DECLARE @list_transid VARCHAR(MAX), @list_transidRnG VARCHAR(MAX)

		SELECT  @list_transid = (SELECT ',' + CONVERT(VARCHAR(20), transid) FROM @transid FOR XML PATH (''))
		SELECT  @list_transidRnG = (SELECT ',' + CONVERT(VARCHAR(20), transid) FROM @transidRnG FOR XML PATH (''))

		-- bettrans_bk
		EXEC DBARC.bodb_Archive.dbo.DBA_ArchiveTickets
			@transids = @list_transid,
			@transidsRnG = @list_transidRnG

		-- sum_winloss_old
		EXEC DBAGE.bodb_Summary.dbo.DBA_sum_winloss_old_Ins
			@transids		= @list_transid,
			@recommend		= @recommend,
			@mrecommend		= @mrecommend,
			@srecommend		= @srecommend,
			@winlostdate	= @winlostdate,
			@sporttype		= @sporttype

		-- delete data
		DELETE b WITH (ROWLOCK, UPDLOCK)
		FROM dbo.bettrans b
			INNER JOIN @transid t ON b.transid = t.transid

		DELETE b WITH (ROWLOCK, UPDLOCK)
		FROM dbo.bettransRnG b
			INNER JOIN @transidRnG tr ON b.transid = tr.transid
	END
	-- bettrans14
	ELSE IF @winlostdate <= @MBDate
	BEGIN
		INSERT INTO dbo.bettransRnG14
		(
			transid,custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,tpositiontaking,spositiontaking,
			playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,actual_stake,
			currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,transdesc,productID,gameID,
			vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			Transdate3rd,SiteID,Additional,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		)
		SELECT
			transid,custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,tpositiontaking,spositiontaking,
			playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,actual_stake,
			currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,transdesc,productID,gameID,
			vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			Transdate3rd,SiteID,Additional,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		FROM dbo.bettransRnG b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @transidRnG t WHERE b.transid = t.transid)

		INSERT INTO dbo.bettrans14
		(
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,
			mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,
			creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid,recommend,mrecommend,ruben,betid,
			statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,sdiscount,scomm,spositiontaking,swinlost,srecommend,
			virtualrate,Username,CurrencyName,oddstype,currency2,balance,SecAcceptFlag,transid2,status,statusID
		)
		SELECT
			transid,custid,transdate,oddsid,hdp1,hdp2,odds,stake,winlost,awinlost,mwinlost,playercomm,comm,acomm,apositiontaking,
			mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,livehomescore,liveawayscore,liveindicator,betteam,
			creator,refno,comstatus,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid,recommend,mrecommend,ruben,betid,
			statuswinlost,modds,bettype,betdaqid,actual_stake,currency,ip,transdesc,sdiscount,scomm,spositiontaking,swinlost,srecommend,
			virtualrate,Username,CurrencyName,oddstype,currency2,balance,SecAcceptFlag,transid2,status,statusID
		FROM dbo.bettrans b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM @transid t WHERE b.transid = t.transid)

		-- sum_winloss
		;WITH tmp_sum_winloss AS
		(
			SELECT
				b.custid,b.recommend,b.mrecommend,b.srecommend,
				SUM(b.stake) AS turnover, COUNT(b.transid) AS betcount,
				SUM(b.winlost) AS winlost, SUM(b.awinlost) AS awinlost, SUM(b.mwinlost) AS mwinlost, SUM(b.swinlost) AS swinlost,
				SUM(CASE WHEN statusID = 111 THEN 0 ELSE b.stake END) AS turnoverNoDraw
			FROM dbo.bettrans b WITH (NOLOCK)
			WHERE EXISTS (SELECT 1 FROM @transid t WHERE b.transid = t.transid)
			GROUP BY b.custid,b.recommend,b.mrecommend,b.srecommend
		)
		MERGE dbo.sum_winloss AS s
		USING (
			SELECT custid, roleId, recommend, mrecommend, srecommend, @winlostdate AS winlostdate, @sporttype AS sporttype,
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

		-- delete data
		DELETE b WITH (ROWLOCK, UPDLOCK)
		FROM dbo.bettrans b
			INNER JOIN @transid t ON b.transid = t.transid

		DELETE b WITH (ROWLOCK, UPDLOCK)
		FROM dbo.bettransRnG b
			INNER JOIN @transidRnG tr ON b.transid = tr.transid
	END

	IF @status NOT IN ('running','Refund') AND @WinningJackpotType IN (7) AND @WinningJackpotAmount > 200000
	BEGIN
		DECLARE @amount MONEY, @payout_Refno BIGINT
		SELECT  @amount = @WinningJackpotAmount

		SELECT  @payout_Refno = transid FROM @transidRnG WHERE bettype = @megaJackpot_bettype

		INSERT INTO dbo.PayoutTrans	(CustId,UserName,RefNo,ProductId,VendorId,TransDate,WinlostDate,WinAmount,PayoutCode,PayoutStatusId,PayoutStatus,GameId,RetryCount)
		VALUES (@custId,@username,@payout_Refno,@sporttype,10,GETDATE(),@winlostdate,@amount,'',@WinningJackpotStatusId,@WinningJackpotStatus,@jackpot_bettype,0)
	END
END
GO
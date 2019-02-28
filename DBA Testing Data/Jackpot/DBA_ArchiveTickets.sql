USE [bodb_Archive]
GO

ALTER PROCEDURE [dbo].[DBA_ArchiveTickets]
	@transids		VARCHAR(MAX) = '',
	@transidsRnG	VARCHAR(MAX) = '',
	@isSumbettrans	BIT = 0,
	@matchid		INT = NULL
AS

/*
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @transid_bk BIGINT, @custid INT, @winlostdate SMALLDATETIME, @bettype INT

	DECLARE @winlost_s MONEY, @awinlost_s MONEY, @mwinlost_s MONEY, @swinlost_s MONEY,
			@stake_s MONEY, @actual_stake_s MONEY,
			@playerdiscount_s MONEY, @discount_s MONEY, @adiscount_s MONEY, @sdiscount_s MONEY,
			@playercomm_s MONEY, @comm_s MONEY, @acomm_s MONEY, @scomm_s MONEY

	-- bettrans
	IF ISNULL(@transids, '') <> ''
	BEGIN
		INSERT INTO dbo.bettrans_bk
		(
			custid,transdate,oddsid,hdp1,hdp2,odds,stake,actual_stake,status,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			apositiontaking,mpositiontaking,spositiontaking,tpositiontaking,playerdiscount,discount,adiscount,sdiscount,
			livehomescore,liveawayscore,liveindicator,betteam,creator,refno,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid,
			recommend,mrecommend,srecommend,ruben,betid,statuswinlost,modds,betdaqid,currency,ip,transdesc,virtualrate,oddstype,statusID,currency2,
			transid,bettype,balance,transid2,SecAcceptFlag,comstatus,ExtraInfo,WalletType,BonusID,RefCode
		)
		SELECT
			custid,transdate,oddsid,hdp1,hdp2,odds,stake,actual_stake,status,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			apositiontaking,mpositiontaking,spositiontaking,tpositiontaking,playerdiscount,discount,adiscount,sdiscount,
			livehomescore,liveawayscore,liveindicator,betteam,creator,refno,winlostdate,betfrom,betcheck,checktime,oddsspread,actualrate,matchid,
			recommend,mrecommend,srecommend,ruben,betid,statuswinlost,modds,betdaqid,currency,ip,transdesc,virtualrate,oddstype,statusID,currency2,
			transid,bettype,balance,transid2,SecAcceptFlag,comstatus,ExtraInfo,WalletType,BonusID,RefCode
		FROM DBTXN.bodb02.dbo.bettrans b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM dbo.strSplit(@transids, ',') t WHERE b.transid = t.val)
	END

	-- bettransRnG_bk
	IF ISNULL(@transidsRnG, '') <> ''
	BEGIN
		INSERT INTO dbo.bettransRnG_bk
		(
			transid,custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,tpositiontaking,spositiontaking,
			playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,actual_stake,
			currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,transdesc,productID,gameID,
			vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			Transdate3rd,Additional,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		)
		SELECT
			transid,custid,transdate,odds,stake,status,apositiontaking,mpositiontaking,tpositiontaking,spositiontaking,
			playerdiscount,discount,adiscount,sdiscount,creator,winlostdate,betfrom,virtualrate,actualrate,actual_stake,
			currency,CurrencyName,recommend,mrecommend,srecommend,ip,statusID,balance,Username,transdesc,productID,gameID,
			vendorID,GameId3rd,TranId3rd,RefNo,IsSum,winlost,awinlost,mwinlost,swinlost,playercomm,comm,acomm,scomm,
			Transdate3rd,Additional,JackpotInfo,RefNo2,ContributionRate,BetStake,ContributionStake3rd
		FROM DBTXN.bodb02.dbo.bettransRnG b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM dbo.strSplit(@transidsRnG, ',') t WHERE b.transid = t.val)
	END

	IF @matchid IS NOT NULL
	BEGIN
		DELETE dbo.match_bk WITH (ROWLOCK, UPDLOCK) WHERE matchid = @matchid
		
		INSERT INTO dbo.match_bk
		(
			[matchid], [leagueid], [homeid], [awayid],[eventdate], [eventstatus],
			[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
			[creator], [matchcode], [kickofftime], [closedtime], [showtime],
			[hthomescore], [htawayscore], [ruben], [multiple],
			[sporttype], [IsNeutral], [GlobalShowTime], [ParentID]
		)
		SELECT
			[matchid], [leagueid], [homeid], [awayid],[eventdate], [eventstatus],
			[livehomescore], [liveawayscore], [finalhomescore], [finalawayscore],
			[creator], [matchcode], [kickofftime], [closedtime], [showtime],
			[hthomescore], [htawayscore], [ruben], [multiple],
			[sporttype], [IsNeutral], [GlobalShowTime], [ParentID]
		FROM DBTXN.bodb02.dbo.match WITH(NOLOCK) WHERE matchid = @matchId

		DELETE dbo.ResultDetail_BK WITH (ROWLOCK, UPDLOCK) WHERE MatchId = @matchid

		INSERT INTO dbo.ResultDetail_BK
		(
			MatchId,ResourceId,HomeValue,AwayValue,ResultStatusID,SettlementStatusID,
			CreateDate,LastModifyDate,CreateBy,LastModifyBy,OtherInfo
		)
		SELECT
			MatchId,ResourceId,HomeValue,AwayValue,ResultStatusID,SettlementStatusID,
			CreateDate,LastModifyDate,CreateBy,LastModifyBy,OtherInfo
		FROM DBTXN.bodb02.dbo.ResultDetail WITH (NOLOCK)
		WHERE matchid = @matchid
	END

	IF @isSumbettrans = 1
	BEGIN
		SELECT TOP 1 @custid = custid, @winlostdate = winlostdate, @bettype = gameId
		FROM DBTXN.bodb02.dbo.bettransRnG b WITH (NOLOCK)
		WHERE EXISTS (SELECT 1 FROM dbo.strSplit(@transidsRnG, ',') t WHERE b.transid = t.val)

		SELECT @transid_bk = transid FROM dbo.bettrans_bk WITH (NOLOCK)
		WHERE custid = @custid AND winlostdate = @winlostdate AND bettype = @bettype

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
		FROM dbo.bettransRnG_bk b WITH (NOLOCK)
		WHERE custid = @custid AND winlostdate = @winlostdate AND gameID = @bettype

		IF @transid_bk IS NOT NULL
		BEGIN
			UPDATE dbo.bettrans_bk WITH (ROWLOCK, UPDLOCK)
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
				scomm = @scomm_s
			WHERE transid = @transid_bk
		END
		ELSE
		BEGIN
			SELECT @transid_bk = bodb02.dbo.f_GetMinTransId()

			INSERT INTO dbo.bettrans_bk
			(
				transid,custid,transdate,odds,stake,status,winlost,awinlost,mwinlost,playercomm,comm,acomm,
				apositiontaking,mpositiontaking,tpositiontaking,playerdiscount,discount,adiscount,
				liveindicator,creator,refno,winlostdate,betfrom,actualrate,matchid,recommend,mrecommend,
				ruben,bettype,actual_stake,currency,ip,transdesc,sdiscount,scomm,spositiontaking,
				swinlost,srecommend,virtualrate,statusID,balance,oddsid
			)
			SELECT
				@transid_bk,@custid,transdate,odds,@stake_s,status,@winlost_s,@awinlost_s,@mwinlost_s,@playercomm_s,@comm_s,@acomm_s,
				apositiontaking,mpositiontaking,tpositiontaking,@playerdiscount_s,@discount_s,@adiscount_s,
				0,8,0,@winlostdate,'d',actualrate,productID,recommend,mrecommend,
				1,gameId,@actual_stake_s,currency,'',CONVERT(VARCHAR(20), @bettype),@sdiscount_s,@scomm_s,spositiontaking,
				@swinlost_s,srecommend,actualrate,statusID,0,0
			FROM dbo.bettransRnG_bk b WITH (NOLOCK)
			WHERE custid = @custid AND winlostdate = @winlostdate AND gameID = @bettype
		END

		UPDATE dbo.bettrans_bk WITH (ROWLOCK, UPDLOCK)
		SET
			status = CASE
				WHEN winlost > actual_stake THEN 'WON'
				WHEN winlost < actual_stake THEN 'LOSE'
				ELSE 'DRAW' END,
			statusID = CASE
				WHEN winlost > actual_stake THEN 112
				WHEN winlost < actual_stake THEN 111
				ELSE 113 END
		WHERE transid = @transid_bk

		UPDATE b
		SET RefNo = @transid_bk
		FROM dbo.bettransRnG_bk b WITH (ROWLOCK, UPDLOCK)
		WHERE EXISTS (SELECT 1 FROM dbo.strSplit(@transidsRnG, ',') t WHERE b.transid = t.val)
	END
END
GO
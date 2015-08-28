USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[proc_DataSample_MO_Betticket]    Script Date: 8/27/2015 10:38:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DataSample_CB_BetTicket_Ins]
--DECLARE
	@CustID INT
	,@Bettype INT
	,@status VARCHAR(100) = 'RUNNING'
	,@refno BIGINT = 0
	
AS 
/*
Task:#40294 - Integration Collosus Bet product
Creator:20150827@bobby.nguyen
Params:
	- @Bettype: 18001,18002,18003,18004,18005
		+ 18000: Colossus Bet (SUM Bet)	- RUNNING|WON|LOSE 
		+ 18001: Pool Bet				- RUNNING|LOSE
		+ 18002: Cash-Out				- WON  
		+ 18003: Winning Share			- LOSE
		+ 18004: Consolation Prize		- WON
		+ 18005: Jackpot Prize			- WON
	- @refno: translog.translogid. Idicating a Cash-Out, Consolation, Jackpot ticket will belong to what CB's bet ticket.
	
*/
BEGIN
	SET NOCOUNT ON;

	--SELECT @CustID		= 2723431
	--	, @Bettype		= 18000, @status = 'LOSE'
	--	, @refno		= 1000000001090

	SELECT @Bettype = CASE WHEN @Bettype = 18000 THEN 18001 ELSE @Bettype END
		, @status	= UPPER(@status)

	IF(@Bettype NOT BETWEEN 18000 AND 18005)
	BEGIN
		SELECT 'Opps! Bettype is invalid.' AS Warning
		GOTO FINAL_CHECK;
	END

	-- pool bettype
	IF(@Bettype IN (18000, 18001) AND @status NOT IN ('RUNNING', 'WON', 'LOSE'))
	BEGIN
		SELECT 'Opps! Bettype and status are invalid.' AS Warning
		GOTO FINAL_CHECK;
	END

	--others bettype
	IF(@Bettype IN (18002, 18003, 18004, 18005) 
		AND (@status NOT IN ('WON')
			OR ISNULL(@refno, 0) = 0
		)
	)
	BEGIN
		SELECT 'Opps! Bettype and status or CB refno are invalid.' AS Warning
		GOTO FINAL_CHECK;
	END


	DECLARE @UserName NVARCHAR(100)
		,@gameID INT	
		,@MatchID BIGINT
		,@transdate DATETIME
		,@eventdate DATETIME
		,@Winlostdate DATE
		,@mrecommend INT
		,@srecommend INT
		,@currency INT
		,@currencyName NVARCHAR(100)
		,@GameId3rd NVARCHAR(64) = NEWID()
		,@TranId3rd NVARCHAR(64) = NEWID()
		,@refno_translog BIGINT
		,@refno_bettrans BIGINT
		,@TransDesc NVARCHAR(1000)	
		,@Result NVARCHAR(1000)	
		,@vendorID INT
		,@productID INT
		,@sportType INT
		,@Betchoice NVARCHAR(1000)	
		,@Time NVARCHAR(1000)=substring(convert(nvarchar(100),GETDATE(),108),1,5)
		,@transdesc301 NVARCHAR(1000)
		,@transdesc302 NVARCHAR(1000)
		,@transdesc303 NVARCHAR(1000)
		,@transdesc304 NVARCHAR(1000)
		,@oddsType TINYINT = 4
		,@oddsID INT
		,@stake MONEY
		,@statusID tinyint
		,@oddsspread float = NULL
		,@odds float = NULL
		,@Custom1 NVARCHAR(100)
		,@hdp1 smallmoney
		,@hdp2 smallmoney
		,@maxWinlost money
		,@recommend INT=NULL
		,@recomendSource INT=NULL

	SELECT @gameID		= @Bettype
		, @vendorID		= 4
		, @productID	= 15 
		, @sportType	= 204
		, @oddsType		= 4
		, @GameId3rd	= ''
		, @stake		= 20
		, @hdp1			= isnull(@hdp1, 0.3)
		, @hdp2			= isnull(@hdp2, 0.7)
		, @maxWinlost	= 200000
	
	SELECT @transdate	= GETDATE()
		, @statusID		= CASE WHEN @STATUS = 'RUNNING' THEN 0 
							WHEN @STATUS = 'WON' THEN 112
							WHEN @STATUS = 'LOSE' THEN 113 
						END
		, @refno_translog = @refno

	SELECT TOP 1 @CustID = ISNULL(@CustID , ct.CustID)
		,@recommend = ISNULL(@recommend , ct.recommend) 
		,@mrecommend = ct.mrecommend
		,@srecommend = ct.srecommend
		,@UserName = ct.UserName
		,@currency = ct.currency
		,@currencyName = ex.currency
	FROM dbo.custinfo ct WITH (NOLOCK)
		LEFT JOIN DBAGE.bodb02.dbo.exchange ex WITH (NOLOCK) ON ct.currency = ex.exchangeid
	WHERE (@CustID = CustID OR @CustID IS NULL )
		 AND (recommend = @recommend OR @recommend IS NULL )
	
	SELECT @Winlostdate		= winlostdate
		, @refno_translog	= translogid
		, @MatchID			= eventID
	FROM dbo.translog b (nolock)
	where translogid		= @refno

	IF(@Bettype = 18001 AND @status IN ('WON','LOSE')) GOTO SETTLE_BET;

	-- insert SUM/Pool bet (18000-18001)
	IF(@Bettype = 18001 AND @status IN ('RUNNING')) 
	BEGIN
		
		SELECT @Winlostdate	= DATEADD(wk,DATEDIFF(wk,0,GETDATE()),6) -- last date of week
			, @gameID		= 18000
			, @TransDesc	= '2,3/4/5/6,7'
			, @TranId3rd	= 'B75051109'
			, @MatchID		= 10985170
			, @Custom1		= '4D48FCD27827B82C5E831B9896C57C'
		
		--translog SUM bet
		INSERT INTO [bodb02].[dbo].[translog] (
			[custid]
			,[transdate]
			,[odds]
			,[stake]
			,[status]
			,[apositiontaking]
			,[mpositiontaking]
			,[tpositiontaking]
			,[spositiontaking]
			,[playerdiscount]
			,[discount]
			,[adiscount]
			,[sdiscount]
			,[creator]
			,[winlostdate]
			,[betfrom]
			,[virtualrate]
			,[actualrate]
			,[actual_stake]
			,[currency]
			,[CurrencyName]
			,[recommend]
			,[mrecommend]
			,[srecommend]
			,[ip]
			,[statusID]
			,[balance]
			,[Username]
			,[transdesc]
			,[productID]
			,[gameID]
			,[eventID]
			,[vendorID]
			,[Gameid3rd]
			,[Tranid3rd]
			,[custom1]
		)
		SELECT TOP 1 @CustID [custid]
			,@transdate [transdate]
			,4 AS [odds]
			,@stake AS [stake]
			,@STATUS [status]
			,0 AS [apositiontaking]
			,0 AS [mpositiontaking]
			,0 AS [tpositiontaking]
			,0 AS [spositiontaking]
			,ISNULL(comRate.playerdiscount, 0) 	AS [playerdiscount]
			,ISNULL(comRate.discount, 0.02) 	AS [discount]
			,ISNULL(comRate.adiscount, 0.045) 	AS [adiscount]
			,ISNULL(comRate.sdiscount, 0.06075) AS [sdiscount]
			,[creator]
			,@WinlostDate [winlostdate]
			,'i' AS [betfrom]
			,0.7 AS [virtualrate]
			,0.7 AS [actualrate]
			,@stake AS [actual_stake]
			,@currency [currency]
			,@CurrencyName [CurrencyName]
			,@recommend [recommend]
			,@mrecommend [mrecommend]
			,@srecommend [srecommend]
			,'127.0.0.1' [ip]
			,@statusID AS [statusID]
			,[balance]
			,@UserName [Username]
			,@transdesc [transdesc]
			,@sportType [productID]
			,@gameID [gameID]
			,@MatchID [eventID]
			,@vendorID [vendorID]
			,@GameId3rd  GameId3rd
			,@TranId3rd TranId3rd
			,@custom1 AS custom1
		FROM [bodb02].[dbo].[translog] b (nolock)
			inner join dbo.SportBettypeMatrix bt (nolock) on  b.gameID = bt.bettype
			OUTER APPLY (
				select top 1 sdiscount 
						,adiscount 
						,discount
						,playerdiscount
				from DBCUST.CustDB.dbo.CustCommRate with(nolock)
				where bettype = 18001 and custid = @CustID
			) AS comRate
		WHERE custid = @custid
			and (bt.productid = 1 and bt.sporttype = 1 and bt.enabled = 1)
	
		SELECT @refno_translog = SCOPE_IDENTITY()
		
		SELECT @refno_translog AS 'translog.translogid'

		IF(@@ERROR = 0 AND @refno_translog > 0)
		BEGIN
			-- bettransm - Pool bet
			INSERT INTO [dbo].[bettransm]
					([custid]
					,[transdate]
					,[oddsid]
					,[hdp1]
					,[hdp2]
					,[odds]
					,[stake]
					,[status]
					,[winlost]
					,[livehomescore]
					,[liveawayscore]
					,[liveindicator]
					,[betteam]
					,[creator]
					,[refno]
					,[comstatus]
					,[winlostdate]
					,[betfrom]
					,[betcheck]
					,[checktime]
					,[oddsspread]
					,[apositiontaking]
					,[mpositiontaking]
					,[tpositiontaking]
					,[awinlost]
					,[mwinlost]
					,[playerdiscount]
					,[discount]
					,[adiscount]
					,[playercomm]
					,[comm]
					,[acomm]
					,[actualrate]
					,[matchid]
					,[matchdate]
					,[finalodds]
					,[isfinish]
					,[statuswinlost]
					,[ruben]
					,[bettype]
					,[spositiontaking]
					,[swinlost]
					,[sdiscount]
					,[scomm]
					,[statusID]
					,[recommdate])
				SELECT [custid]
					,[transdate]
					,0 as [oddsid]
					,0 as [hdp1]
					,0 as [hdp2]
					,[odds]
					,[stake]
					,[status]
					,0 as [winlost]
					,0 as [livehomescore]
					,0 as [liveawayscore]
					,0 as [liveindicator]
					,'' [betteam]
					,[creator]
					,b.translogid as [refno]
					,'' as [comstatus]
					,[winlostdate]
					,[betfrom]
					,b.Tranid3rd AS [betcheck]
					,null as [checktime]
					,null as [oddsspread]
					,[apositiontaking]
					,[mpositiontaking]
					,[tpositiontaking]
					,0 as [awinlost]
					,0 as [mwinlost]
					,[playerdiscount]
					,[discount]
					,[adiscount]
					,0 as [playercomm]
					,0 as [comm]
					,0 as [acomm]
					,[actualrate]
					,b.eventID AS [matchid]
					,@Winlostdate AS [matchdate]
					,0 as [finalodds]
					,0 as [isfinish]
					,0 as [statuswinlost]
					,0 as [ruben]
					,@Bettype AS [bettype]
					,0 as [spositiontaking]
					,0 as [swinlost]
					,[sdiscount]
					,0 as [scomm]
					,[statusID]
					,@transdate AS [recommdate]
			FROM dbo.translog b with(nolock)
			WHERE translogid = @refno_translog
		
			SELECT @Refno_Bettrans = SCOPE_IDENTITY()

			SELECT @Refno_Bettrans AS 'Bettransm.Transid'
		END
	END	
	
	-- insert Prize(18002,18004,18005)
	IF (@refno_translog > 0 
		AND @Bettype IN (18002,18004,18005) 
		AND @status  IN ('WON'))
	BEGIN
		-- A member can WIN N-Consolation and an unique Jackpot Prize with N-lines
		-- check existing bettype
		IF(
			--EXISTS (SELECT TOP 1 1 FROM dbo.bettransm (nolock) where refno = @refno_translog and Bettype IN (18004) AND @Bettype = 18004)
			--OR 
			EXISTS (SELECT TOP 1 1 FROM dbo.bettransm (nolock) where refno = @refno_translog and Bettype IN (18005) AND @Bettype = 18005)
		) BEGIN
			SELECT 'Opps! Bettype and status are invalid. It existed already.' AS Warning
			GOTO FINAL_CHECK;
		END
		ELSE IF (EXISTS (SELECT TOP 1 1 FROM dbo.bettransm (nolock) where refno = @refno_translog and Bettype = @Bettype AND @Bettype = 18002))
		BEGIN
			DECLARE @SoldCompleted	FLOAT
				, @SoldRemainding	FLOAT

			SELECT @SoldCompleted = SUM(hdp1)
			FROM dbo.bettransm (nolock)
			where refno = @refno_translog
			AND bettype = @Bettype

			SET @SoldRemainding = 1 - @SoldCompleted

			SELECT @SoldCompleted		AS SoldCompleted
				,@SoldRemainding		AS SoldRemainding

			IF(@SoldRemainding = 0) 
			BEGIN
				SELECT 'Opps! Ticket was sold completely.' AS Warning
				GOTO FINAL_CHECK;
			END
			ELSE
			BEGIN
				SELECT @hdp1 = CASE WHEN @SoldCompleted >= 0.5 THEN 0.5 ELSE 0.2 END
					, @hdp2  = CASE WHEN @SoldCompleted >= 0.5 THEN 0 ELSE 0.5 END
			END
		END

		DECLARE @tempData table (
			bettype int
			, status varchar(100), statusID tinyint
			, stake money, winlost money
			, hdp1 smallmoney, hdp2 smallmoney
		)

		;WITH CTE_Consolation (bettype, status, statusID, stake, winlost, hdp1, hdp2)
		AS (
			-- Consolation
			select 18004, 'WON', 112, 0, 1500, 0, 0
			where @Bettype = 18004
			union ALL
			select 18003, 'LOSE', 113, 450, 0, 0, 0
			where @Bettype = 18004
		), CTE_Jackpot (bettype, status, statusID, stake, winlost, hdp1, hdp2)
		AS (
			-- Jackpot
			select 18005, 'WON', 112, 0, 1000, 0, 0
			where @Bettype = 18005
			union ALL
			select 18003, 'LOSE', 113, 300, 0, 0, 0
			where @Bettype = 18005
		), CTE_CashOut (bettype, status, statusID, stake, winlost, hdp1, hdp2)
		AS (
			-- Cash-Out
			select 18002, 'WON', 112, 0, 750, @hdp1, @hdp2
			where @Bettype = 18002
		)
		INSERT INTO @tempData
		SELECT *
		FROM CTE_Consolation
		--WHERE NOT EXISTS (SELECT TOP 1 1 FROM bettransm (nolock) WHERE refno = @refno_translog and bettype IN (18004))
		
		UNION ALL
		SELECT *
		FROM CTE_Jackpot
		WHERE NOT EXISTS (SELECT TOP 1 1 FROM bettransm (nolock) WHERE refno = @refno_translog and bettype IN (18005))

		UNION ALL
		SELECT *
		FROM CTE_CashOut

		INSERT INTO [dbo].[bettransm]
				([custid]
				,[transdate]
				,[oddsid]
				,[hdp1]
				,[hdp2]
				,[odds]
				,[stake]
				,[status]
				,[winlost]
				,[livehomescore]
				,[liveawayscore]
				,[liveindicator]
				,[betteam]
				,[creator]
				,[refno]
				,[comstatus]
				,[winlostdate]
				,[betfrom]
				,[betcheck]
				,[checktime]
				,[oddsspread]
				,[apositiontaking]
				,[mpositiontaking]
				,[tpositiontaking]
				,[awinlost]
				,[mwinlost]
				,[playerdiscount]
				,[discount]
				,[adiscount]
				,[playercomm]
				,[comm]
				,[acomm]
				,[actualrate]
				,[matchid]
				,[matchdate]
				,[finalodds]
				,[isfinish]
				,[statuswinlost]
				,[ruben]
				,[bettype]
				,[spositiontaking]
				,[swinlost]
				,[sdiscount]
				,[scomm]
				,[statusID]
				,[recommdate]
			)
			SELECT [custid]
				,[transdate]
				,0 as [oddsid]
				,temp.hdp1
				,temp.hdp2
				,[odds]
				,temp.[stake]
				,temp.[status]
				,temp.winlost
				,0 as [livehomescore]
				,0 as [liveawayscore]
				,0 as [liveindicator]
				,'' [betteam]
				,[creator]
				,b.translogid as [refno]
				,'' as [comstatus]
				,[winlostdate]
				,[betfrom]
				,b.Tranid3rd AS [betcheck]
				,null as [checktime]
				,null as [oddsspread]
				,[apositiontaking]
				,[mpositiontaking]
				,[tpositiontaking]
				,0 as [awinlost]
				,0 as [mwinlost]
				,case when temp.bettype = 18002 then isnull(comRate.playerdiscount,0) else 0 end as [playerdiscount]
				,case when temp.bettype = 18002 then isnull(comRate.discount,0.08) else 0 end as [discount]
				,case when temp.bettype = 18002 then isnull(comRate.adiscount,0.14) else 0 end as [adiscount]
				,0 as [playercomm]
				,0 as [comm]
				,0 as [acomm]
				,[actualrate]
				,b.eventID AS [matchid]
				,@Winlostdate AS [matchdate]
				,0 as [finalodds]
				,0 as [isfinish]
				,0 as [statuswinlost]
				,0 as [ruben]
				,temp.bettype AS [bettype]
				,0 as [spositiontaking]
				,0 as [swinlost]
				,case when temp.bettype = 18002 then isnull(comRate.sdiscount,0.225) else 0 end as [sdiscount]
				,0 as [scomm]
				,temp.statusID
				,@transdate AS [recommdate]
		FROM dbo.translog b with(nolock)
			cross join @tempData temp
			OUTER APPLY (
				select top 1 sdiscount 
						,adiscount 
						,discount
						,playerdiscount
				from DBCUST.CustDB.dbo.CustCommRate with(nolock)
				where bettype = 18002 and custid = @CustID
			) AS comRate
		WHERE translogid = @refno_translog

		SELECT @Refno_Bettrans = SCOPE_IDENTITY()
		SELECT @Refno_Bettrans AS 'bettransm.transid'

		SELECT COUNT(1) AS NumTrans FROM @tempData
	END

	SETTLE_BET:
	BEGIN
		IF(@Bettype IN (18001) AND @status IN ('WON','LOSE')) 
		BEGIN 

			IF(EXISTS(SELECT TOP 1 1 FROM dbo.bettrans (nolock) WHERE refno = @refno_translog))
			BEGIN
				SELECT 'Opps. This bet was settled already.' AS Warning
				GOTO FINAL_CHECK;
			END
		
			DECLARE @maxAmount MONEY

			select @maxAmount = SUM(winlost-stake)
			from dbo.bettransm (nolock)
			where refno = @refno_translog 
				--and bettype not in (18001)
				--and statuswinlost = 0

			UPDATE b
			SET status		= @status
				,statusID	= @statusID
			FROM dbo.translog b WITH(ROWLOCK, UPDLOCK)
			WHERE translogid = @refno_translog

			UPDATE b
			SET status		= 'LOSE'
				,statusID	= 113
			FROM dbo.bettransm b WITH(ROWLOCK, UPDLOCK)
			WHERE @refno	= @refno_translog
				AND bettype = 18001

			UPDATE b
			SET statuswinlost	= CASE WHEN @maxAmount >= @maxwinlost THEN 1 ELSE 0 END
			FROM dbo.bettransm b WITH(ROWLOCK, UPDLOCK)
			WHERE @refno		= @refno_translog
				--AND bettype		<> 18001
		
			--INSERT to bettrans
			INSERT INTO [dbo].[bettrans]
					  ([custid]
					  ,[transdate]
					  ,[oddsid]
					  ,[hdp1]
					  ,[hdp2]
					  ,[odds]
					  ,[stake]
					  ,[status]
					  ,[winlost]
					  ,[awinlost]
					  ,[mwinlost]
					  ,[playercomm]
					  ,[comm]
					  ,[acomm]
					  ,[apositiontaking]
					  ,[mpositiontaking]
					  ,[tpositiontaking]
					  ,[playerdiscount]
					  ,[discount]
					  ,[adiscount]
					  ,[livehomescore]
					  ,[liveawayscore]
					  ,[liveindicator]
					  ,[betteam]
					  ,[creator]
					  ,[refno]
					  ,[comstatus]
					  ,[winlostdate]
					  ,[betfrom]
					  ,[betcheck]
					  ,[checktime]
					  ,[oddsspread]
					  ,[actualrate]
					  ,[matchid]
					  ,[recommend]
					  ,[mrecommend]
					  ,[ruben]
					  ,[betid]
					  ,[statuswinlost]
					  ,[modds]
					  ,[bettype]
					  ,[betdaqid]
					  ,[actual_stake]
					  ,[currency]
					  ,[ip]
					  ,[transdesc]
					  ,[sdiscount]
					  ,[scomm]
					  ,[spositiontaking]
					  ,[swinlost]
					  ,[srecommend]
					  ,[Username]
					  ,[CurrencyName]
					  ,[virtualrate]
					  ,[oddstype]
					  ,[statusID]
					  ,[currency2]
					  ,[balance]
					  ,[SecAcceptFlag]
					  ,[transid2]
					  ,[RecommDate])
			SELECT TOP 1 @custid custid
				,transdate
				,eventID AS oddsid
				,0 as hdp1
				,0 as hdp2
				,odds
				,stake
				,@status AS [status]
				,CASE WHEN @maxAmount >= @maxWinlost THEN 0 ELSE @maxAmount END AS Winlost
				,0 as awinlost
				,0 as mwinlost
				,0 as playercomm
				,0 as comm
				,0 as acomm
				,apositiontaking
				,mpositiontaking
				,tpositiontaking
				,playerdiscount
				,discount
				,adiscount
				,0 livehomescore
				,0 liveawayscore
				,0 liveindicator
				,'' AS  betteam
				,creator
				,@refno_translog as refno
				,NULL comstatus
				,winlostdate
				,betfrom
				,custom1 AS betcheck
				,transDate
				,0 as oddsspread
				,1 actualrate
				,@sportType as matchid
				,recommend
				,mrecommend
				,1 ruben
				,NULL betid
				,NULL statuswinlost
				,1 modds
				,gameID as bettype
				,NULL betdaqid
				,actual_stake
				,currency
				,'127.0.0.1' as ip
				,transdesc
				,sdiscount
				,0 as scomm
				,spositiontaking
				,0 as swinlost
				,srecommend
				,Username
				,CurrencyName
				,virtualrate
				,0 AS oddstype
				,@statusID
				,NULL currency2
				,balance
				,NULL SecAcceptFlag
				,0 transid2
				,transdate as RecommDate
			FROM [bodb02].[dbo].translog b WITH (NOLOCK)
			
			WHERE translogid = @refno_translog

			SELECT @Refno_Bettrans = SCOPE_IDENTITY()

			SELECT 'Settle' AS [Action]
				,@refno_translog AS 'translog.translogid'
				,@Refno_Bettrans AS 'bettrans.transid'
		END
	END

	FINAL_CHECK:
	BEGIN
		SELECT 'translog' AS [Table], * 
		FROM [bodb02].[dbo].[translog] WITH (NOLOCK) WHERE custid = @CustID AND translogid	= @refno_translog	 
		SELECT 'bettransm' AS [Table], * 
		FROM [bodb02].[dbo].[bettransm] WITH (NOLOCK) WHERE custid = @CustID AND refno		= @refno_translog
		SELECT 'bettrans' AS [Table], * 
		FROM [bodb02].[dbo].[bettrans] WITH (NOLOCK) WHERE custid = @CustID AND refno		= @refno_translog
	END
END
GO
ALTER PROCEDURE [dbo].[DataSample_CB_BetTicket_Del] 
	@refno BIGINT
		
AS 
/*
Task:#40294 - Integration Collosus Bet product
Creator:20150827@bobby.nguyen
Params:
	- @refno: translog.translogid = bettrans.refno = bettransm.refno
	
*/
BEGIN
	SET NOCOUNT ON;

	DELETE d
	FROM bettrans d
	WHERE d.refno = @refno

	DELETE d
	FROM bettransm d
	WHERE d.refno = @refno

	DELETE d
	FROM translog d
	WHERE d.translogid = @refno	

	RETURN
END
GO
EXEC [dbo].[DataSample_CB_BetTicket_Ins]
	@CustID  	= 2723431
	,@Bettype 	= 18000
	,@status  	= 'RUNNING'
	,@refno 	= 0
GO
/*
SELECT 'translog' AS [Table], * 
FROM [bodb02].[dbo].[translog] WITH (NOLOCK) WHERE translogid	= 1000000001091	 
SELECT 'bettransm' AS [Table], * 
FROM [bodb02].[dbo].[bettransm] WITH (NOLOCK) WHERE refno		= 1000000001091
SELECT 'bettrans' AS [Table], * 
FROM [bodb02].[dbo].[bettrans] WITH (NOLOCK) WHERE refno		= 1000000001091
*/

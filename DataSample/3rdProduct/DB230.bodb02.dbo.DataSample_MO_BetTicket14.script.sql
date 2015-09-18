ALTER PROCEDURE [dbo].[DataSample_MO_Betticket14_Ins]
	@CustID INT
	,@Bettype INT
	,@status VARCHAR(100) = 'RUNNING' --RUNNING|WON|LOSE|VOID
	,@recommend INT=NULL
	,@recomendSource INT=NULL
	
AS
/*
Task:#40294 - Integration Myanmar Odds product
Creator:20150827@bobby.nguyen
Params:
	- @Bettype: 301,302,303,304
		+ 301: % Handicap
		+ 302: % Over/Under
		+ 303: 1H % Handicap
		+ 304: 1H % Over/Under

*/ 

BEGIN

	IF(@status = 'DRAW')
	BEGIN
		SELECT 'Opps! Ticket should be NO DRAW status.' AS Warning
		RETURN;
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
		,@Betchoice NVARCHAR(1000)	
		,@Time NVARCHAR(1000)=substring(convert(nvarchar(100),GETDATE(),108),1,5)
		,@transdesc301 NVARCHAR(1000)
		,@transdesc302 NVARCHAR(1000)
		,@transdesc303 NVARCHAR(1000)
		,@transdesc304 NVARCHAR(1000)
		,@oddsType TINYINT = 6
		,@oddsID INT
		,@stake MONEY
		,@statusID tinyint
		,@oddsspread float = NULL
		,@odds float = NULL

	SELECT @GameId3rd = ''------- CASE WHEN @gameID = 1702 THEN 'R' ELSE 'B' END + SUBSTRING(@GameId3rd, 0, CHARINDEX('-', @GameId3rd, 1))
	
	SELECT @gameID = ISNULL(@Bettype,301)
		, @vendorID = 0
		, @productID = 1 
		, @odds = ISNULL(@odds, 0.94)
		, @refno_translog = 100000000000
		, @oddsType = 6
		, @stake = 100

	SELECT @transdesc301 = '1_8/18/2015@http://zh735.maxbet.com/LeftAllInOne.aspx'
		 ,@transdesc302 = '3_8/18/2015@http://p40t2.maxbet.com/LeftAllInOne.aspx'
		 ,@transdesc303 = '5_8/18/2015@http://ghsfm.maxbet.com/LeftAllInOne.aspx'
		 ,@transdesc304 = 'http://mo4sd.maxbet.com/Confirm_bet.aspx'
		 
	SELECT @TransDesc= CASE  @Bettype	WHEN 301 THEN @transdesc301
										WHEN 302 THEN @transdesc302
										WHEN 303 THEN @transdesc303
										WHEN 304 THEN @transdesc304 END

	SELECT @oddsID= CASE  @Bettype	WHEN 301 THEN 58940115
										WHEN 302 THEN 58921301
										WHEN 303 THEN 58921236
										WHEN 304 THEN 58921235 END

	SELECT @oddsspread= CASE  @Bettype	WHEN 301 THEN -33
										WHEN 302 THEN -80
										WHEN 303 THEN -33
										WHEN 304 THEN 80 END


	select @statusID = CASE @status WHEN 'running' THEN 0 
									WHEN 'won' THEN 112 
									WHEN 'lose' THEN 113
									--WHEN 'draw' THEN 111 
									WHEN 'void' THEN 102 
									ELSE 0 END

	SELECT 	@transdate = GETDATE() - 3
	SELECT @Winlostdate = @transdate


	IF @Status = 'running'
	BEGIN 
		SELECT TOP 1 @MatchID = matchID FROM Match WITH (NOLOCK)
		WHERE EventStatus = 'running' AND sporttype = 1 AND eventdate = @Winlostdate

		IF @MatchID IS NULL
		BEGIN 
			SELECT TOP 1 @MatchID = matchID, @eventdate = eventdate FROM Match WITH (NOLOCK)
			WHERE EventStatus = 'running' AND sporttype = 1 AND eventdate < @Winlostdate
			ORDER BY eventdate DESC 

			SELECT 	@transdate = CURRENT_TIMESTAMP
			SELECT @Winlostdate = @eventdate
		END 
		 
	END
	ELSE 
	BEGIN 
		SELECT TOP 1 @MatchID = matchID FROM Match14 WITH (NOLOCK)
		WHERE EventStatus = 'Completed' AND sporttype = 1 AND eventdate = @Winlostdate	 

		
		IF @MatchID IS NULL
		BEGIN 
			SELECT TOP 1 @MatchID = matchID, @eventdate = eventdate FROM Match14 WITH (NOLOCK)
			WHERE EventStatus = 'Completed' AND sporttype = 1 AND eventdate < @Winlostdate
			ORDER BY eventdate DESC 

			SELECT 	@transdate = @eventdate
			SELECT @Winlostdate = @eventdate
		END 
		
	END
	
	SELECT TOP 1 @CustID = ISNULL(@CustID , ct.CustID)
		,@recommend = ISNULL(@recommend , ct.recommend) 
		,@mrecommend = ct.mrecommend
		,@srecommend = ct.srecommend
		,@UserName = ct.UserName
		,@currency = ct.currency
		--,@currencyName = ex.currency
	FROM dbo.custinfo ct WITH (NOLOCK)
		--LEFT JOIN bodb02.dbo.exchange ex WITH (NOLOCK) ON ct.currency = ex.exchangeid
	WHERE (@CustID = CustID OR @CustID IS NULL )
		 AND (recommend = @recommend OR @recommend IS NULL )
	
	declare @transid14 BIGINT
	SELECT @transid14 = MAX(transid) FROM bettrans14 (nolock)
	SET @transid14 += 1

	INSERT INTO [dbo].[bettrans14]
			  ([transid]
			   ,[custid]
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
			   ,[virtualrate]
			   ,[Username]
			   ,[CurrencyName]
			   ,[oddstype]
			   ,[statusID]
			   ,[currency2]
			   ,[balance]
			   ,[SecAcceptFlag]
			   ,[transid2])
	SELECT TOP 1 @transid14 AS [transid]
			   ,[custid]
			   ,@transdate AS [transdate]
			   ,@oddsid AS oddsid
			   	,CASE	WHEN @Bettype =  301 THEN 0 
						WHEN @Bettype =  302 THEN 3
						WHEN @Bettype =  303 THEN 0 
						WHEN @Bettype =  304 THEN 1
						ELSE 0 
					END AS hdp1
				,CASE	WHEN @Bettype =  301 THEN 1 
						WHEN @Bettype =  302 THEN 0
						WHEN @Bettype =  303 THEN 0 
						WHEN @Bettype =  304 THEN 0
						ELSE 0 
					END AS hdp2
				,@odds AS odds
				,stake
				,@status AS [status]
				,CASE WHEN @STATUS = 'WON' THEN [actual_stake]+stake
					WHEN @STATUS IN ('DRAW','VOID')  THEN [actual_stake] 
					ELSE [actual_stake]/3 END winlost
				,CASE WHEN @STATUS IN ('DRAW','VOID')  THEN 0 ELSE actual_stake * apositiontaking END awinlost
				,CASE WHEN @STATUS IN ('DRAW','VOID')  THEN 0 ELSE actual_stake * mpositiontaking END mwinlost
				,0 playercomm
				,CASE WHEN @STATUS IN ('DRAW','VOID')  THEN 0 ELSE 0.2034 END comm
				,CASE WHEN @STATUS IN ('DRAW','VOID')  THEN 0 ELSE 0.4067 END acomm
				,apositiontaking
				,mpositiontaking
				,tpositiontaking
				,ISNULL(comRate.playerdiscount, b.playerdiscount) AS playerdiscount
				,ISNULL(comRate.discount, b.discount) AS discount
				,ISNULL(comRate.adiscount, b.adiscount) AS adiscount
				,0 livehomescore
				,0 liveawayscore
				,0 liveindicator
			    ,CASE	WHEN @Bettype =  301 THEN 'h' 
						WHEN @Bettype =  302 THEN 'h' 
						WHEN @Bettype =  303 THEN 'a'  
						WHEN @Bettype =  304 THEN 'a' 
						ELSE '' 
					END AS  betteam
				,creator
				,@refno_translog as refno
				,NULL comstatus
				,@winlostdate
			   ,CASE	WHEN @Bettype =  301 THEN 'i' 
						WHEN @Bettype =  302 THEN 'i' 
						WHEN @Bettype =  303 THEN 'i'  
						WHEN @Bettype =  304 THEN 'h' 
						ELSE ''
					END AS  betfrom
				,CASE	WHEN @Bettype =  301 THEN 'df(198.39)(-55/-55/-1:-1)' 
						WHEN @Bettype =  302 THEN 'df(282.10)(-55/-55/-1:-1)' 
						WHEN @Bettype =  303 THEN 'df(132.00)(-55/-55/-1:-1)'  
						WHEN @Bettype =  304 THEN 'df(-21.04)(-55/-55/-1:-1)' 
						ELSE '' 
					END AS betcheck
			    ,@TransDate as  checktime
				,@oddsspread AS oddsspread
				,1 actualrate
				,@matchid matchid
			   ,[recommend]
			   ,[mrecommend]
			   ,[ruben]
			   ,NULL betid
			  -- ,[tstamp]
				,NULL statuswinlost
				,1 modds
				,@Bettype bettype
				,NULL betdaqid
				,actual_stake
			   ,[currency]
			   ,'127.0.0.1' as ip
			   ,@TransDesc AS transdesc
				,ISNULL(comRate.sdiscount, b.sdiscount) AS sdiscount
				,CASE WHEN @STATUS IN ('DRAW','VOID')  THEN 0 ELSE 0.0407 END scomm
			    ,spositiontaking
				,CASE WHEN @STATUS IN ('DRAW','VOID')  THEN 0 ELSE actual_stake * spositiontaking END swinlost
			   ,[srecommend]
			   ,[virtualrate]
			   ,[Username]
			   ,[CurrencyName]
			   ,@oddstype AS oddstype
			   ,@statusID AS [statusID]
			   ,NULL currency2
				,balance
				,NULL SecAcceptFlag
				,0 transid2
	FROM [bodb02].[dbo].bettrans b WITH (NOLOCK)
		INNER JOIN dbo.SportBettypeMatrix bt (nolock) on  b.bettype = bt.bettype
		OUTER APPLY (
			select top 1 sdiscount 
					,adiscount 
					,discount
					,playerdiscount
			from DBCUST.CustDB.dbo.CustCommRate with(nolock)
			where bettype = 301 and custid = @CustID
		) AS comRate
	WHERE custid = @custid
		--and (bt.productid = 1 and bt.sporttype = 1 and bt.enabled = 1)
		--and ([status] = @status OR @status = 'VOID')
	
	SELECT @Refno_Bettrans = @transid14

	SELECT @Refno_Bettrans AS 'bettrans14.transid'
		
		 
	SELECT 'bettrans14' AS [table], * 
	FROM [bodb02].[dbo].[bettrans14] b WITH (NOLOCK) 
	left join dbo.match14 m on b.matchid = m.matchid
	WHERE transid = @Refno_Bettrans

	RETURN;
	
END
GO

EXEC [dbo].[DataSample_MO_Betticket14_Ins]
 @CustID  = 1176092
 ,@Bettype = 302
 ,@status  = 'WON'


/*update m
set matchid = 14566144
from bettrans14 m
where custid = 1176092 and bettype in (301,302,303,304)*/
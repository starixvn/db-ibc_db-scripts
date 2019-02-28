USE [bodb_3rdProduct]
GO

ALTER PROCEDURE dbo.DBA_Exchange_CreateData
	@CustId				INT = 0,
	@eventTypeName		VARCHAR(50) = 'SOCCER', -- SOCCER, TENNIS, CRICKET, RUGBY_UNION, HORSE_RACING, AMERICAN_FOOTBALL, BASKETBALL
	@eventName			VARCHAR(500) = 'MU vs MC',
	@marketName			VARCHAR(500) = 'Match Odds',
	@selectionName		VARCHAR(100) = 'MU',
	@settledDate		DATETIME = '2017-01-03 04:12:13.235',
	@resettledDate		DATETIME = NULL,
	@matchType			VARCHAR(10) = 'Back', -- 'Lay'
	@list_stakeTotal	VARCHAR(MAX) = '50,50',
	@list_matchOdds		VARCHAR(MAX) = '2.1,2',
	@status				VARCHAR(5) = 'WON', -- 'LOSE', 'DRAW'
	@memberCommRate		FLOAT = 0,
	@licenseeCommRate	FLOAT = 0
AS

/*
	Created by Percy
	Date: 2017-01-03
	DB: DBLIC.bodb_3rdProduct
	Task: Local testing data
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @eventType SMALLINT, @eventId INT, @marketID VARCHAR(50), @selectionId INT,	@matchOddsReq SMALLMONEY, @matchAmount MONEY,
			@userId VARCHAR(16), @matchStake MONEY, @matchAvgOdds SMALLMONEY, @marketTotal MONEY, @profitLoss MONEY, @betId BIGINT,
			@currency INT, @ExVirtualRate FLOAT, @commission FLOAT, @agentCommission FLOAT

	SELECT @currency = currency FROM bodb02.dbo.custInfo WITH (NOLOCK) WHERE custid = @CustId AND roleid = 1

	IF @currency IS NULL
	BEGIN
		SELECT 'Invalid member'
		RETURN
	END

	SELECT @ExVirtualRate = ExVirtualRate FROM bodb02.dbo.Exchange WITH (NOLOCK) WHERE exchangeid = @currency

	SELECT @ExVirtualRate = ISNULL(@ExVirtualRate, 1)

	SELECT  @eventType = CASE @EventTypeName
		WHEN 'SOCCER' THEN 1
		WHEN 'TENNIS' THEN 2
		WHEN 'CRICKET' THEN 4
		WHEN 'RUGBY_UNION' THEN 5
		WHEN 'HORSE_RACING' THEN 7
		WHEN 'AMERICAN_FOOTBALL' THEN 6423
		WHEN 'BASKETBALL' THEN 7522
		END

	SELECT TOP 1 @eventId = eventId	FROM dbo.Bettrans_Exchange WITH (NOLOCK) WHERE eventName = @eventName

	SELECT TOP 1 @marketID = marketID FROM dbo.Bettrans_Exchange WITH (NOLOCK) WHERE marketName = @marketName
	
	SELECT TOP 1 @selectionId = selectionId FROM dbo.Bettrans_Exchange WITH (NOLOCK) WHERE selectionName = @selectionName

	SELECT
		@eventId = ISNULL(@eventId, MAX(eventId)+1),
		@marketID = ISNULL(@marketID, CONVERT(VARCHAR(50), MAX(CONVERT(FLOAT, marketID))+1)),
		@selectionId = ISNULL(@selectionId, MAX(selectionId)+1)
	FROM dbo.Bettrans_Exchange WITH (NOLOCK)

	SELECT @matchOddsReq = AVG(val)
	FROM (SELECT CONVERT(SMALLMONEY, val) AS val FROM bodb02.dbo.strSplit(@list_matchOdds, ',')) AS A

	SELECT @matchAvgOdds = @matchOddsReq

	SELECT @matchAmount = SUM(val)
	FROM (SELECT CONVERT(MONEY, val) AS val FROM bodb02.dbo.strSplit(@list_stakeTotal, ',')) AS A

	SELECT @matchStake = @matchAmount

	SELECT @marketTotal = CASE @status WHEN 'LOSE' THEN -@matchStake ELSE 0 END
	SELECT @profitLoss = @marketTotal

	SELECT @commission = 0, @agentCommission = 0

	IF @status = 'WON'
	BEGIN
		WITH A AS (
			SELECT CONVERT(SMALLMONEY, val) AS val, rank FROM bodb02.dbo.strSplit(@list_matchOdds, ',')
		)
		, B AS (
			SELECT CONVERT(SMALLMONEY, val) AS val, rank FROM bodb02.dbo.strSplit(@list_stakeTotal, ',')
		)
		SELECT @marketTotal = SUM((A.val-1) * B.val) FROM A INNER JOIN B ON A.rank = B.rank

		SELECT @profitLoss = @marketTotal*(1-@memberCommRate)

		SELECT @commission = - (@marketTotal * @memberCommRate), @agentCommission =  (@marketTotal * @licenseeCommRate)
	END

	SELECT @userId = CONVERT(VARCHAR(10), @CustId)

	WHILE LEN(@userId) < 13
	BEGIN
		SELECT @userId = '0' + @userId
	END

	SELECT @userId = 'POC' + @userId

	SELECT @betId = MAX(betId) + 1 FROM dbo.Bettrans_Exchange WITH (NOLOCK)
	SELECT @betId = ISNULL(@betId, 1)

	INSERT INTO dbo.Bettrans_Exchange
	(
		site,currencyType,eventType,eventTypeName,eventName,eventID,marketName,marketID,selectionName,selectionID,matchType,
		betId,betPlaced,ip,matchOddsReq,unMatchAmount,reduction,userId,extension1,matchStake,matchAvgOdds,profitLoss,
		dateMatched,betstatus,APIEndDate
	)
	VALUES
	(
		5,3,@eventType,@eventTypeName,@eventName,@eventId,@marketName,@marketID,@selectionName,@selectionId,@matchType,
		@betId,GETDATE(),'',@matchOddsReq,0,0,@userId,'4200100',@matchStake,@matchAvgOdds,@profitLoss,
		GETDATE(),'Settled',GETDATE()
	)
	
	DELETE dbo.BettransM_Exchange WITH (ROWLOCK, UPDLOCK) WHERE BetID = @betId

	;WITH A AS (
		SELECT CONVERT(SMALLMONEY, val) AS val, rank FROM bodb02.dbo.strSplit(@list_matchOdds, ',')
	)
	, B AS (
		SELECT CONVERT(SMALLMONEY, val) AS val, rank FROM bodb02.dbo.strSplit(@list_stakeTotal, ',')
	)
	INSERT INTO dbo.BettransM_Exchange (BetID, betTaken, txStake, txOddsMatched, actualOdds)
	SELECT @betId, GETDATE(), B.val, A.val, A.val FROM A INNER JOIN B ON A.rank = B.rank
	
	MERGE dbo.Sum_winloss_Exchange AS s
	USING
	(
		SELECT
			@userId AS userId,
			@eventID AS eventID,
			@marketID AS marketID
	) AS src
		ON s.userId = src.userId AND s.eventId = src.eventId AND s.marketId = src.marketID
	WHEN MATCHED THEN
		UPDATE SET
			s.profitLoss = s.profitLoss + @profitLoss,
			s.marketTotal = s.marketTotal + @marketTotal,
			s.commission = s.commission + @commission,
			s.agentCommission = s.agentCommission + @agentCommission,
			s.stakeTotal = s.stakeTotal + @matchStake
	WHEN NOT MATCHED THEN
		INSERT
		(
			userId,agentId,eventTypeName,eventName,eventID,marketName,marketID,startTime,settledDate,profitLoss,
			marketTotal,commission,agentCommission,stakeTotal,resettledDate,CustID,Currency,ExVirtualRate
		)
		VALUES
		(
			@userId,'eurapima',@eventTypeName,@eventName,@eventID,@marketName,@marketID,GETDATE(),@settledDate,@profitLoss,
			@marketTotal,@commission,@agentCommission,@matchStake,@resettledDate,@CustID,@Currency,@ExVirtualRate
		);
END
GO
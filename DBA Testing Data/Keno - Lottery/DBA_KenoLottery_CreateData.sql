USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_KenoLottery_CreateData]
	@ProductID		INT,
	@winlostdate	SMALLDATETIME = NULL,
	@custid			INT,
	@sporttype		SMALLINT,
	@bettype		INT,
	@stake			MONEY = 100,
	@status			VARCHAR(20),
	@ChoiceId		TINYINT = 1,
	@DrawId			BIGINT = 123456,
	@Custom2		VARCHAR(50) = '15'
AS

/*
	Created: PERCY
*/

BEGIN
	SET NOCOUNT ON

	IF NOT EXISTS (
		SELECT 1 FROM dbo.SportBettypeMatrix WITH (NOLOCK)
		WHERE ProductID = @ProductID AND Sporttype = @Sporttype AND BetType = @Bettype
			AND ProductID IN (8, 28) -- Keno, Lottery
	)
	BEGIN
		SELECT 'Invalid Product/Sporttype/Bettype'
		RETURN
	END

	IF @ChoiceID NOT BETWEEN 1 AND 36
	BEGIN
		SELECT 'Invalid ChoiceID'
		RETURN
	END

	SELECT @DrawId = ISNULL(@DrawId, 12345678)

	-- this product don't have match
	SELECT @winlostdate = ISNULL(@winlostdate, CONVERT(DATE, GETDATE()))

	DECLARE @BalanceUpDay SMALLDATETIME, @MoveBetsDay SMALLDATETIME

	DECLARE @MBBUDate TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
	INSERT INTO @MBBUDate (BalanceUpDay, MoveBetsDay)
	EXEC DBAGE.bodb02.dbo.Age_SelBalanceUpDay

	SELECT TOP 1 @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay FROM @MBBUDate

	IF @winlostdate <= @MoveBetsDay -- range bettrans
	BEGIN
		SELECT 'bettrans range only'
		RETURN
	END

	DECLARE @datetime DATETIME
	SELECT  @datetime = CONVERT(VARCHAR(10), @winlostdate, 120) + ' ' + CONVERT(VARCHAR(10), GETDATE(), 108)

	------------ member info -------------
	DECLARE @recommend INT, @mrecommend INT, @srecommend INT, @username VARCHAR(50),
			@currency INT, @CurrencyName VARCHAR(50), @actualrate FLOAT
	
	SELECT
		@username = username,
		@recommend = recommend,
		@mrecommend = mrecommend,
		@srecommend = srecommend,
		@currency = currency
	FROM CustDB.dbo.custInfo WITH(NOLOCK)
	WHERE roleid = 1 AND custid = @custid
	
	IF @recommend IS NULL
	BEGIN
		SELECT 'Invalid CustId'
		RETURN
	END

	SELECT @actualrate = actualrate, @CurrencyName = currency FROM dbo.exchange WITH(NOLOCK) WHERE exchangeid = @currency

	DECLARE @betteam NVARCHAR(20) = '1', @matchid INT
	SELECT  @matchid = 2812345

	DECLARE @transid BIGINT, @translogid BIGINT, @statusID TINYINT, @winlost MONEY, @swinlost MONEY

	EXEC dbo.DBA_Get_StatusID_From_Status @Status = @status, @statusID = @statusID OUTPUT
	IF @statusID IS NULL
	BEGIN
		SELECT 'Invalid Status'
		RETURN
	END

	SELECT @winlost = CASE  WHEN @statusID IN (0, 1, 113) THEN 0
							WHEN @statusID IN (111, 102, 101, 103) THEN @stake
							ELSE @stake*1.9
						END
	SELECT @swinlost = 0.8*@winlost

	DECLARE @transdesc VARCHAR(1000)

	IF @ProductID = 8
	BEGIN
		SELECT @transdesc = 'betChoice=' + CONVERT(VARCHAR(20), @DrawId) + ',' + CONVERT(VARCHAR(20), @ChoiceId)
	END
	ELSE
	BEGIN
		SELECT @transdesc = 'betChoice=' + CONVERT(VARCHAR(10), @matchid) + ',' + @betteam + ';referID='
	END

	-- running ticket --
	INSERT INTO dbo.translog
	(
		transdate, odds, stake, actual_stake, status, statusID,
		apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
		sdiscount, adiscount, discount, playerdiscount,
		creator,
		winlostdate, betfrom,
		currency, actualrate, virtualrate,
		srecommend, mrecommend, recommend, custid, Username,
		ip, productID, gameID, eventID, vendorID, transdesc,
		custom2, liveindicator
	)
	SELECT
		@datetime, 0.9, @stake, @stake, @status, @statusID,
		0, 0, 0.8, 0.8,
		0, 0, 0, 0,
		8,
		@winlostdate, 'd',
		@currency, @actualrate, @actualrate,
		@srecommend, @mrecommend, @recommend, @custid, @username,
		'127.1.1.0', @sporttype, @bettype, @matchid, @ProductID, @transdesc,
		@Custom2, 0
	
	SELECT @translogid = SCOPE_IDENTITY()

	IF @StatusID NOT IN (0, 1)
	BEGIN
		INSERT INTO dbo.bettrans
		(
			matchid, transdate, odds, stake, actual_stake, status, statusID, ruben,
			winlost, awinlost, mwinlost, swinlost, scomm, acomm, comm, playercomm,
			apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
			sdiscount, adiscount, discount, playerdiscount,
			livehomescore, liveawayscore, betteam, creator, refno,
			winlostdate, betfrom, checktime,
			currency, actualrate, virtualrate,
			srecommend, mrecommend, recommend, custid, Username,
			ip, bettype, transdesc,
			comstatus, liveindicator
		)
		SELECT
			@matchid, transdate, odds, stake, actual_stake, status, statusID, 1,
			@winlost, 0, 0, @swinlost, 0, 0, 0, 0,
			apositiontaking, mpositiontaking, spositiontaking, tpositiontaking,
			sdiscount, adiscount, discount, playerdiscount,
			0, 0, @betteam, creator, translogid,
			winlostdate, betfrom, @datetime,
			currency, actualrate, virtualrate,
			srecommend, mrecommend, recommend, custid, Username,
			ip, gameID, transdesc,
			custom2, 0
		FROM dbo.translog WITH (NOLOCK)
		WHERE translogid = @translogid

		SELECT @transid = SCOPE_IDENTITY()
		
		UPDATE dbo.bettrans WITH (ROWLOCK, UPDLOCK)
		SET status = CASE WHEN winlost > actual_stake THEN 'WON'
							WHEN winlost < actual_stake THEN 'LOSE'
							WHEN winlost = actual_stake THEN 'DRAW' END,
			statusID = CASE WHEN winlost > actual_stake THEN 112
							WHEN winlost < actual_stake THEN 113
							WHEN winlost = actual_stake THEN 111 END,
			ruben = 1
		WHERE transid = @transid
	END
END
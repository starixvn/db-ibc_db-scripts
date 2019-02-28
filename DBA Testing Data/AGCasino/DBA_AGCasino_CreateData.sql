USE [bodb_PlaytechCS]
GO

ALTER PROCEDURE [dbo].[DBA_AGCasino_CreateData]
	@WinlostDate	SMALLDATETIME,
	@CustId			INT,
	@Stake			MONEY = 100,
	@Winlost		MONEY = 200,
	@Status			VARCHAR(10) = 'WON',
	@Playtype		INT = -1, -- -1 --> 266
	@GameType		VARCHAR(10) = 'BAC' -- AV01,BAC,CBAC,DT,FRU,FT,LBAC,LINK,NN,PK_J,PKBJ,ROU,SBAC,SHB,SL1,SL2,SL3,SL4,ZJH
AS

/*
	PERCY
	-- Deposit Customer only
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @recommend INT, @mrecommend INT, @srecommend INT, @username VARCHAR(50), @currency INT,
			@statusID TINYINT, @transdate SMALLDATETIME

	SELECT @recommend = c.recommend, @mrecommend = c.mrecommend, @srecommend = c.srecommend, @currency = c.currency
	FROM bodb02.dbo.custInfo c WITH (NOLOCK)
		INNER JOIN bodb02.dbo.Dep_CustSuper s WITH (NOLOCK) ON c.srecommend = s.custId
	WHERE c.custId = @CustId AND c.roleId = 1

	IF @recommend IS NULL
	BEGIN
		SELECT 'Deposit CustId only or Invalid CustId!'

		RETURN
	END

	IF @Status NOT IN ('WON','LOSE','DRAW','REJECT')
	BEGIN
		SELECT 'Support WON, LOSE, DRAW, REJECT only'

		RETURN
	END

	SELECT @StatusId = CASE @Status WHEN 'WON' THEN 112 WHEN 'LOSE' THEN 113 WHEN 'DRAW' THEN 111 WHEN 'REJECT' THEN 101 END

	IF		(@Status = 'WON' AND @stake >= @winlost)
		OR	(@Status = 'LOSE' AND @stake <= @winlost)
		OR	(@Status = 'DRAW' AND @stake <> @winlost)
		OR	(@Status = 'REJECT' AND @stake <> @winlost)
	BEGIN
		SELECT 'Status NOT MATCHING WITH stake/winlost'

		RETURN
	END

	SELECT @transdate = DATEADD(MILLISECOND, DATEDIFF(MILLISECOND, CONVERT(DATE, GETDATE()), GETDATE()), @winlostdate)

	DECLARE @TicketId BIGINT
	SELECT  @TicketId = MAX(TicketId) FROM dbo.bettrans_AGCasino WITH (NOLOCK)
	SElECT  @TicketId = @TicketId + 1

	INSERT INTO dbo.bettrans_AGCasino
	(
		TicketId,CustID,Transdate,GameType,Stake,Actual_Stake,Winlost,Status,StatusID,PlayType,Winlostdate,
		Username,IP,recommend,mrecommend,srecommend,Currency,IsVIPGame
	)
	VALUES
	(
		@TicketId,@CustID,@Transdate,@GameType,@Stake,@Stake,@Winlost,@Status,@StatusID,@PlayType,@Winlostdate,
		@Username,'',@recommend,@mrecommend,@srecommend,@Currency,0
	)
END
GO
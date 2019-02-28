USE [bodb_Summary]
GO

ALTER PROCEDURE [dbo].[DBA_BalanceUp_SUM]
	@transIds VARCHAR(MAX),
	@sporttype INT,
	@bettype INT,
	@winlostdate SMALLDATETIME,
	@numOfTickets INT,
	@srecommend INT,
	@mrecommend INT,
	@recommend INT,
	@custId INT,
	@username VARCHAR(50),
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg VARCHAR(2000) = '' OUTPUT
AS

BEGIN
	SET NOCOUNT ON

	DECLARE @turnOver MONEY, @winlost MONEY, @awinlost MONEY, @TunroverNoDraw MONEY
	SELECT  @turnOver = SUM(ABS(stake)), @winlost = SUM(winlost-actual_stake), @awinlost = SUM(awinlost),
			@TunroverNoDraw = SUM(CASE WHEN statusId = 111 AND bettype = 1004 THEN 0 ELSE ABS(stake) END)
	FROM DBTXN.bodb02.dbo.bettrans WITH (NOLOCK)
	WHERE CHARINDEX(',' + CONVERT(VARCHAR(20), transid) + ',', ',' + @transIds + ',') > 0

	DECLARE @StatusId TINYINT
	SELECT  @StatusId = statusId
	FROM DBTXN.bodb02.dbo.bettrans WITH (NOLOCK)
	WHERE CHARINDEX(',' + CONVERT(VARCHAR(20), transid) + ',', ',' + @transIds + ',') > 0

	IF NOT EXISTS (SELECT 1 FROM dbo.sum_winloss_old WITH (NOLOCK) WHERE srecommend = @srecommend AND sporttype = @sporttype AND winlostdate = @winlostdate)
	BEGIN
		INSERT INTO dbo.sum_winloss_old
		(
			winlostdate, roleid, custid, recommend, mrecommend, srecommend, username,
			turnover, winlost, awinlost, mwinlost, swinlost,
			playercomm, comm, acomm, scomm, betcount, grosscomm,
			sporttype, bettype, netTurnover, TunroverNoDraw
		)
		SELECT
			@winlostdate, roleid, @custid, @recommend, @mrecommend, @srecommend, @username,
			@turnOver, @winlost, @awinlost, 0, 0,
			0, 0, 0, 0, @numOfTickets, 0,
			@sporttype, 0, 0, @TunroverNoDraw
		FROM bodb02.dbo.custInfo WITH (NOLOCK)
		WHERE custid IN (@custid, @recommend, @mrecommend, @srecommend)
	END
	ELSE
	BEGIN
		UPDATE dbo.sum_winloss_old WITH (ROWLOCK)
		SET turnover = ISNULL(turnover, 0) + @turnOver,
			winlost = ISNULL(winlost, 0) + @winlost,
			awinlost = ISNULL(awinlost, 0) + @awinlost,
			TunroverNoDraw = ISNULL(TunroverNoDraw, 0) + @TunroverNoDraw
		WHERE sporttype = @sporttype AND winlostdate = @winlostdate
			AND (
				custid = @custid AND roleid = 1
				OR custid = @recommend AND roleid = 2
				OR custid = @mrecommend AND roleid = 3
				OR custid = @srecommend AND roleid = 4
			)
	END

	IF @@ROWCOUNT = 0
	BEGIN
		SELECT @ErrCode = 100,
				@ErrMsg = 'No row inserted'
	END
END
GO
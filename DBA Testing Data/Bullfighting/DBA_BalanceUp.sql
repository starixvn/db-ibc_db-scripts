USE [bodb02]
GO

ALTER PROCEDURE [dbo].[DBA_BalanceUp]
	@Match3rdId INT,
	@transIds VARCHAR(MAX),
	@translogIds VARCHAR(MAX),
	@sporttype INT,
	@bettype INT,
	@winlostdate SMALLDATETIME,
	@numOfTickets INT,
	@srecommend INT,
	@mrecommend INT,
	@recommend INT,
	@custId INT,
	@username VARCHAR(50)
AS

BEGIN
	SET NOCOUNT ON

	DECLARE @ErrCode INT = 0, @ErrMsg VARCHAR(2000) = ''

	EXEC DBARC.bodb_Archive.dbo.DBA_BalanceUp_BK
		@Match3rdId = @Match3rdId,
		@transIds = @transIds,
		@translogIds = @translogIds,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT

	IF @ErrCode <> 0
	BEGIN
		SELECT 'bettrans_bk: ' + @ErrMsg
		RETURN
	END

	EXEC DBAGE.bodb_Summary.dbo.DBA_BalanceUp_SUM
		@transIds = @transIds,
		@sporttype = @sporttype,
		@bettype = @bettype,
		@winlostdate = @winlostdate,
		@numOfTickets = @numOfTickets,
		@srecommend = @srecommend,
		@mrecommend = @mrecommend,
		@recommend = @recommend,
		@custId = @custId,
		@username = @username,
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT

	IF @ErrCode <> 0
	BEGIN
		SELECT 'sum_winloss_old: ' + @ErrMsg
		RETURN
	END
END
GO
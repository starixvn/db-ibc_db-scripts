/*
	Create: 20180213@Helen
	Task: https://nexdev.net/issues/90853
	DB: DBTXN/bodb02
*/
USE bodb02
GO
DECLARE @p6 INT
SET @p6=0
DECLARE @p7 NVARCHAR(200)
SET @p7=NULL

EXEC NAP_Admin_Settlement_Refund_MP_Push 
	@AdminId=8,@MatchId=23739926, @IP='10.18.200.119'
	-- Default Value
	,@Action='REFUND-FT',@SettleAbandonedMatchIBCParlay=0,@ErrCode=@p6 output,@ErrMsg=@p7 output
SELECT @p6, @p7

GO


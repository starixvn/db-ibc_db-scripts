USE bodb_Account
GO

SET NOCOUNT ON

DECLARE @rptDateFrom DATETIME = '2015-01-01'
DECLARE @rptDateTo DATETIME = '2016-04-01'
DECLARE @TopCount INT = 2000

WHILE (1 = 1)
BEGIN
	UPDATE TOP (@TopCount) dbo.mcCustCasinoHourly WITH(ROWLOCK)
	SET Actual_Stake = Stake
		,Actual_StakeRefund = StakeRefund
	WHERE rptDate BETWEEN @rptDateFrom
			AND @rptDateTo
		AND Actual_StakeRefund IS NULL

	IF @@ROWCOUNT < @TopCount RETURN
END

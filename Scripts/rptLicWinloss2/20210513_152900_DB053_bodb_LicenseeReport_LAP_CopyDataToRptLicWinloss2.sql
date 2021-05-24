/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20210512@Kos
	DB: DB053-bodb_LicenseeReport
	Task: Copy data for temp table rptLicWinloss2_UAT to main table rptLicWinloss2 [Redmine: #152900]
*/

USE bodb_LicenseeReport
GO

DECLARE @Date	SMALLDATETIME,
	@FromDate	SMALLDATETIME = '2021-01-25 00:00:00',
	@ToDate		SMALLDATETIME = '2021-05-08 00:00:00'

SET @Date = @FromDate

WHILE @Date <= @ToDate
BEGIN
	PRINT 'Copy data for ' + CONVERT(VARCHAR(20), @Date, 100)

	DELETE FROM dbo.rptLicWinloss2 WITH (ROWLOCK)
	WHERE winlostdate = @Date AND sporttype = 0

	INSERT INTO rptLicWinloss2 (
		[winlostdate]
		,[username]
		,[username2]
		,[custid]
		,[roleid]
		,[recommend]
		,[mrecommend]
		,[srecommend]
		,[turnover]
		,[winlost]
		,[BetEffective]
		,[awinlost]
		,[mwinlost]
		,[swinlost]
		,[playercomm]
		,[comm]
		,[acomm]
		,[scomm]
		,[winlostvirtual]
		,[commvirtual]
		,[BetCount]
		,[Currency]
		,[sporttype]
		,[bettype]
		,[statusID]
		,[isBA]
		,[isMobile]
		,[betfrom]
		,[BuyBackAmt]
		,[BABuyBackAmt]
		)
	SELECT [winlostdate]
		,[username]
		,[username2]
		,[custid]
		,[roleid]
		,[recommend]
		,[mrecommend]
		,[srecommend]
		,[turnover]
		,[winlost]
		,[BetEffective]
		,[awinlost]
		,[mwinlost]
		,[swinlost]
		,[playercomm]
		,[comm]
		,[acomm]
		,[scomm]
		,[winlostvirtual]
		,[commvirtual]
		,[BetCount]
		,[Currency]
		,[sporttype]
		,[bettype]
		,[statusID]
		,[isBA]
		,[isMobile]
		,[betfrom]
		,[BuyBackAmt]
		,[BABuyBackAmt]
	FROM rptLicWinloss2_UAT WITH (NOLOCK)
	WHERE winlostdate = @Date AND sporttype = 0

	SET @Date = DATEADD(DAY, 1, @Date)

	PRINT 'Done'

	WAITFOR DELAY '00:00:00.280'
END
GO
/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210504@Kos
	DB: DBLIC-bodb_LicenseeReport
	Task: Copy data for temp table DBRPT.bodb_Report.dbo.rptLicWinloss2_UAT to table DBLIC.bodb_LicenseeReport.dbo.rptLicWinloss2_UAT for testing [Redmine: #152900]
*/

USE bodb_LicenseeReport
GO

DECLARE @Date	SMALLDATETIME,
	@FromDate	SMALLDATETIME = '2021-01-25 00:00:00',
	@ToDate		SMALLDATETIME = '2021-04-15 00:00:00'

SET @Date = @FromDate

WHILE @Date <= @ToDate
BEGIN
	PRINT 'Copy data for ' + CONVERT(VARCHAR(20), @Date, 100)

	DELETE FROM dbo.rptLicWinloss2_UAT WITH (ROWLOCK)
	WHERE winlostdate = @Date

	DECLARE @TSql VARCHAR(8000)

	SELECT @TSql = 'SELECT [winlostdate]
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
		FROM OPENQUERY(DBRPT,''SELECT * FROM bodb_Report.dbo.rptLicWinloss2_UAT WITH (NOLOCK) WHERE winlostdate = ''''' + CONVERT(VARCHAR, @Date, 101) + ''''''')'

	INSERT INTO rptLicWinloss2_UAT (
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
	EXEC (@TSql)

	SET @Date = DATEADD(DAY, 1, @Date)

	PRINT 'Done'

	WAITFOR DELAY '00:00:00.280'
END
GO
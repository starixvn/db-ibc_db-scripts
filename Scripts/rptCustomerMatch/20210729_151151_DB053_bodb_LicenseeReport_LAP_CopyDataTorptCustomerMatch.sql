/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20210726@Kos
	DB: DB053-bodb_LicenseeReport
	Task: Copy data for temp table DBRPT.bodb_Report.dbo.rptCustomerMatch_UAT to table DB053.bodb_LicenseeReport.dbo.rptCustomerMatch [Redmine: #151151]
*/

USE bodb_LicenseeReport
GO

DECLARE @Date	SMALLDATETIME,
	@FromDate	SMALLDATETIME = '2021-06-01 00:00:00',
	@ToDate		SMALLDATETIME = '2021-07-15 00:00:00'

SET @Date = @FromDate

WHILE @Date <= @ToDate
BEGIN
	PRINT 'Copy data for ' + CONVERT(VARCHAR(20), @Date, 100)

	DELETE FROM dbo.rptCustomerMatch WITH (ROWLOCK)
	WHERE winlostdate = @Date

	DECLARE @TSql VARCHAR(8000)

	SELECT @TSql = 'SELECT
		custid
		,matchid
		,oddsid
		,LeagueID
		,bettype
		,Odds
		,oddstype
		,statusID
		,stake
		,winlost
		,winlostdate
		,awinlost
		,Comm
		,playercomm
		,recommend
		,isba
		,betcount
		,currency
		,LiveIndicator
		FROM OPENQUERY(DBRPT,''SELECT * FROM bodb_Report.dbo.rptCustomerMatch_UAT WITH (NOLOCK) WHERE winlostdate = ''''' + CONVERT(VARCHAR, @Date, 101) + ''''''')'

	INSERT INTO rptCustomerMatch (
		custid
		,matchid
		,oddsid
		,LeagueID
		,bettype
		,Odds
		,oddstype
		,statusID
		,stake
		,winlost
		,winlostdate
		,awinlost
		,Comm
		,playercomm
		,recommend
		,isba
		,betcount
		,currency
		,LiveIndicator
		)
	EXEC (@TSql)

	SET @Date = DATEADD(DAY, 1, @Date)

	PRINT 'Done'

	WAITFOR DELAY '00:00:00.280'
END
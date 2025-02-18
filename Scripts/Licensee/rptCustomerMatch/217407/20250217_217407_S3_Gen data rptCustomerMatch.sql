/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20250217@Kelvin
	DB: DBLIC-bodb_LicenseeReport
	Task: Task: Regen data on rptCustomerMatch [Redmine: #217407]
		S3: Regen data for rptCustomerMatch
*/

DECLARE @MoveBetsDay	SMALLDATETIME,
		@BalanceUpDate	SMALLDATETIME,
		@WinLostDate	DATETIME = '2025-02-01'

DECLARE @TSql NVARCHAR(MAX)

DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
EXEC bodb02.dbo.Age_SelBalanceUpDay

SELECT @BalanceUpDate = BalanceUpDay, @MoveBetsDay = MoveBetsDay
FROM @MBBU

--SELECT * FROM @MBBU

DECLARE @SportBettype TABLE(BetType SMALLINT)

INSERT INTO @SportBettype
SELECT BetType
FROM bodb02.dbo.f_SportBettypeMatrix_Sel (0, 0, 0, 2, '', '', 1)
WHERE ProductID IN (
					5, 27, 77, 83, 88, 71 -- VS product
					)

WHILE @WinLostDate <= @MoveBetsDay
BEGIN
	PRINT 'Generate data for ' + CONVERT(VARCHAR(20), @WinLostDate, 101)

	IF @WinLostDate < @BalanceUpDate
		BEGIN
			DELETE rpt
			FROM dbo.rptCustomerMatch rpt
			WHERE winlostdate = @WinLostDate
				AND EXISTS (SELECT 1 FROM @SportBettype s WHERE s.BetType = rpt.bettype)

			SELECT @TSql = '
				SELECT
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
					,comm
					,playercomm
					,recommend
					,isba
					,betcount
					,currency
					,LiveIndicator
					,TicketType
				FROM OPENQUERY(DBRPT,''SELECT * FROM bodb_Report.dbo.rptCustomerMatch_staging_217407 WITH (NOLOCK) WHERE winlostdate = ''''' + CONVERT(VARCHAR, @WinLostDate, 101) + ''''''')'

			INSERT INTO dbo.rptCustomerMatch (
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
				,comm
				,playercomm
				,recommend
				,isba
				,betcount
				,currency
				,LiveIndicator
				,TicketType
				)
			EXEC sp_executesql @TSql

		END
	ELSE
		BEGIN
			EXEC Task_rptCustomerMatch_Bettrans14 @Date = @WinLostDate
		END
	
	SET @WinLostDate = DATEADD(D,1,@WinLostDate)

	WAITFOR DELAY '00:00:00.280'
END
/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G" isFunction="0" isNested="0"></info>*/
/*
	Created: 20230519@Sally
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: 
	Step 0
		- Backup data rptMemberDaily, afftrans 2023-04		
*/  
--1.  Backup data rptMemberDaily
	DECLARE @FromDate SMALLDATETIME ='2023-03-30'
		,@ToDate SMALLDATETIME ='2023-05-02'

	SELECT *
	INTO rptMemberDaily_Temp20230519
	FROM dbO.rptMemberDaily R WITH (NOLOCK)
	WHERE R.WinlostDate >= @FromDate
		AND R.WinlostDate < @ToDate
	CREATE CLUSTERED INDEX IX_rptMemberDaily_Temp20230519_WinlostDate ON rptMemberDaily_Temp20230519 (WinlostDate)
GO
--2.  Backup data afftrans 2023-04	

	DECLARE @FromDate SMALLDATETIME ='2023-03-30'
		,@ToDate SMALLDATETIME ='2023-05-02'
	SELECT *
	INTO afftrans_Temp20230519
	FROM dbO.afftrans R WITH (NOLOCK)
	WHERE R.TransDate >= @FromDate
		AND R.TransDate < @ToDate

GO
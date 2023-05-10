/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G" isFunction="0" isNested="0"></info>*/
/*
	Created: 20230509@Evan
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: Re cal missing ticket V8 Poker
	Step 2: Gen data into rptMemberDaily
*/  

DECLARE @TimeZone SMALLINT
SELECT  @TimeZone = CONVERT(SMALLINT, SValue) FROM dbo.SystemSettings WITH (NOLOCK) WHERE SName = 'TimeZone'
DECLARE @WinlostDate SMALLDATETIME;
SELECT @WinlostDate = '20230427'
SELECT  @WinlostDate = DATEADD(HOUR, @TimeZone, @WinlostDate)

EXEC Task_Aff_ImportData @WinlostDate = @WinlostDate
EXEC Task_Aff_Monthly_Commission @MonthDate = @WinlostDate, @IsForceUpdate = 1;

GO


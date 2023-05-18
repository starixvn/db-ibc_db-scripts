/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G" isFunction="0" isNested="0"></info>*/
/*
	Created: 20230518@Sally
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: 
	Step 1
		- Delete wrong data rptMemberDaily
		- Regen data missing into rptMemberDaily		
*/  

DELETE r
FROM dbo.rptMemberDaily r (ROWLOCK)
WHERE r.WinlostDate ='2023-04-27 08:00:00'
;
DECLARE @WinlostDate SMALLDATETIME = '2023-04-27'
EXEC Task_Aff_ImportData @WinlostDate = @WinlostDate
GO

/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G" isFunction="0" isNested="0"></info>*/
/*
	Created: 20230518@Sally
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: 
	Step 2
		- ReCalculate monthly commission 
		
*/  

DECLARE @WinlostDate SMALLDATETIME = '2023-04-27'

EXEC Task_Aff_Monthly_Commission @MonthDate = @WinlostDate, @IsForceUpdate = 1;
GO

/*<info serverAlias="DBAFFN88-Affiliate_N8G" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20220406@Malcolm
	DB: DBAFFN88-Affiliate_N8G
	Task: Regen Data
*/
--Step 1: Update GroupId from 2 to 8 for March
--1 affected row

UPDATE AffGroupHistory WITH(ROWLOCK)
	SET GroupId = 8
WHERE MonthDate = '2022-03-31' AND AffId = 447

--Step 2: Run job to calculate commission for March
EXEC dbo.Task_Aff_Monthly_Commission @MonthDate = '2022-03-01', @IsForceUpdate = 1
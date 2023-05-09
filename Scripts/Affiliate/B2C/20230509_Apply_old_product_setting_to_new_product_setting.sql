/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G"></info>*/
/*
	Created: 20230509@Evan
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: Apply old product setting to new product setting
*/

-- Delete setting of new product
DELETE 
FROM DeductionSetting WITH(ROWLOCK) 
WHERE ProductId IN (69,70,71,73,74,96,75,72,95)

-- Apply old product setting to new product setting
INSERT INTO DeductionSetting (GroupId,DeductionId,ProductId,GroupProductId,DeductedPercentage,DeductedAmount,IsDeductedPercent)
SELECT 	GroupId,
		DeductionId,
		CASE WHEN ProductId = 1 THEN 69	
			WHEN ProductId = 2 THEN 70	
			WHEN ProductId = 3 THEN 71	
			WHEN ProductId = 5 THEN 73	
			WHEN ProductId = 19 THEN 74	
			WHEN ProductId = 21 THEN 96	
			WHEN ProductId = 23 THEN 75	
			WHEN ProductId = 24 THEN 72	
			WHEN ProductId = 59 THEN 95	
		END,
		GroupProductId,
		DeductedPercentage,
		DeductedAmount,
		IsDeductedPercent
FROM DeductionSetting WITH(NOLOCK)
WHERE ProductId IN (1,2,3,5,19,21,23,24,59)

INSERT INTO DeductionSettingHistory(GroupId,MonthDate,DeductionId,ProductId,GroupProductId,DeductedPercentage,DeductedAmount,IsDeductedPercent)
SELECT	GroupId,
		MonthDate,
		DeductionId,
		CASE WHEN ProductId = 1 THEN 69	
			WHEN ProductId = 2 THEN 70	
			WHEN ProductId = 3 THEN 71	
			WHEN ProductId = 5 THEN 73	
			WHEN ProductId = 19 THEN 74	
			WHEN ProductId = 21 THEN 96	
			WHEN ProductId = 23 THEN 75	
			WHEN ProductId = 24 THEN 72	
			WHEN ProductId = 59 THEN 95	
		END,
		GroupProductId,
		DeductedPercentage,
		DeductedAmount,
		IsDeductedPercent 
FROM DeductionSettingHistory WITH(NOLOCK)
WHERE ProductId IN (1,2,3,5,19,21,23,24,59) AND MonthDate > '20230430'

GO

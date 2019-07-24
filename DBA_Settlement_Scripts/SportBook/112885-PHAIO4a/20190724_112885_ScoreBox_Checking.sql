/*	
	Created: 20190724@Sol
	Task: Create rules to check betcheck field format [Redmine:#115232]
	DB: DBTXN/bodb02

	Description:
		#Rule 1 - Checking first character of the [betcheck] field is equal with [hdp1] field or not
		#Rule 2 - Checking number of sub-sequences of the [betcheck] field is equal with [hdp2] field or not
		#Rule 3 - Checking consecutive number of sub-sequences
		#Rule 4 - Checking total number after decimal point of each sub-sequences 
*/

USE bodb02 

go 

DECLARE @matchid INT = xxx

SELECT matchid, transid, bettype, betcheck, hdp1, hdp2, oddsspread, odds
INTO #temp
FROM bettrans WITH (NOLOCK)
WHERE matchid = @matchid AND bettype IN (468, 469)

SELECT  matchid, transid, bettype, betcheck, hdp1, hdp2, oddsspread, odds
		, '#Rule 1' = CASE WHEN left(betcheck, CASE WHEN charindex(':', betcheck) > 0 THEN charindex(':', betcheck) - 1 ELSE 0 END) = hdp1 THEN '#1 Passed' ELSE '#1 Failed' END
		, '#Rule 2' = CASE WHEN len(betcheck) - len(replace(betcheck,':','')) = hdp2 and len(betcheck) - len(replace(betcheck,',','')) = hdp2 - 1 THEN '#2 Passed' ELSE '#2 Failed' END
		, '#Rule 3' = CASE WHEN f.IsFailed = 0  THEN '#3 Passed' ELSE '#3 Failed' END
		, '#Rule 4' = CASE WHEN f1.IsFailed = 0 THEN '#4 Passed' ELSE '#4 Failed' END
FROM #temp b WITH(NOLOCK)
	CROSS APPLY 
	(
		SELECT
			SUM(CASE WHEN f.val + 1 = f1.val THEN 0 ELSE 1 END) IsFailed
		FROM 
			(
				SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) num1, CAST(LEFT(f.val,CHARINDEX(':', f.val) - 1) AS INT) val 
				FROM f_SplitString(betcheck, ',') f
			) f
				INNER JOIN (
								SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) + 1 num2, CAST(LEFT(f.val,CHARINDEX(':', f.val) - 1) AS INT) val 
								FROM f_SplitString(betcheck, ',') f
							) f1
					on f.num1 = f1.num2
	) f
	CROSS APPLY 
	(
		SELECT
			SUM(CASE WHEN LEN(f.val) <= 2 THEN 0 ELSE 1 END) IsFailed
		FROM 
			(
				SELECT RIGHT(f.val,LEN(f.val) - CHARINDEX('.', f.val)) val 
				from f_SplitString(betcheck, ',') f
			) f
	) f1

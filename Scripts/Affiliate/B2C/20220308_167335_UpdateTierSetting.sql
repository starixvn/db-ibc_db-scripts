/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G"></info>*/
/*
	Created: 20220308@Malcolm
	DB: DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G
	Task: Update Tiersetting
*/

DECLARE @MonthData DATETIME = '2022-04-01'

DELETE FROM dbo.TierSetting WITH(ROWLOCK, UPDLOCK) 

;WITH CTE AS (
	SELECT GroupId, GroupProductId
	FROM dbo.DeductionSetting WITH(NOLOCK)
	GROUP BY GroupId, GroupProductId
)
INSERT INTO dbo.TierSetting (GroupId, TierId, MinAmount, MaxAmount, MinAM, MaxAM, Commission, GroupProductId, IsActivePlayerSum)
SELECT e.GroupId, 1 AS TierId, 0 AS MinAmount, 100000000000 AS MaxAmount, 0 AS MinAM, 1000000000 AS MaxAM, 0 AS Commission, e.GroupProductId, 1
FROM CTE e

DELETE FROM dbo.TierSettingHistory WITH(ROWLOCK, UPDLOCK) WHERE MonthDate >= @MonthData

;WITH CTE AS (
	SELECT GroupId, GroupProductId, MonthDate
	FROM dbo.DeductionSettingHistory WITH(NOLOCK)
	WHERE MonthDate >= @MonthData
	GROUP BY GroupId, GroupProductId, MonthDate
)
INSERT INTO dbo.TierSettingHistory(GroupId, MonthDate, TierId, MinAmount, MaxAmount, MinAM, MaxAM, Commission, GroupProductId, IsActivePlayerSum)
SELECT e.GroupId, e.MonthDate, 1 AS TierId, 0 AS MinAmount,  100000000000 AS MaxAmount, 0 AS MinAM, 1000000000 AS MaxAM, 0 AS Commission, e.GroupProductId, 1
FROM CTE e



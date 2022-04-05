/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G"></info>*/
/*
	Created: 20220308@Malcolm
	DB: DBAFFN88-Affiliate_N88
	Task: Update Tiersetting
*/

DECLARE @MonthData DATETIME = '2022-04-01'

;WITH CTE AS (
	SELECT GroupId, GroupProductId
	FROM dbo.DeductionSetting WITH(NOLOCK)
	GROUP BY GroupId, GroupProductId
)
INSERT INTO dbo.TierSetting (GroupId, TierId, MinAmount, MaxAmount, MinAM, MaxAM, Commission, GroupProductId, IsActivePlayerSum)
SELECT e.GroupId, t.TierId, t.MinAmount, t.MaxAmount, t.MinAM, t.MaxAM, t.Commission, e.GroupProductId, 1
FROM CTE e
	INNER JOIN dbo.TierSetting t ON e.GroupId = t.GroupId

DELETE FROM dbo.TierSetting WITH(ROWLOCK, UPDLOCK) WHERE ISNULL(GroupProductId, 0) = 0

;WITH CTE AS (
	SELECT GroupId, GroupProductId, MonthDate
	FROM dbo.DeductionSettingHistory WITH(NOLOCK)
	WHERE MonthDate >= @MonthData
	GROUP BY GroupId, GroupProductId, MonthDate
)
INSERT INTO dbo.TierSettingHistory(GroupId, MonthDate, TierId, MinAmount, MaxAmount, MinAM, MaxAM, Commission, GroupProductId, IsActivePlayerSum)
SELECT e.GroupId, e.MonthDate, t.TierId, t.MinAmount, t.MaxAmount, t.MinAM, t.MaxAM, t.Commission, e.GroupProductId, 1
FROM CTE e
	INNER JOIN dbo.TierSettingHistory t ON e.GroupId = t.GroupId AND e.MonthDate = t.MonthDate

DELETE FROM dbo.TierSettingHistory WITH(ROWLOCK, UPDLOCK) WHERE ISNULL(GroupProductId, 0) = 0 AND MonthDate >= @MonthData

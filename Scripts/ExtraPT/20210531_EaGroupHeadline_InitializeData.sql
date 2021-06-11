USE NAP_UserControl
GO

-- Get Headline - Super
CREATE TABLE #GroupHeadline (GroupHeadlineId INT, SiteId INT, ExchangeId INT, ExternalGroup VARCHAR(50), PrimaryExtraPTGroup VARCHAR(50), FromDate DATETIME, ToDate DATETIME)
INSERT INTO #GroupHeadline (GroupHeadlineId, SiteId, ExchangeId, ExternalGroup, PrimaryExtraPTGroup, FromDate, ToDate)
SELECT cgh.GroupId AS GroupHeadlineId, ss.SiteId, s.Currency, cg.GroupName, e.GroupName, MIN(e.FromDate) AS FromDate, MAX(e.ToDate) AS ToDate
FROM CustDB.dbo.CustGroupHeadline cgh WITH (NOLOCK)
	INNER JOIN CustDB.dbo.Customer ch WITH (NOLOCK) ON cgh.CustId = ch.CustId AND ch.Currency <> 20 -- Headline
	INNER JOIN CustDB.dbo.CustAccount ca WITH (NOLOCK) ON cgh.GroupId = ca.GroupId AND cgh.GroupId <> 0
	INNER JOIN CustDB.dbo.Customer s WITH (NOLOCK) ON ca.CustId = s.CustId AND s.RoleId = 4 AND s.Currency <> 20 -- Super
	INNER JOIN CustDB.dbo.Site ss WITH (NOLOCK) ON s.site = ss.site
	LEFT JOIN CustDB.dbo.Acc_CustGroup cg WITH (NOLOCK) ON s.CustId = cg.CustId
	LEFT JOIN (
		SELECT SuperId, GroupName, MIN(FromDate) AS FromDate, MAX(ToDate) AS ToDate
		FROM CustDB.dbo.Acc_GroupExtraPTSetting WITH (NOLOCK)
		WHERE '2021-06-11' < ToDate
		GROUP BY SuperId, GroupName
	) e ON s.CustId = e.SuperId
WHERE cg.GroupName IS NOT NULL OR e.GroupName IS NOT NULL
GROUP BY cgh.GroupId, ss.SiteId, s.Currency, cg.GroupName, e.GroupName

-- Insert data --> will be replace by real table
CREATE TABLE #EaGroupHeadline (GroupHeadlineId INT, GroupId INT, GroupName VARCHAR(50), SiteId INT, ExchangeId INT, GroupTypeId TINYINT, EffectiveDate DATETIME)
INSERT INTO #EaGroupHeadline (GroupHeadlineId, GroupId, GroupName, SiteId, ExchangeId, GroupTypeId, EffectiveDate)
SELECT DISTINCT t.GroupHeadlineId, g.GroupId, t.GroupName, t.SiteId, t.ExchangeId
	,CASE WHEN t.GroupTypeId = 0 AND e.GroupName IS NOT NULL THEN 1 ELSE t.GroupTypeId END AS GroupTypeId
	,t.FromDate AS EffectiveDate
FROM (
	SELECT cg.GroupHeadlineId, cg.SiteId, cg.ExchangeId, g.GroupName, g.GroupTypeId, g.FromDate, g.ToDate
	FROM #GroupHeadline cg
		CROSS APPLY (
			SELECT PrimaryExtraPTGroup AS GroupName, FromDate, ToDate, CONVERT(TINYINT, 2) AS GroupTypeId
			UNION
			SELECT ExternalGroup, NULL, NULL, 0 WHERE ExternalGroup <> PrimaryExtraPTGroup
		) g
) t
	INNER JOIN dbo.EaGroup g WITH (NOLOCK) ON t.GroupName = g.GroupName AND g.ParentId = 0
	LEFT JOIN CustDB.dbo.Acc_DWLList_ExtraPT e WITH (NOLOCK) ON t.GroupName = e.GroupName

DELETE e1
FROM #EaGroupHeadline e1
	INNER JOIN #EaGroupHeadline e2 ON e1.GroupHeadlineId = e2.GroupHeadlineId AND e1.SiteId = e2.SiteId AND e1.ExchangeId = e2.ExchangeId
WHERE e1.GroupTypeId = 1 AND e2.GroupTypeId = 2 AND e1.GroupName = e2.GroupName

DELETE e
FROM (
	SELECT *,ROW_NUMBER() OVER(PARTITION BY GroupHeadlineId, GroupName, SiteId, ExchangeId ORDER BY EffectiveDate) AS RN
	FROM #EaGroupHeadline
	WHERE GroupTypeId = 2
) e
WHERE RN > 1

-- View data
/*
;WITH CTE_Data AS
(
	SELECT t.*, c.UserName AS HeadlineName, s.Site, e.Currency
		, ROW_NUMBER() OVER(PARTITION BY t.GroupHeadlineId, t.SiteId, t.ExchangeId
							ORDER BY CASE WHEN t.EffectiveDate > '2021-06-11' OR t.GroupTypeId <> 2 THEN 1 ELSE 0 END, t.EffectiveDate DESC) AS RN
	FROM #EaGroupHeadline t
		INNER JOIN CustDB.dbo.CustGroupHeadline cgh WITH (NOLOCK) ON t.GroupHeadlineId = cgh.GroupId
		INNER JOIN CustDB.dbo.Customer c WITH (NOLOCK) ON cgh.CustId = c.CustId
		INNER JOIN CustDB.dbo.Site s WITH (NOLOCK) ON t.SiteId = s.SiteId
		INNER JOIN CustDB.dbo.Exchange e WITH (NOLOCK) ON t.ExchangeId = e.ExchangeId
)
SELECT GroupHeadlineId, HeadlineName, SiteId, Site, ExchangeId, Currency
	,ISNULL(STUFF((SELECT ', ' + d2.GroupName
			FROM CTE_Data d2
			WHERE d2.GroupHeadlineId = d1.GroupHeadlineId AND d2.SiteId = d1.SiteId AND d2.ExchangeId = d1.ExchangeId
				AND d2.GroupTypeId = 0
			FOR XML PATH('')), 1, 1, ''), '') AS NormalGroup
	,ISNULL(STUFF((SELECT ', ' + d2.GroupName
			FROM CTE_Data d2
			WHERE d2.GroupHeadlineId = d1.GroupHeadlineId AND d2.SiteId = d1.SiteId AND d2.ExchangeId = d1.ExchangeId
				AND d2.GroupTypeId IN (1, 2) AND d2.GroupName <> ''
			FOR XML PATH('')), 1, 2, ''), '') AS ExtraPTGroup
	,ISNULL(STUFF((SELECT ', ' + ISNULL(NULLIF(d2.GroupName, ''), 'No Extra PT') + ISNULL('(' + CONVERT(VARCHAR(10), d2.EffectiveDate, 101) + ')', '')
			FROM CTE_Data d2
			WHERE d2.GroupHeadlineId = d1.GroupHeadlineId AND d2.SiteId = d1.SiteId AND d2.ExchangeId = d1.ExchangeId
				AND d2.GroupTypeId = 2
			FOR XML PATH('')), 1, 2, ''), '') AS PrimaryExtraPTGroup
FROM CTE_Data d1
GROUP BY GroupHeadlineId, HeadlineName, SiteId, Site, ExchangeId, Currency
ORDER BY HeadlineName, Site, Currency
*/

DROP TABLE #EaGroupHeadline
DROP TABLE #GroupHeadline
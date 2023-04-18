/*<info serverAlias="DBCUST-CustDB"></info>*/

/*
	Created: 20230306@Malcolm
	DB: DBCUST-CustDB
	Task: Update Site Name [RedmineID: #181596]

*/

DECLARE @Groupheadline TABLE (GroupHeadlineId INT, Headline VARCHAR(30), SiteNameNew NVARCHAR(50))

INSERT INTO @Groupheadline (GroupHeadlineId, Headline, SiteNameNew)
VALUES 
(827,'8K01','y889')
,(814,'8U01','y889')
,(941,'9S','y889')
,(839,'BC1','y889')
,(933,'DTE113','y889')
,(936,'DTE131','y889')
,(866,'DTE249','y889')
,(885,'DTF233','y889')
,(848,'ET789HL','y789')
,(847,'ET889HL','y889')
,(255,'KKKUSD','yOther')
,(824,'SD67','y889')
,(143,'SDD','yOther')
,(926,'SupertestCa01','yOther')
,(567,'SupertestTE10','yOther')
,(821,'V3901','y889')
,(867,'XU1','y889')
,(515,'ZU01','yUT')

;WITH CTE AS 
(
	SELECT g.GroupHeadlineId, s.siteid
	FROM @Groupheadline g 
		INNER JOIN dbo.Site s WITH(NOLOCK) ON s.site = g.SiteNameNew
)
UPDATE ea WITH(ROWLOCK, UPDLOCK)	
	SET ea.SiteId = e.siteid
FROM EaGroupHeadline ea
	INNER JOIN CTE e ON e.GroupHeadlineId = ea.GroupHeadlineId
WHERE ea.SiteId = 3




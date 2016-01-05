/*
	Created: Dominic
	Date: 2016-01-04
	Task: #49344 - Backup a list of members to be ungrouped
	Run at: DBCUST.CustDB
*/  

CREATE TABLE BkCustomer49344 (
	CustID INT PRIMARY KEY CLUSTERED
	, Recommend INT
	)

INSERT BkCustomer49344 (
	CustID
	, Recommend
	)
SELECT ci.custid
	, ci.recommend
FROM custInfo ci WITH (NOLOCK)
INNER JOIN CustPTGroupSetting3rd_Member gcs WITH (NOLOCK)
	ON ci.recommend = gcs.AgentID
		AND gcs.SportType = 44
		AND gcs.BetType = 1
		AND gcs.IsLive = 0
INNER JOIN CustSettingMode3rd m WITH (NOLOCK)
	ON m.CustID = ci.custid
WHERE ci.roleid = 1
	AND ci.srecommend NOT IN (
		13869621, 5340162, 12262401, 12141653, 4138910, 6379932, 16112208, 12141529, 1539339, 720475
		--UUS
		, 17287861, 18879367, 14373244, 18362423, 18479460, 18289591
		)
	AND m.IsGrouped = 1

--DROP TABLE BkCustomer49344

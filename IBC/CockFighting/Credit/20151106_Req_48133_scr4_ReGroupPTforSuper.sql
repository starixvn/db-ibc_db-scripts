DECLARE @srecommend INT = 1

CREATE TABLE #CustomerTemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	Recommend INT
)

CREATE TABLE #UnGroupedCustomer
(
	CustID INT PRIMARY KEY CLUSTERED,
	Recommend INT
)

CREATE TABLE #GroupedCustomer
(
	CustID INT PRIMARY KEY CLUSTERED,
)

CREATE TABLE #tempData (recommend int, custid int, cs1 bigint, cs2 int)
CREATE TABLE #tempGroup(recommend int, cs1 bigint, cs2 int, memberCNT int, repCustID int)

--Get a list of customers that are using PT Group
INSERT #CustomerTemp(CustID,Recommend)
SELECT ci.CustID,ci.recommend
FROM dbo.CustSettingMode3rd m WITH(NOLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK)
		ON m.CustID = ci.custid
WHERE IsGrouped = 1 AND ci.srecommend = @srecommend AND ci.roleid = 1

--Get representative CustID
;WITH _s as (
	SELECT c.recommend, c.custid	
		,rdSetting = CAST(DENSE_RANK() OVER(ORDER BY sporttype, bettype, islive, superPT, masterPT, agentPT, isAutoMasterPT, AutoMasterPT, isAutoSuperPT, AutoSuperPT) as INT)
		,rdProduct = CAST(DENSE_RANK() OVER(ORDER BY sporttype, bettype, islive) as INT)
	FROM #CustomerTemp c WITH(NOLOCK)
		INNER JOIN dbo.CustPTSetting3rd_Member pt WITH(NOLOCK) ON c.custid = pt.custid AND pt.SportType = 206 AND pt.BetType = 1003		
)
INSERT INTO #tempdata (recommend, custid, cs1, cs2)
SELECT recommend, custid, SUM(CONVERT(bigint,rdSetting) + POWER(2, rdProduct%10+1)), CHECKSUM_AGG(CHECKSUM(HASHBYTES('SHA1', CONVERT(nvarchar(max), rdSetting))))
FROM _s
group by recommend, custid

INSERT INTO #tempGroup(recommend, cs1, cs2, memberCNT, repCustID)
SELECT recommend, cs1, cs2, memberCnt, repCustID
FROM (
	SELECT recommend, cs1, cs2, rn = ROW_NUMBER() OVER (partition by recommend ORDER BY count(1) desc, max(custid) desc), memberCnt = count(1), repCustID = max(custid)
	FROM #tempdata
	GROUP BY recommend, cs1, cs2
) x
WHERE rn = 1

--Get a list of customers that do not continue using PT Group 
INSERT INTO #UnGroupedCustomer(CustID,Recommend)
SELECT c.CustID,c.Recommend
FROM #CustomerTemp c WITH(NOLOCK)
	INNER JOIN #tempdata tmp1 WITH(NOLOCK)
		ON tmp1.custid = c.CustID
	INNER JOIN #tempGroup tmp2 WITH(NOLOCK)
		ON tmp1.recommend = tmp2.recommend
WHERE tmp1.cs2 <> tmp2.cs2 OR tmp1.cs1 <> tmp2.cs1

--Get a list of customers that continue using PT Group 
INSERT INTO #GroupedCustomer(CustID)
SELECT c.CustID
FROM #CustomerTemp c WITH(NOLOCK)
	INNER JOIN #tempdata tmp1 WITH(NOLOCK)
		ON tmp1.custid = c.CustID
	INNER JOIN #tempGroup tmp2 WITH(NOLOCK)
		ON tmp1.recommend = tmp2.recommend
WHERE tmp1.cs2 = tmp2.cs2 AND tmp1.cs1 = tmp2.cs1


--Insert Individual PT for customers that do not continue using PT Group 
INSERT INTO [dbo].[CustPTSetting3rd_Member]
	   ([CustID]
	   ,[SportType]
	   ,[BetType]
	   ,[IsLive]
	   ,[SuperPT]
	   ,[MasterPT]
	   ,[AgentPT]
	   ,[IsAutoMasterPT]
	   ,[AutoMasterPT]
	   ,[IsAutoSuperPT]
	   ,[AutoSuperPT])
SELECT c.CustID
	  ,cs.[SportType]
	  ,cs.[BetType]
	  ,cs.[IsLive]
	  ,cs.[SuperPT]
	  ,cs.[MasterPT]
	  ,cs.[AgentPT]
	  ,cs.[IsAutoMasterPT]
	  ,cs.[AutoMasterPT]
	  ,cs.[IsAutoSuperPT]
	  ,cs.[AutoSuperPT]
FROM [dbo].[CustPTGroupSetting3rd_Member] cs WITH(NOLOCK)
	INNER JOIN #UnGroupedCustomer c WITH(NOLOCK)
		ON c.Recommend = cs.AgentID

--Update IsGrouped=0 for customers that do not continue using PT Group 		
UPDATE dbo.CustSettingMode3rd
SET IsGrouped = 0
WHERE CustID IN (SELECT CustID FROM #UnGroupedCustomer WITH(NOLOCK)) 

--Insert setting of PT Group for Cock Fighting
INSERT INTO [dbo].[CustPTGroupSetting3rd_Member]
	   ([AgentID]
	   ,[SportType]
	   ,[BetType]
	   ,[IsLive]
	   ,[SuperPT]
	   ,[MasterPT]
	   ,[AgentPT]
	   ,[IsAutoMasterPT]
	   ,[AutoMasterPT]
	   ,[IsAutoSuperPT]
	   ,[AutoSuperPT])
	SELECT tmp.recommend
	  ,[SportType]
	  ,[BetType]
	  ,[IsLive]
	  ,[SuperPT]
	  ,[MasterPT]
	  ,[AgentPT]
	  ,[IsAutoMasterPT]
	  ,[AutoMasterPT]
	  ,[IsAutoSuperPT]
	  ,[AutoSuperPT]
	FROM [dbo].[CustPTSetting3rd_Member] mb WITH(NOLOCK)
		INNER JOIN #tempGroup tmp 
			ON mb.CustID = tmp.repCustID
				AND mb.SportType = 206
				AND mb.BetType = 1003

--Delete redundant individual setting				
DELETE cs
FROM [dbo].[CustPTSetting3rd_Member] cs WITH(NOLOCK)
	INNER JOIN #GroupedCustomer temp1 WITH(NOLOCK)
		ON cs.CustID = temp1.CustID
WHERE cs.SportType = 206 AND cs.BetType = 1003
	



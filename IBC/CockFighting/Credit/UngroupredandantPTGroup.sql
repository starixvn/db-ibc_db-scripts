CREATE TABLE #tmp
(
	CustID INT PRIMARY KEY CLUSTERED,
	Recommend INT
)

INSERT #tmp(CustID,	Recommend)
select ci.custid,ci.recommend
from custInfo ci with(nolock)
inner join CustPTGroupSetting3rd_Member gcs with(nolock) on ci.recommend = gcs.AgentID and gcs.SportType = 44 and gcs.BetType = 1 and gcs.IsLive=0
inner join CustSettingMode3rd m with(nolock) on m.CustID = ci.custid
where ci.roleid=1 and ci.srecommend not in
(
13869621,
5340162,
12262401,
12141653,
4138910,
6379932,
16112208,
12141529,
1539339,
720475
) and m.IsGrouped = 1

--DROP TABLE #tmp

--select COUNT(1) from #tmp

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
SELECT t.custid
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
FROM #tmp t with(nolock)
inner join [dbo].[CustPTGroupSetting3rd_Member] cs with(nolock)
	on t.recommend = cs.AgentID

/*

DELETE cs
FROM CustPTSetting3rd_Member cs
inner join CustSettingMode3rd m with(nolock) on m.CustID = cs.CustID
where IsGrouped = 1

*/	

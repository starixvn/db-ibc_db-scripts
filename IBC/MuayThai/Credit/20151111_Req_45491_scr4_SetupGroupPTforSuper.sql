/*
	Created By: Dominic@20151029
	Description: Setup PT Group for the following Supers
			720475		WW
			1539339		EC
			4138910		S863R
			5340162		POR
			6379932		S359BH
			12141529	TVA96
			12141653	TVFA
			12262401	KPH
			13869621	KP25
			16112208	K2K
*/
CREATE TABLE #supers (custid int,isfinished bit default(0))
CREATE TABLE #tempData (recommend int, custid int, cs1 bigint, cs2 int)
CREATE TABLE #tempGroup(recommend int, cs1 bigint, cs2 int, memberCNT int, repCustID int)
DECLARE @srecommend INT


INSERT INTO #supers(custid)
VALUES(13869621),
(5340162),
(12262401),
(12141653),
(4138910),
(6379932),
(16112208),
(12141529),
(1539339),
(720475)

	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	SET NOCOUNT ON

	;WITH _s as (
		SELECT c.recommend, c.custid	
			,rdSetting = CAST(DENSE_RANK() OVER(ORDER BY sporttype, bettype, islive, superPT, masterPT, agentPT, isAutoMasterPT, AutoMasterPT, isAutoSuperPT, AutoSuperPT) as INT)
			,rdProduct = CAST(DENSE_RANK() OVER(ORDER BY sporttype, bettype, islive) as INT)
		FROM dbo.custinfo c WITH(NOLOCK)
			INNER JOIN dbo.CustPTSetting3rd_Member pt WITH(NOLOCK) ON c.custid = pt.custid		
		WHERE srecommend = @srecommend
			AND roleid = 1
	)
	INSERT INTO #tempdata (recommend, custid, cs1, cs2)
	SELECT recommend, custid, SUM(CONVERT(bigint,rdSetting) + POWER(2, rdProduct%10+1)), CHECKSUM_AGG(CHECKSUM(HASHBYTES('SHA1', CONVERT(nvarchar(max), rdSetting))))
	FROM _s
	group by recommend, custid

	INSERT INTO #tempGroup(recommend, cs1, cs2, memberCNT, repCustID)
	SELECT recommend, cs1, cs2, memberCnt, repCustID
	FROM (
		SELECT recommend, cs1, cs2, rn = ROW_NUMBER() OVER (partition by recommend ORDER BY count(1) desc), memberCnt = count(1), repCustID = max(custid)
		FROM #tempdata
		GROUP BY recommend, cs1, cs2
	) x
	WHERE rn = 1

	--Insert settings of PT Group
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
	FROM [dbo].[CustPTSetting3rd_Member] mb
		INNER JOIN #tempGroup tmp ON mb.CustID = tmp.repCustID
		
	
	--Update group mode	
	UPDATE main
	SET IsGrouped = 1
	FROM dbo.CustSettingMode3rd main WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tempData tmp1 WITH(NOLOCK)
		ON tmp1.custid = main.CustID
	INNER JOIN #tempGroup tmp2 WITH(NOLOCK)
		ON tmp1.cs1 = tmp2.cs1
			AND tmp1.cs2 = tmp2.cs2
			AND tmp1.recommend = tmp2.recommend
	
	--Delete individual settings		
	DELETE cs
	FROM dbo.CustPTSetting3rd_Member cs
	INNER JOIN #tempData tmp1 WITH(NOLOCK)
		ON tmp1.custid = cs.CustID
	INNER JOIN dbo.CustSettingMode3rd m WITH(NOLOCK)
		ON cs.CustID = m.CustID
	WHERE m.IsGrouped = 1
	
	TRUNCATE TABLE #tempdata
	TRUNCATE TABLE #tempGroup
		
	waitfor delay '00:00:0.280'
END

DROP TABLE #tempdata
DROP TABLE #tempGroup
DROP TABLE #supers


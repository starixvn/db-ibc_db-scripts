

/*
	Created: Winnie
	Task: Copy PT & LossLimit for newly created direct acc
	DB: DBCUST/CustDB
	Date: 20170118
*/ 
		
DECLARE @maxcustid INT
SELECT @maxcustid = xxx
	
CREATE TABLE #supers (custid int,exchangeid INT)
	
INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.custid IN (2,3,4,5,12,13,15)


CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED,exchangeid INT
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,exchangeid INT	,
	roleid TINYINT
)
------------STARTING Dummy Processing
CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)			
--- get direct master
INSERT INTO #DirectMaster (CustID,roleid)
SELECT custid, roleid
FROM Customer with(nolock)
WHERE SITE in  ('733333','222223', '222225', '222227', '222229')	

	and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=3 AND srecommend IN (2,3,4,5,12,13,15)

--- get direct agent
INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
SELECT custid, mrecommend,roleid
FROM Customer WITH(NOLOCK)
WHERE site in  ('733333','222223', '222225', '222227', '222229')	

	and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=2 AND srecommend IN (2,3,4,5,12,13,15)
	
INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
SELECT c.custid, c.recommend,c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.roleid=1 AND c.srecommend IN (2,3,4,5,12,13,15)  
	AND  ca.site in ('733333','222223', '222225', '222227', '222229')
			
----------- For SMA  -----------
INSERT INTO #SMATemp (CustID,roleid)

SELECT CI.CustID,CI.roleid,ci.currency -- Direct Master 
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
WHERE ci.custid > @maxcustid 

UNION 

SELECT DISTINCT CI.CustID,CI.roleid,ci.currency -- Master of direct agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 
WHERE ci.custid > @maxcustid 
	
UNION 

SELECT CI.CustID,CI.roleid ,ci.currency-- Agent of direct master
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
WHERE CI.roleid = 2
	AND ci.custid > @maxcustid 
UNION 
SELECT CI.CustID,CI.roleid,ci.currency -- Direct Agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.CustID 
WHERE ci.custid > @maxcustid 

UNION 

SELECT DISTINCT CI.CustID,CI.roleid,ci.currency -- Master of direct member
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMember D ON CI.custid = D.mrecommend 
WHERE  ci.Enabled = 1  AND ci.custid > @maxcustid 

UNION 
SELECT DISTINCT CI.CustID,CI.roleid,ci.currency -- agent of direct member
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMember D ON CI.custid = D.recommend 
WHERE  ci.Enabled = 1 AND ci.custid > @maxcustid 
	
---------- For members ---------
INSERT INTO #MemberTemp (CustID,exchangeid)
SELECT CI.custid,ci.currency
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
WHERE CI.roleid = 1	AND ci.custid > @maxcustid 
	
UNION 
SELECT CI.custid,ci.currency
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
WHERE CI.roleid = 1 AND ci.custid > @maxcustid 

UNION 
SELECT CI.custid,ci.currency
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectMember M ON CI.custid = M.CustID
WHERE ci.custid > @maxcustid
	
--------------------------------------WinLossLimit-------------------------------------------------
	--Master Agent Level
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, 219, 1011
		, 0 AS MaxWinLimit	
		, (SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = 24 AND ExchangeId = si.exchangeid)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #SMATemp si WITH (NOLOCK) 		
	
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, 219, 1011
		, 0 AS MaxWinLimit	
		,(SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = 24 AND ExchangeId = si.exchangeid)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #MemberTemp si WITH (NOLOCK) 
	
	--------------------------------------PT Setting-------------------------------------------------	
	--Master LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Agent
		(	[CustID]
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
		   ,[MinPT]
		   ,[MaxPT])
	SELECT 
		ci.custid, 219, 1011, 0
		,0
		,(SELECT CASE	WHEN ci.currency IN (5,13,67) THEN 70
				WHEN ci.currency IN (1,2) AND spositiontaking IN (0.7,0.8)THEN spositiontaking*100
				WHEN ci.currency IN (1,2) AND spositiontaking = 0.85 THEN 90
				WHEN ci.currency NOT IN (5,13,67,1,2) AND spositiontaking = 0.85 THEN 90
				ELSE spositiontaking*100 
				END
			FROM dbo.CustSetting3rd cs WITH(NOLOCK)	
			INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid=ci.custid		
			WHERE cs.Custid=c.srecommend AND cs.sporttype=161 AND	 cs.bettype=85)
		,0
		,0
		,0
		,0
		,0
		,0
		,90
	FROM #SMATemp ci WITH(NOLOCK) 	
	INNER JOIN custInfo c WITH (NOLOCK) ON ci.CustID=c.custid
	WHERE ci.RoleID=3
	
	--Agent LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Agent
		(	[CustID]
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
		   ,[MinPT]
		   ,[MaxPT])
	SELECT 
		ci.custid, 219, 1011, 0
		,0
		,0
		,(SELECT CASE	WHEN ci.currency IN (5,13,67) THEN 70
				WHEN ci.currency IN (1,2) AND spositiontaking IN (0.7,0.8)THEN spositiontaking*100
				WHEN ci.currency IN (1,2) AND spositiontaking = 0.85 THEN 90
				WHEN ci.currency NOT IN (5,13,67,1,2) AND spositiontaking = 0.85 THEN 90
				ELSE spositiontaking*100 
				END
			FROM dbo.CustSetting3rd cs WITH(NOLOCK)	
			INNER JOIN custInfo ci WITH(NOLOCK) ON cs.custid=ci.custid		
			WHERE cs.Custid=c.srecommend AND cs.sporttype=161 AND	 cs.bettype=85)
		,0
		,0
		,0
		,0
		,0
		,90
	FROM #DirectAgent ci WITH(NOLOCK) 	
	INNER JOIN custInfo c WITH (NOLOCK) ON ci.CustID=c.custid
	WHERE ci.RoleID=2 AND ci.custid > @maxcustid
	
	INSERT INTO dbo.CustPTSetting3rd_Agent
		(	[CustID]
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
		   ,[MinPT]
		   ,[MaxPT])
	SELECT 
		ci.custid, 219, 1011, 0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,90
	FROM #SMATemp ci WITH(NOLOCK) 
	WHERE RoleID=2 AND ci.CustID NOT IN(SELECT CustID FROM #DirectAgent)	

	--MEMBER LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Member
		(	[custid]
		  ,	[sporttype]
		  ,	[bettype]
		  ,	[islive]
		  ,	[superPT]
		  ,	[masterPT]
		  ,	[agentPT]
		  ,	[IsAutoMasterPT]
		  ,	[AutoMasterPT]
		  ,	[IsAutoSuperPT]
		  ,	[AutoSuperPT])
	SELECT 
		ci.custid, 219, 1011, 0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
	FROM 	#MemberTemp ci WITH(NOLOCK) 	
	
	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp		

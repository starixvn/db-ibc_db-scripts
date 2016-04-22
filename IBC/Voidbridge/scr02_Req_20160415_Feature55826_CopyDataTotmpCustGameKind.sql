/*
	Created: Elodie
	Date: 20160420
	Task: prepare data for tmpCustGameKind
	DB: DBCUST/06/TP/MNL.bodb02	
*/ 
--step 0: prepare structure for tmpCustGameKind on DBCUST
USE [CustDB]
GO

/****** Object:  Table [dbo].[tmpCustGameKind]    Script Date: 9/24/2015 4:52:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tmpCustGameKind](
	[CustID] [int] NOT NULL,
	[SPositionTaking] [smallmoney] NULL,
	[MPositionTaking] [smallmoney] NULL,
	[APositionTaking] [smallmoney] NULL,
	[IsAutoPositionTaking] [bit] NULL,
	[AutoPositionTaking] [smallmoney] NULL,
	[MaxPositionTaking] [smallmoney] NULL,
	[MinPositionTaking] [smallmoney] NULL,
	[SMAgentRollingRate] [decimal](9, 8) NULL,
	[MAgentRollingRate] [decimal](9, 8) NULL,
	[AgentRollingRate] [decimal](9, 8) NULL,
	[MemberRollingRate] [decimal](9, 8) NULL,
	[IsAutoMPositionTaking] [bit] NULL,
	[AutoMPositionTaking] [smallmoney] NULL,
 CONSTRAINT [PK_tmpCustGameKind] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [CustGameType_table]
) ON [CustGameType_table]

GO
GO

SET ANSI_PADDING OFF
GO
-----------------INSERT SYNC-ED Customers----------------------------------

USE [CustDB]
GO
INSERT INTO [dbo].[tmpCustGameKind] ([CustID]
           ,[SPositionTaking]
           ,[MPositionTaking]
           ,[APositionTaking]
           ,[IsAutoPositionTaking]
           ,[AutoPositionTaking]
           ,[MaxPositionTaking]
           ,[MinPositionTaking]
           ,[SMAgentRollingRate]
           ,[MAgentRollingRate]
           ,[AgentRollingRate]
           ,[MemberRollingRate]
           ,[IsAutoMPositionTaking]
           ,[AutoMPositionTaking])
SELECT	c.IBCCustID,
		ISNULL(SPositionTaking,0), 
		ISNULL(MPositionTaking, 
		ISNULL(APositionTaking, 
		ISNULL(IsAutoPositionTaking, 
		ISNULL(AutoPositionTaking, 
		ISNULL(MaxPositionTaking, 
		MinPositionTaking,
		SMAgentRollingRate, 
		MAgentRollingRate, 
		AgentRollingRate, 
		MemberRollingRate,
		ISNULL(IsAutoMPositionTaking, 
		ISNULL(AutoMPositionTaking 
FROM DBBingoAdmin.CasinoAdmin.dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN DBBingoAdmin.CasinoAdmin.dbo.customer c WITH (NOLOCK) ON cs.CustID = c.CustID
WHERE cs.GameKind = 9 

-----------------INSERT UNSYNC-ED SUPERs-------------------------------
CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
	INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
	INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND s.islicensee = 0
	AND ci.custid <= @max_custid
	AND ci.currency IN (34,45,43) --IDR,WON,'THB'
 
INSERT INTO [dbo].[tmpCustGameKind] ([CustID]
           ,[SPositionTaking]
           ,[MPositionTaking]
           ,[APositionTaking]
           ,[IsAutoPositionTaking]
           ,[AutoPositionTaking]
           ,[MaxPositionTaking]
           ,[MinPositionTaking]
           ,[SMAgentRollingRate]
           ,[MAgentRollingRate]
           ,[AgentRollingRate]
           ,[MemberRollingRate]
           ,[IsAutoMPositionTaking]
           ,[AutoMPositionTaking])
SELECT	ci.CustID,
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
FROM #supers ci WITH(NOLOCK)
LEFT JOIN [dbo].[tmpCustGameKind] cgk WITH(NOLOCK) ON cgk.custid = ci.custid
WHERE cgk.SPositionTaking IS NULL

-----------------INSERT UNSYNC-ED Masters-------------------------------
CREATE TABLE #masters (custid INT, srecommend INT)

INSERT INTO #masters(custid,srecommend)
SELECT ci.CustID,ci.srecommend
FROM Custinfo ci WITH (NOLOCK)
LEFT JOIN [dbo].[tmpCustGameKind] cgk WITH(NOLOCK) ON cgk.custid = ci.custid
WHERE ci.srecommend IN (SELECT CustID FROM #supers) 
AND ci.roleid = 3
WHERE cgk.SPositionTaking IS NULL

INSERT INTO [dbo].[tmpCustGameKind] ([CustID]
           ,[SPositionTaking]
           ,[MPositionTaking]
           ,[APositionTaking]
           ,[IsAutoPositionTaking]
           ,[AutoPositionTaking]
           ,[MaxPositionTaking]
           ,[MinPositionTaking]
           ,[SMAgentRollingRate]
           ,[MAgentRollingRate]
           ,[AgentRollingRate]
           ,[MemberRollingRate]
           ,[IsAutoMPositionTaking]
           ,[AutoMPositionTaking])
SELECT	ci.CustID,
		,cgk.SPositionTaking
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
FROM #masters ci WITH(NOLOCK)
INNER JOIN [dbo].[tmpCustGameKind] cgk WITH(NOLOCK) ON cgk.custid = ci.srecommend

-----------------INSERT UNSYNC-ED Agents-------------------------------
CREATE TABLE #agents (custid INT, mrecommend INT)

INSERT INTO #agents(custid,mrecommend)
SELECT ci.CustID,ci.mrecommend
FROM Custinfo ci WITH (NOLOCK)
LEFT JOIN [dbo].[tmpCustGameKind] cgk WITH(NOLOCK) ON cgk.custid = ci.custid
WHERE ci.srecommend IN (SELECT CustID FROM #supers) 
AND ci.roleid = 2
WHERE cgk.SPositionTaking IS NULL

INSERT INTO [dbo].[tmpCustGameKind] ([CustID]
           ,[SPositionTaking]
           ,[MPositionTaking]
           ,[APositionTaking]
           ,[IsAutoPositionTaking]
           ,[AutoPositionTaking]
           ,[MaxPositionTaking]
           ,[MinPositionTaking]
           ,[SMAgentRollingRate]
           ,[MAgentRollingRate]
           ,[AgentRollingRate]
           ,[MemberRollingRate]
           ,[IsAutoMPositionTaking]
           ,[AutoMPositionTaking])
SELECT	ci.CustID,
		,0
		,cgk.MPositionTaking
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
FROM #agents ci WITH(NOLOCK)
INNER JOIN [dbo].[tmpCustGameKind] cgk WITH(NOLOCK) ON cgk.custid = ci.mrecommend

-----------------INSERT UNSYNC-ED Members-------------------------------
CREATE TABLE #Members (custid INT, srecommend INT, mrecommend INT, recommend INT)

INSERT INTO #Members(custid,mrecommend)
SELECT ci.CustID,ci.srecommend,ci.mrecommend,ci.recommend
FROM Custinfo ci WITH (NOLOCK)
LEFT JOIN [dbo].[tmpCustGameKind] cgk WITH(NOLOCK) ON cgk.custid = ci.custid
WHERE ci.srecommend IN (SELECT CustID FROM #supers) 
AND ci.roleid = 1
WHERE cgk.SPositionTaking IS NULL

INSERT INTO [dbo].[tmpCustGameKind] ([CustID]
           ,[SPositionTaking]
           ,[MPositionTaking]
           ,[APositionTaking]
           ,[IsAutoPositionTaking]
           ,[AutoPositionTaking]
           ,[MaxPositionTaking]
           ,[MinPositionTaking]
           ,[SMAgentRollingRate]
           ,[MAgentRollingRate]
           ,[AgentRollingRate]
           ,[MemberRollingRate]
           ,[IsAutoMPositionTaking]
           ,[AutoMPositionTaking])
SELECT	ci.CustID,
		,0
		,0
		, CASE WHEN ISNULL(cgk.APositionTaking,0) < ISNULL(cgk.MinPositionTaking,0)  					THEN ISNULL(CGKA.MinPositionTaking,0)  				ELSE ISNULL(cgk.APositionTaking,0) 
			END
		,0
		,0
		,0
		,0
		,0
		,0
		,cgk.AgentRollingRate
		,0
		,0
		,0
FROM #Members ci WITH(NOLOCK)
INNER JOIN [dbo].[tmpCustGameKind] cgk WITH(NOLOCK) ON cgk.custid = ci.recommend

---------------------------------------------------------------------------------------
--update MPT,MComm  --1. im2=1 then m1 = Max(n3 - a1, Min(um2, m3 - a1))   --2. im2=0 then m1 = Max(n3 - a1, Min(m2, m3 - a1)) 
UPDATE CGKC WITH(rowlock, updlock)
SET CGKC.MPositionTaking = CASE 
		WHEN ISNULL(CGKA.IsAutoMPositionTaking, 0) = 1
			AND (ISNULL(CGKA.AutoMPositionTaking, 0) <= (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)))
			AND (ISNULL(CGKA.AutoMPositionTaking, 0) >= (ISNULL(CGKM.MinPositionTaking, 0) - ISNULL(CGKC.APo sitionTaking, 0)))
			THEN ISNULL(CGKA.AutoMPositionTaking, 0)
		WHEN ISNULL(CGKA.IsAutoMPositionTaking, 0) = 1
			AND (ISNULL(CGKA.AutoMPositionTaking, 0) <= (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)))
			AND (ISNULL(CGKA.AutoMPositionTaking, 0) <= (ISNULL(CGKM.MinPositionTaking, 0) - ISNULL(CGKC.APo sitionTaking, 0)))
			THEN ISNULL(CGKM.MinPositionTaking, 0) - ISNULL(CGKC.MPositionTaking, 0)
		WHEN ISNULL(CGKA.IsAutoMPositionTaking, 0) = 1
			AND (ISNULL(CGKA.AutoMPositionTaking, 0) >= (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)))
			AND ((ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)) >= (ISNULL(CGKM.MinPosi tionTaking, 0) - ISNULL(CGKC.APositionTaking, 0))
				)
			THEN (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0))
		WHEN ISNULL(CGKA.IsAutoMPositionTaking, 0) = 1
			AND (ISNULL(CGKA.AutoMPositionTaking, 0) >= (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)))
			AND ((ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)) <= (ISNULL(CGKM.MinPosi tionTaking, 0) - ISNULL(CGKC.APositionTaking, 0))
				)
			THEN ISNULL(CGKM.MinPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)
		WHEN ISNULL(CGKA.IsAutoMPositionTaking, 0) = 0
			AND (ISNULL(CGKA.MPositionTaking, 0) <= (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)))
			AND (ISNULL(CGKA.MPositionTaking, 0) >= (ISNULL(CGKM.MinPositionTaking, 0) - ISNULL(CGKC.APositionTa king, 0)))
			THEN ISNULL(CGKA.MPositionTaking, 0)
		WHEN ISNULL(CGKA.IsAutoMPositionTaking, 0) = 0
			AND (ISNULL(CGKA.MPositionTaking, 0) <= (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)))
			AND (ISNULL(CGKA.MPositionTaking, 0) <= (ISNULL(CGKM.MinPositionTaking, 0) - ISNULL(CGKC.APositionTa king, 0)))
			THEN ISNULL(CGKM.MinPositionTaking, 0) - ISNULL(CGKC.MPositionTaking, 0)
		WHEN ISNULL(CGKA.IsAutoMPositionTaking, 0) = 0
			AND (ISNULL(CGKA.MPositionTaking, 0) >= (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)))
			AND ((ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)) >= (ISNULL(CGKM.MinPosition Taking, 0) - ISNULL(CGKC.APositionTaking, 0))
				)
			THEN (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0))
		WHEN ISNULL(CGKA.IsAutoMPositionTaking, 0) = 0
			AND (ISNULL(CGKA.MPositionTaking, 0) >= (ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)))
			AND ((ISNULL(CGKM.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)) <= (ISNULL(CGKM.MinPosition Taking, 0) - ISNULL(CGKC.APositionTaking, 0))
				)
			THEN ISNULL(CGKM.MinPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)
		ELSE ISNULL(CGKA.MPositionTaking, 0)
		END
	, CGKC.MAgentRollingRate = CGKM.MAgentRollingRate
FROM [dbo].[tmpCustGameKind] CGKC
	INNER JOIN #Members ci (NOLOCK) ON ci.custID = CGKC.CustID
	INNER JOIN [dbo].[tmpCustGameKind] CGKA WITH(NOLOCK) ON CGKA.custid = ci.recommend
	INNER JOIN [dbo].[tmpCustGameKind] CGKM WITH(NOLOCK) ON CGKM.custid = ci.mrecommend

--update SPT,SComm    
UPDATE CGKC WITH(ROWLOCK, UPDLOCK)
SET SPositionTaking = CASE 
		WHEN ISNULL(CGKM.IsAutoPositionTaking, 0) = 0
			THEN ISNULL(CGKM.SPositionTaking, 0)
		WHEN ISNULL(CGKM.IsAutoPositionTaking, 0) = 1
			AND ((ISNULL(CGKS.SPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0) - ISNULL(CGKC.MPositionTaking, 0)) > ISNULL(CGKM.AutoPositionTaking, 0)) --Karen,2012/6/5  
			THEN ISNULL(CGKM.AutoPositionTaking, 0)
		ELSE ISNULL(CGKS.SPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0) - ISNULL(CGKC.MPositionTaking, 0)
		END
	, SMAgentRollingRate = CGKS.SMAgentRollingRate
FROM [dbo].[tmpCustGameKind] CGKC
	INNER JOIN #Members ci (NOLOCK) ON ci.custID = CGKC.CustID
	INNER JOIN [dbo].[tmpCustGameKind] CGKM WITH(NOLOCK) ON CGKM.custid = ci.mrecommend
	INNER JOIN [dbo].[tmpCustGameKind] CGKS WITH(NOLOCK) ON CGKS.custid = ci.srecommend

--Update SPT    
UPDATE CGKC WITH(ROWLOCK, UPDLOCK)
SET SPositionTaking = CASE 
		WHEN (ISNULL(CGKC.SPositionTaking, 0) + ISNULL(CGKC.MPositionTaking, 0) + ISNULL(CGKC.APositionTaking, 0)) < ISNULL(CGKS.MinPositionTaking, 0)
			THEN ISNULL(CGKS.MinPositionTaking, 0) - ISNULL(CGKC.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)
		WHEN (ISNULL(CGKC.SPositionTaking, 0) + ISNULL(CGKC.MPositionTaking, 0) + ISNULL(CGKC.APositionTaking, 0)) > ISNULL(CGKS.SPositionTaking, 0)
			THEN ISNULL(CGKS.SPositionTaking, 0) - ISNULL(CGKC.MPositionTaking, 0) - ISNULL(CGKC.APositionTaking, 0)
		ELSE CGKC.SPositionTaking
		END
FROM [dbo].[tmpCustGameKind] CGKC
	INNER JOIN #Members ci (NOLOCK) ON ci.custID = CGKC.CustID
	INNER JOIN [dbo].[tmpCustGameKind] CGKS WITH(NOLOCK) ON CGKS.custid = ci.srecommend

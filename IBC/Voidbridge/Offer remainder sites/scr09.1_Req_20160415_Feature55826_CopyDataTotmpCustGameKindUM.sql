/*
	Created: Daniel
	Date: 20160602
	Task: Pull data in table CustGameKind from Casino server to local tmpCustGameKindUM
	DB: DBCUST.custDB
*/ 

--1. Create tmpCustGameKind on DBCUST.custDB

CREATE TABLE [dbo].[tmpCustGameKindUM](
	[CustID] [int] NOT NULL,
	[SPositionTaking] [smallmoney] NULL,
	[MPositionTaking] [smallmoney] NULL,
	[APositionTaking] [smallmoney] NULL,
	[MinPresetPositionTaking] [smallmoney] NULL,	
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
 CONSTRAINT [PK_tmpCustGameKindUM] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON data
) ON data


--2.1 Use SSIS to import data for DBTP
 /*
   Source: DBCASINOADMIN.CasinoAdmin - with select Query below
   Destination: DBCUST.custDB.tmpCustGameKindUM
 */

SELECT	c.IBCCustID CustID,
		ISNULL(SPositionTaking,0) [SPositionTaking], 
		ISNULL(MPositionTaking,0) [MPositionTaking], 
		ISNULL(APositionTaking,0) APositionTaking, 
		ISNULL(MinPresetPositionTaking, 0) MinPresetPositionTaking,
		ISNULL(IsAutoPositionTaking,0) IsAutoPositionTaking, 
		ISNULL(AutoPositionTaking,0) AutoPositionTaking, 
		ISNULL(MaxPositionTaking,0) MaxPositionTaking, 
		ISNULL(MinPositionTaking,0) MinPositionTaking,
		SMAgentRollingRate, 
		MAgentRollingRate, 
		AgentRollingRate, 
		MemberRollingRate,
		ISNULL(IsAutoMPositionTaking,0) IsAutoMPositionTaking, 
		ISNULL(AutoMPositionTaking,0) AutoMPositionTaking
FROM dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN dbo.customer c WITH (NOLOCK) ON cs.CustID = c.CustID
WHERE cs.GameKind = 9


--2.2 Delete redundant records, only keep data for 611111
SELECT ci.custid into #customer
FROM  customer ci WITH (NOLOCK) 
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
		AND ci.username NOT LIKE '3rdSuper%'
		AND cs.isinternal = 0
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND s.islicensee = 0
		AND ci.site NOT IN ('755555', 'INDO', 'KORIBC','611111','789y', '733333')
		--AND ci.custid NOT IN (2,4,5,42,13) --Dummy account
	
delete from tmpCustGameKindUM
where CustID not in (select custid from custInfo with(nolock) where srecommend in (Select custid from #customer))

drop table #customer
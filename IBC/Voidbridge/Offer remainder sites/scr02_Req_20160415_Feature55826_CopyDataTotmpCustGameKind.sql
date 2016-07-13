/*
	Created: Daniel
	Date: 20160602
	Task: Pull data in table CustGameKind from Casino server to local tmpCustGameKind
	DB: DBCUST.custDB, DB06.bodb02, DBTP.bodb02, DBMNL.bodb02, MNL-DBCUST.custDB@MNL, MNL-DB06.bodb02
*/ 

--1. Create tmpCustGameKind on DBCUST.custDB, DB06.bodb02, DBTP.bodb02, DBMNL.bodb02, MNL-DBCUST.custDB@MNL, MNL-DB06.bodb02

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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON data
) ON data


--2.1 Use SSIS to import data for DBTP
 /*
   Source: DBCASINOADMIN.CasinoAdmin - with select Query below
   Destination: DBTP.bodb02.tmpCustGameKind
 */
 SELECT	c.IBCCustID AS CustID,
		ISNULL(SPositionTaking,0) AS SPositionTaking, 
		ISNULL(MPositionTaking,0) AS MPositionTaking,  
		ISNULL(APositionTaking,0) AS APositionTaking, 
		ISNULL(IsAutoPositionTaking,0) AS IsAutoPositionTaking, 
		ISNULL(AutoPositionTaking,0) AS AutoPositionTaking, 
		ISNULL(MaxPositionTaking,0) AS MaxPositionTaking, 
		ISNULL(MinPositionTaking,0) AS MinPositionTaking,
		SMAgentRollingRate, 
		MAgentRollingRate, 
		AgentRollingRate, 
		MemberRollingRate,
		ISNULL(IsAutoMPositionTaking,0) AS IsAutoMPositionTaking, 
		ISNULL(AutoMPositionTaking,0) AS AutoMPositionTaking
FROM dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN dbo.customer c WITH (NOLOCK) ON cs.CustID = c.CustID
WHERE cs.GameKind = 9 


--2.1. Delete redundant records, only keep data of remaining sites
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
	AND ci.custid NOT IN (2,4,5,42,13) --Dummy account
	
delete from tmpCustGameKind
where CustID not in (select custid from custInfo with(nolock) where srecommend in (Select custid from #customer))

drop table #customer

--correct invalid PT
update tmpCustGameKind set SPositionTaking = 0 where custid = 19560980
 
 --4. Use SSIS to import this table from DBTP to other servers: DBCUST.custDB, DB06.bodb02, DBMNL.bodb02, MNL-DBCUST.custDB@MNL, MNL-DB06.bodb02

 

 
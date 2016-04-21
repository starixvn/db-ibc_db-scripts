/*
	Created: Elodie
	Task: Adjust PT & Comm
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
DECLARE @SportType SMALLINT, @BetType SMALLINT, @MaxPT TINYINT, @MaxComm DECIMAL(9,8)
SELECT @SportType = 212, @BetType = 4001
SELECT @MaxPT = MaxPT FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 22 AND SettingType = 1
SELECT @MaxComm = MaxDiscount FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 22 AND SettingType = 3

CREATE TABLE #SMAPTCust(CustID INT NOT NULL, RoleID TINYINT, 
	[SPositionTaking] [smallmoney] NULL,
	[MPositionTaking] [smallmoney] NULL,
	[APositionTaking] [smallmoney] NULL,
	[MinPresetPositionTaking] [smallmoney] NULL,
	[IsAutoPositionTaking] [bit] NULL,
	[AutoPositionTaking] [smallmoney] NULL,
	[MinPositionTaking] [smallmoney] NULL,
	[IsAutoMPositionTaking] [bit] NULL,
	[AutoMPositionTaking] [decimal](9, 8) NULL
)
CREATE TABLE #MemberPTCust(CustID INT NOT NULL,
	[SPositionTaking] [smallmoney] NULL,
	[MPositionTaking] [smallmoney] NULL,
	[APositionTaking] [smallmoney] NULL,
	[MinPresetPositionTaking] [smallmoney] NULL,
	[IsAutoPositionTaking] [bit] NULL,
	[AutoPositionTaking] [smallmoney] NULL,
	[MinPositionTaking] [smallmoney] NULL,
	[IsAutoMPositionTaking] [bit] NULL,
	[AutoMPositionTaking] [decimal](9, 8) NULL
)
CREATE TABLE #SMADiscountCust(CustID INT NOT NULL, RoleID TINYINT,
	[SMAgentRollingRate] [decimal](9, 8) NULL,
	[MAgentRollingRate] [decimal](9, 8) NULL,
	[AgentRollingRate] [decimal](9, 8) NULL,
	[MemberRollingRate] [decimal](9, 8) NULL
)
CREATE TABLE #MemberDiscountCust(CustID INT NOT NULL,
	[SMAgentRollingRate] [decimal](9, 8) NULL,
	[MAgentRollingRate] [decimal](9, 8) NULL,
	[AgentRollingRate] [decimal](9, 8) NULL,
	[MemberRollingRate] [decimal](9, 8) NULL
)

CREATE TABLE #supers (custid INT PRIMARY KEY CLUSTERED)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.currency IN (34,45,43) --IDR,WON,'THB'

--SMA PT
INSERT INTO #SMAPTCust(CustID,RoleID
		,SPositionTaking
		,MPositionTaking
		,APositionTaking
		,MinPresetPositionTaking
		,IsAutoPositionTaking
		,AutoPositionTaking
		,MinPositionTaking
		,IsAutoMPositionTaking
		,AutoMPositionTaking)
SELECT ci.custid
		,ci.roleid
		,cgk.SPositionTaking
		,cgk.MPositionTaking
		,cgk.APositionTaking
		,cgk.MinPresetPositionTaking
		,cgk.IsAutoPositionTaking
		,cgk.AutoPositionTaking
		,cgk.MinPositionTaking
		,cgk.IsAutoMPositionTaking
		,cgk.AutoMPositionTaking
FROM dbo.custinfo ci WITH(NOLOCK)	
	INNER JOIN dbo.CustPTSetting3rd_Agent csa WITH(NOLOCK) ON csa.custid = ci.custid
	INNER JOIN CasinoAdmin_tmp.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = ci.CustID
	INNER JOIN CasinoAdmin_tmp.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid
WHERE ci.srecommend IN (SELECT s.custid 
						FROM #supers s 
							INNER JOIN CasinoAdmin_tmp.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = s.CustID
							INNER JOIN CasinoAdmin_tmp.dbo.CustGameKind cs WITH(NOLOCK) ON c.custid = cs.custid AND cs.GameKind = 9
						WHERE SPositionTaking <= @MaxPT) 
		AND roleid IN (2,3,4) AND Enabled = 1
		AND cgk.GameKind = 9
		AND csa.SportType = @SportType AND csa.BetType = @BetType
		AND (
			ISNULL(cgk.SPositionTaking,0) * 100 <> csa.SuperPT
			OR (ISNULL(cgk.MPositionTaking,0) *100 <> csa.MasterPT)
			OR (ISNULL(cgk.APositionTaking,0) *100 <> csa.AgentPT)
			OR ISNULL(cgk.IsAutoMPositionTaking,0) <> csa.IsAutoMasterPT
			OR ISNULL(cgk.AutoMPositionTaking,0) *100 <> csa.AutoMasterPT
			OR ISNULL(cgk.IsAutoPositionTaking ,0) <> csa.IsAutoSuperPT
			OR ISNULL(cgk.AutoPositionTaking,0) *100 <> csa.AutoSuperPT
			OR cgk.MinPositionTaking  *100 <> csa.MinPT
		)
		
--Member PT
INSERT INTO #MemberPTCust(CustID
		,SPositionTaking
		,MPositionTaking
		,APositionTaking
		,MinPresetPositionTaking
		,IsAutoPositionTaking
		,AutoPositionTaking
		,MinPositionTaking
		,IsAutoMPositionTaking
		,AutoMPositionTaking)
SELECT ci.custid
		,cgk.SPositionTaking
		,cgk.MPositionTaking
		,cgk.APositionTaking
		,cgk.MinPresetPositionTaking
		,cgk.IsAutoPositionTaking
		,cgk.AutoPositionTaking
		,cgk.MinPositionTaking
		,cgk.IsAutoMPositionTaking
		,cgk.AutoMPositionTaking
FROM dbo.custinfo ci WITH(NOLOCK)
	INNER JOIN dbo.CustPTSetting3rd_Member csm WITH(NOLOCK) ON csm.custid = ci.custid
	INNER JOIN CasinoAdmin_tmp.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = ci.CustID
	INNER JOIN CasinoAdmin_tmp.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid
WHERE ci.srecommend IN (SELECT s.custid 
						FROM #supers s 
							INNER JOIN CasinoAdmin_tmp.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = s.CustID
							INNER JOIN CasinoAdmin_tmp.dbo.CustGameKind cs WITH(NOLOCK) ON c.custid = cs.custid AND cs.GameKind = 9
						WHERE SPositionTaking <= @MaxPT)  
		AND ci.roleid = 1 AND Enabled = 1
		AND cgk.GameKind = 9
		AND csm.SportType = @SportType AND csm.BetType = @BetType
		AND (
			ISNULL(cgk.SPositionTaking,0)  *100 <> csm.SuperPT
			OR ISNULL(cgk.MPositionTaking,0)  *100 <> csm.MasterPT
			OR ISNULL(cgk.APositionTaking,0)  *100 <> csm.AgentPT
			OR ISNULL(cgk.IsAutoMPositionTaking,0) <> csm.IsAutoMasterPT
			OR ISNULL(cgk.AutoMPositionTaking,0) *100 <> csm.AutoMasterPT
			OR ISNULL(cgk.IsAutoPositionTaking ,0) <> csm.IsAutoSuperPT
			OR ISNULL(cgk.AutoPositionTaking,0)  *100 <> csm.AutoSuperPT
			)

--SMA Discount
INSERT INTO #SMADiscountCust(CustID,RoleID
		,SMAgentRollingRate
		,MAgentRollingRate
		,AgentRollingRate 
		,MemberRollingRate)
SELECT ci.custid,ci.roleid
		,SMAgentRollingRate
		,MAgentRollingRate
		,AgentRollingRate 
		,MemberRollingRate
FROM dbo.custinfo ci WITH(NOLOCK)	
	INNER JOIN dbo.CustDiscount3rd_Agent csa WITH(NOLOCK) ON csa.custid = ci.custid
	INNER JOIN CasinoAdmin_tmp.dbo.Customer c (NOLOCK) ON c.ibccustid = ci.CustID
	INNER JOIN CasinoAdmin_tmp.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid
WHERE ci.srecommend IN (SELECT s.custid 
						FROM #supers s 
							INNER JOIN CasinoAdmin_tmp.dbo.Customer c (NOLOCK) ON c.ibccustid = s.CustID
							INNER JOIN CasinoAdmin_tmp.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid AND cgk.GameKind = 9
						WHERE cs.sdiscount <= @MaxComm)
		AND ci.roleid IN (2,3,4) AND Enabled = 1
		AND cgk.GameKind = 9
		AND csa.SportType = @SportType AND csa.BetType = @BetType
		AND (
			CASE ci.roleid 
				WHEN 4 THEN cgk.SMAgentRollingRate
				WHEN 3 THEN cgk.MAgentRollingRate
				WHEN 2 THEN cgk.AgentRollingRate
			END  <> csa.Discount
		)
		
--Member Discount
INSERT INTO #MemberDiscountCust(CustID
		,SMAgentRollingRate
		,MAgentRollingRate
		,AgentRollingRate 
		,MemberRollingRate)
SELECT ci.custid
		,SMAgentRollingRate
		,MAgentRollingRate
		,AgentRollingRate 
		,MemberRollingRate
FROM dbo.custinfo ci WITH(NOLOCK)	
	INNER JOIN dbo.CustDiscount3rd_Member csm WITH(NOLOCK) ON csm.custid = ci.custid
	INNER JOIN CasinoAdmin_tmp.dbo.Customer c (NOLOCK) ON c.ibccustid = ci.CustID
	INNER JOIN CasinoAdmin_tmp.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid
WHERE ci.srecommend IN (SELECT s.custid 
						FROM #supers s 
							INNER JOIN CasinoAdmin_tmp.dbo.Customer c (NOLOCK) ON c.ibccustid = s.CustID
							INNER JOIN CasinoAdmin_tmp.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid AND cgk.GameKind = 9
						WHERE cs.sdiscount <= @MaxComm)
		AND ci.roleid = 1 AND Enabled = 1
		AND cgk.GameKind = 9
		AND csa.SportType = @SportType AND csa.BetType = @BetType
		AND (
			cgk.MemberRollingRate <> csm.PlayerDiscount
			OR cgk.AgentRollingRate <> csm.AgentDiscount
			OR cgk.MAgentRollingRate <> csm.MasterDiscount
			OR cgk.SMAgentRollingRate <> csm.SuperDiscount
			)

ALTER TABLE #SMAPTCust
ADD PRIMARY KEY CLUSTERED (CustID)

ALTER TABLE #MemberPTCust
ADD PRIMARY KEY CLUSTERED (CustID)

ALTER TABLE #SMADiscountCust
ADD PRIMARY KEY CLUSTERED (CustID)

ALTER TABLE #MemberDiscountCust
ADD PRIMARY KEY CLUSTERED (CustID)				

--------------------------------------PT Setting-------------------------------------------------	
--Update PT for different settings (not adjust for line super who take pt RNG more than 93%)
--AGENT LEVEL
UPDATE csa
SET
	csa.SuperPT = ISNULL(ci.SPositionTaking,0)  *100,
	csa.MasterPT = ISNULL(CASE WHEN ci.roleid = 4 THEN ci.SPositionTaking ELSE ci.MPositionTaking END,0)  *100,
	csa.AgentPT = ISNULL(CASE WHEN ci.roleid = 4 THEN ci.SPositionTaking ELSE ci.APositionTaking END,0) *100, 
	csa.IsAutoMasterPT = ISNULL(ci.IsAutoMPositionTaking,0),
	csa.AutoMasterPT = ISNULL(ci.AutoMPositionTaking,0) *100, 
	csa.IsAutoSuperPT = ISNULL(ci.IsAutoPositionTaking ,0), 
	csa.AutoSuperPT = ISNULL(ci.AutoPositionTaking,0)  *100, 
	csa.MinPT = ci.MinPositionTaking  *100
FROM #SMAPTCust ci WITH(NOLOCK)
	INNER JOIN dbo.CustPTSetting3rd_Agent csa WITH(UPDLOCK,ROWLOCK) ON csa.custid = ci.CustID
WHERE csa.SportType = @SportType AND csa.BetType = @BetType

--MEMBER LEVEL
UPDATE csm
SET
	csm.SuperPT = ISNULL(ci.SPositionTaking,0)  *100,
	csm.MasterPT = ISNULL(ci.MPositionTaking,0)  *100,
	csm.AgentPT = ISNULL(ci.APositionTaking,0)  *100, 
	csm.IsAutoMasterPT = ISNULL(ci.IsAutoMPositionTaking,0),
	csm.AutoMasterPT = ISNULL(ci.AutoMPositionTaking,0) *100, 
	csm.IsAutoSuperPT = ISNULL(ci.IsAutoPositionTaking ,0), 
	csm.AutoSuperPT = ISNULL(ci.AutoPositionTaking,0)  *100
FROM #MemberPTCust ci WITH(NOLOCK)
	INNER JOIN dbo.CustPTSetting3rd_Member csm WITH(UPDLOCK,ROWLOCK) ON csm.custid = ci.CustID
WHERE csm.SportType = @SportType AND csm.BetType = @BetType

--------------------------------------Commission Setting-------------------------------------------------		
--Update Comm for different settings (not adjust for line super who take comm LCS more than 0.0007)
--Super Level
UPDATE csa
SET
	csa.Discount = CASE ci.roleid 
				WHEN 4 THEN ci.SMAgentRollingRate
				WHEN 3 THEN ci.MAgentRollingRate
				WHEN 2 THEN ci.AgentRollingRate
			END
FROM #SMADiscountCust ci WITH(NOLOCK)
	INNER JOIN dbo.CustDiscount3rd_Agent csa WITH(UPDLOCK,ROWLOCK) ON csa.custid = ci.CustID
WHERE csa.SportType = @SportType AND csa.BetType = @BetType

--Member Level
UPDATE csm
SET
	csm.PlayerDiscount = ci.MemberRollingRate,
	csm.AgentDiscount = ci.AgentRollingRate,
	csm.MasterDiscount = ci.MAgentRollingRate,
	csm.SuperDiscount = ci.SMAgentRollingRate
FROM #MemberDiscountCust ci WITH(NOLOCK)
	INNER JOIN dbo.CustDiscount3rd_Member csm WITH(UPDLOCK,ROWLOCK) ON csm.custid = ci.CustID
WHERE csm.SportType = @SportType AND csm.BetType = @BetType

DROP TABLE #SMAPTCust
DROP TABLE #MemberPTCust
DROP TABLE #SMADiscountCust
DROP TABLE #MemberDiscountCust
DROP TABLE #supers
/*SMA*/
--PT
UPDATE csa
SET
	csa.SuperPT = ISNULL(cgk.SPositionTaking,0)  *100,
	csa.MasterPT = ISNULL(CASE WHEN ci.roleid = 4 THEN cgk.SPositionTaking ELSE cgk.MPositionTaking END,0)  *100,
	csa.AgentPT = ISNULL(CASE WHEN ci.roleid = 4 THEN cgk.SPositionTaking ELSE cgk.APositionTaking END,0) *100, 
	csa.IsAutoMasterPT = ISNULL(cgk.IsAutoMPositionTaking,0),
	csa.AutoMasterPT = ISNULL(cgk.AutoMPositionTaking,0) *100, 
	csa.IsAutoSuperPT = ISNULL(cgk.IsAutoPositionTaking ,0), 
	csa.AutoSuperPT = ISNULL(cgk.AutoPositionTaking,0)  *100, 
	csa.MinPT = cgk.MinPositionTaking  *100
FROM dbo.CustPTSetting3rd_Agent csa
	INNER JOIN dbo.custinfo ci WITH(NOLOCK) ON csa.custid = ci.custid
	INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = csa.CustID
	INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid AND cgk.GameKind = 9
WHERE csa.SportType = 212 AND csa.Bettype = 4001
AND csa.custid = xxx --IBCCustID
--Comm
UPDATE csa
SET
	csa.Discount = CASE ci.roleid 
				WHEN 4 THEN cgk.SMAgentRollingRate
				WHEN 3 THEN cgk.MAgentRollingRate
				WHEN 2 THEN cgk.AgentRollingRate
			END
FROM dbo.CustDiscount3rd_Agent csa
	INNER JOIN dbo.custinfo ci WITH(NOLOCK) ON csa.custid = ci.custid
	INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = csa.CustID
	INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid AND cgk.GameKind = 9
WHERE csa.SportType = 212 AND csa.Bettype = 4001
AND csa.custid = xxx --IBCCustID

/*Members*/
--PT
SELECT IsGrouped
FROM custsettingmode3rd (NOLOCK)
WHERE custid = xxx

	--Individual
	UPDATE csm
	SET
		csm.SuperPT = ISNULL(cgk.SPositionTaking,0)  *100,
		csm.MasterPT = ISNULL(cgk.MPositionTaking,0)  *100,
		csm.AgentPT = ISNULL(cgk.APositionTaking,0)  *100, 
		csm.IsAutoMasterPT = ISNULL(cgk.IsAutoMPositionTaking,0),
		csm.AutoMasterPT = ISNULL(cgk.AutoMPositionTaking,0) *100, 
		csm.IsAutoSuperPT = ISNULL(cgk.IsAutoPositionTaking ,0), 
		csm.AutoSuperPT = ISNULL(cgk.AutoPositionTaking,0)  *100
	FROM dbo.CustPTSetting3rd_Member csm
		INNER JOIN dbo.custinfo ci WITH(NOLOCK) ON csm.custid = ci.custid
		INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = csm.CustID
		INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid AND cgk.GameKind = 9
	WHERE csm.SportType = 212 AND csm.Bettype = 4001
	AND csm.custid = xxx --IBCCustID
	
	--Grouped
	DECLARE @recommend INT
	SELECT @recommend = recommend
	FROM custinfo (NOLOCK)
	WHERE CustID = 1
	
	INSERT INTO dbo.CustPTSetting3rd_Member
	SELECT
			xxx,
			grpt.SportType,
			grpt.BetType,
			grpt.IsLive,
			grpt.SuperPT,
			grpt.MasterPT,
			grpt.AgentPT,
			grpt.IsAutoMasterPT,
			grpt.AutoMasterPT,
			grpt.IsAutoSuperPT,
			grpt.AutoSuperPT
	FROM dbo.CustPTGroupSetting3rd_Member grpt WITH(NOLOCK)
		LEFT JOIN dbo.CustPTSetting3rd_Member mempt ON mempt.CustID = xxx
														AND grpt.SportType=mempt.SportType
														AND grpt.BetType=mempt.BetType
														AND grpt.IsLive=mempt.IsLive
	WHERE grpt.AgentID=@recommend AND mempt.CustID IS NULL
	
	UPDATE custsettingmode3rd
	SET IsGrouped = 0
	WHERE custid = xxx
	
	UPDATE csm
	SET
		csm.SuperPT = ISNULL(cgk.SPositionTaking,0)  *100,
		csm.MasterPT = ISNULL(cgk.MPositionTaking,0)  *100,
		csm.AgentPT = ISNULL(cgk.APositionTaking,0)  *100, 
		csm.IsAutoMasterPT = ISNULL(cgk.IsAutoMPositionTaking,0),
		csm.AutoMasterPT = ISNULL(cgk.AutoMPositionTaking,0) *100, 
		csm.IsAutoSuperPT = ISNULL(cgk.IsAutoPositionTaking ,0), 
		csm.AutoSuperPT = ISNULL(cgk.AutoPositionTaking,0)  *100
	FROM dbo.CustPTSetting3rd_Member csm
		INNER JOIN dbo.custinfo ci WITH(NOLOCK) ON csm.custid = ci.custid
		INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = csm.CustID
		INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid AND cgk.GameKind = 9
	WHERE csm.SportType = 212 AND csm.Bettype = 4001
	AND csm.custid = xxx --IBCCustID


--Comm
UPDATE csm
SET
	csm.PlayerDiscount = cgk.MemberRollingRate,
	csm.AgentDiscount = cgk.AgentRollingRate,
	csm.MasterDiscount = cgk.MAgentRollingRate,
	csm.SuperDiscount = cgk.SMAgentRollingRate
FROM dbo.CustDiscount3rd_Member csm
	INNER JOIN dbo.custinfo ci WITH(NOLOCK) ON csm.custid = ci.custid
	INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.Customer c WITH(NOLOCK) ON c.ibccustid = csm.CustID
	INNER JOIN DBBINGOADMIN.CasinoAdmin.dbo.CustGameKind cgk WITH(NOLOCK) ON cgk.custid = c.custid AND cgk.GameKind = 9
WHERE csm.SportType = 212 AND csm.Bettype = 4001
AND csm.custid = xxx --IBCCustID
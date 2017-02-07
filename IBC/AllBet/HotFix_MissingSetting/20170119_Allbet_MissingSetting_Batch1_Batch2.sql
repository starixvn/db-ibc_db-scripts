CREATE TABLE #cust_missingsetting (custid INT, Roleid INT, srecommend INT, mrecommend INT, recommend INT)

INSERT INTO #cust_missingsetting (custid,Roleid,srecommend,mrecommend,recommend)
SELECT custid,Roleid,srecommend,mrecommend,recommend
FROM custInfo CI WITH (NOLOCK)
WHERE CI.custid IN (1)
/********************************************* Position Taking: SettingType = 1 ***********************************/
-- @RoleID = 4

--s4: 0
--m4: 0
--a4: 0
--n4: 0
--l4: Default Max PT
SELECT MAXPT FROM dbo.ProductSettingDetail dtl WITH (NOLOCK) WHERE SportType = 211
INSERT INTO [dbo].[CustPTSetting3rd_Agent]
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
   ,[AutoSuperPT]
   ,[MinPT]
   ,[MaxPT])
SELECT 
	@Custid
	,dtl.SportType
	,dtl.BetType
	,dtl.IsLive
	,0,0,0,0,0,0,0,0
	,dtl.MaxPT
FROM dbo.ProductSettingDetail dtl WITH (NOLOCK)
	

-- @RoleID = 3
--s3: 0
--m3: 0
--is3: 0
--us3: 0
--n3: 0
--l3: Default Max PT
INSERT INTO [dbo].[CustPTSetting3rd_Agent]
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
   ,[AutoSuperPT]
   ,[MinPT]
   ,[MaxPT])
SELECT 
	@CustID
	,dtl.SportType
	,dtl.BetType
	,dtl.IsLive
	,0,0,0,0,0,0,0,0
	,dtl.MaxPT
FROM dbo.ProductSettingDetail dtl WITH (NOLOCK)
	INNER JOIN #SportBettypeFilter1 ft ON dtl.SportType = ft.SportType AND dtl.BetType = ft.BetType AND dtl.IsLive = ft.IsLive AND dtl.SettingType = ft.SettingType
	INNER JOIN CustPTSetting3rd_Agent spt ON dtl.SportType = spt.SportType AND dtl.BetType = spt.BetType AND dtl.IsLive = spt.IsLive
WHERE dtl.SettingType = 1 AND spt.CustID = @SuperID

--@RoleID = 2
--m2: 0
--a2: 0
--im2: 0
--um2: 0
--n2: 0
--l2: Default Max PT
INSERT INTO [dbo].[CustPTSetting3rd_Agent]
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
   ,[AutoSuperPT]
   ,[MinPT]
   ,[MaxPT])
SELECT 
@custid,dtl.SportType,dtl.BetType,dtl.IsLive,
	0,0,0,0,0,0,0,0
	,dtl.MaxPT
FROM dbo.ProductSettingDetail dtl WITH (NOLOCK)
	INNER JOIN #SportBettypeFilter1 ft ON dtl.SportType = ft.SportType AND dtl.BetType = ft.BetType AND dtl.IsLive = ft.IsLive AND dtl.SettingType = ft.SettingType
	INNER JOIN CustPTSetting3rd_Agent mpt ON dtl.SportType = mpt.SportType AND dtl.BetType = mpt.BetType AND dtl.IsLive = mpt.IsLive
WHERE dtl.SettingType = 1 AND mpt.custid = @MasterID

--RoleID = 1
DECLARE @n2 SMALLMONEY, @l2 SMALLMONEY
DECLARE @im2 bit, @um2 SMALLMONEY
DECLARE @a1 SMALLMONEY, @m1 SMALLMONEY, @s1 SMALLMONEY, @i1 bit, @u1 SMALLMONEY, @im1 bit, @um1 SMALLMONEY
DECLARE @temp1 SMALLMONEY, @temp2 SMALLMONEY, @temp3 SMALLMONEY
DECLARE @s_new SMALLMONEY, @m_new SMALLMONEY, @a_new SMALLMONEY

DECLARE @MemberPTTbl TABLE (
		CustID		INT
	, [SportType]	SMALLINT
	, [BetType]		SMALLINT
	, [Islive]		BIT	
	, [SuperPT]		TINYINT	
	, [MasterPT]	TINYINT
	, [AgentPT]		TINYINT
	, [IsAutoMPT]	BIT
	, [AutoMPT]		TINYINT
	, [IsAutoSPT]	BIT
	, [AutoSPT]		TINYINT
)

--Get default PT settings	
--s1: s3
--m1: m2
--a1: a2
--is1: 0
--us1: 0
--im1: 0
--um1: 0
INSERT INTO @MemberPTTbl (
	CustID
	, SportType
	, BetType
	, Islive
	, SuperPT
	, MasterPT
	, AgentPT
	, IsAutoMPT
	, AutoMPT
	, IsAutoSPT
	, AutoSPT
	)
SELECT @CustID
	, acs.SportType
	, acs.BetType
	, acs.IsLive
	, mcs.superPT
	, acs.masterPT
	, acs.agentPT
	, 0
	, 0
	, 0
	, 0
FROM dbo.CustPTSetting3rd_Agent acs WITH (NOLOCK)
	INNER JOIN dbo.CustPTSetting3rd_Agent mcs WITH (NOLOCK) ON acs.sporttype = mcs.sporttype AND acs.bettype = mcs.bettype AND acs.islive = mcs.islive AND mcs.custid = @MasterID
	INNER JOIN #SportBettypeFilter1 ft ON mcs.SportType = ft.SportType AND mcs.BetType = ft.BetType AND mcs.IsLive = ft.IsLive
WHERE acs.custid = @AgentID

--Correct PT
UPDATE cs
SET @a1 = cs.AgentPT
	,@m1 = cs.MasterPT
	,@s1 = cs.SuperPT
	,@n2 = acs.MinPT
	,@l2 = acs.MaxPT
	,@im2 = acs.IsAutoMasterPT
	,@um2 = acs.AutoMasterPT
	,@i1 = cs.IsAutoSPT
	,@u1 = cs.AutoSPT
	,@im1 = cs.IsAutoMPT
	,@um1 = cs.AutoMPT

	-- rule #1: s1 = min(s1,s4-m3) if i=0
	,@s1 = CASE WHEN @i1 = 0 AND m.IsAutoSuperPT = 0 AND s.SuperPT-m.MasterPT < @s1 THEN s.SuperPT-m.MasterPT ELSE @s1 END

	-- rule #2: a1 = max(a1,n2); m1 = (a1<n2) ? m3-n2 : m1 --agent min
	,@a_new = CASE WHEN @a1 < @n2 THEN @n2 ELSE @a1 END
	,@m_new = CASE WHEN @a1 < @n2 AND @m1+@n2 > m.MasterPT THEN m.MasterPT-@n2 ELSE @m1 END
	,@a1 = @a_new
	,@m1 = @m_new								

	-- rule #3: a1 = min(a1,l2) -- agent max         
	,@a1 = CASE WHEN @a1 > @l2 THEN @l2 ELSE @a1 END

	-- rule #4: m1 = min(m3-a1,u2) if master auto -- Recalculate AUTO MPT 
	,@temp1 = CASE WHEN @im1 = 1 THEN @um1 ELSE @um2 END			
	,@m1 = CASE 
				WHEN @im2 = 1 OR @im1 = 1 
				THEN CASE WHEN m.MasterPT-@a1 > @temp1 THEN @temp1 ELSE m.MasterPT-@a1 END 
				ELSE @m1 
			END		

	-- rule #5: m1 = max(m1,n3-a1) -- master min   
	,@m1 = CASE WHEN @m1 < m.MinPT-@a1 THEN m.MinPT-@a1 ELSE @m1 END
         
	-- rule #6: check master max 
	/*	@x1 = min(m3,l3) -- mpt max
		@x2 = max(@x1-a1,0) --mpt
		m1 = (a1+m1>l3) ? @x2 : m1
		@x3 = (a1+@x2 > @x1) ? @x1-@x2 : a1
		a1 = (a1+m1>l1) ? max(@x3, n2) : a1
	*/ 
	,@temp1 = CASE WHEN m.MasterPT > m.MaxPT THEN m.MaxPT ELSE m.MasterPT END
	,@temp2 = CASE WHEN @temp1-@a1 < 0 THEN 0 ELSE @temp1-@a1 END
	,@m_new = CASE WHEN @a1+@m1 > m.MaxPT THEN @temp2 ELSE @m1 END
	,@temp3 = CASE WHEN @a1+@temp2 > @temp1 THEN @temp1-@temp2 ELSE @a1 END
	,@a_new = CASE 
				WHEN @a1+@m1 > m.MaxPT 
				THEN CASE WHEN @temp3 < @n2 THEN @n2 ELSE @temp3 END
				ELSE @a1 
			END	
	
	,@m1 = @m_new
	,@a1 = @a_new
	-- rule #7: s1 = min(s4-m1-a1, i1?u1:u3) --Recalculate auto pt
	/*
		@x1 = (i1=1) ? u1 : u3
		s1 = (s4-m1-a1 > @x1) ? @x1 : s4-m1-a1 
	*/
	,@temp1 = CASE WHEN @i1 = 1 THEN @u1 ELSE m.AutoSuperPT END			
	,@s1 = CASE 
				WHEN @i1 = 1 OR m.IsAutoSuperPT = 1 
				THEN CASE WHEN s.SuperPT-@m1-@a1 > @temp1 THEN @temp1 ELSE s.SuperPT-@m1-@a1 END
				ELSE @s1
			END		

	-- rule #8: s1 = max(n4-m1-a1,s1) --super min
	,@s1 = CASE WHEN @a1+@m1+@s1 < s.MinPT THEN s.MinPT-@m1-@a1 ELSE @s1 END	

	-- rule #9: UPDATE s1,m1,a1 in case s1+m1+a1>s4
	/* -- explanation
		@x1 = (s4-m1-a1 < 0) ? 0 : s4-m1-a1
		s1 = (s1+a1+m1 > s4) ? @x1 : s1
		@x1 = (@x1+m1+a1 > s4) ? s4-@x1 : m1+a1
		@x2 = (m3 > l3) ? l3 : m3
		@x2 = (@x1 > @x2) ? @x2 : @x1
		@x2 = (@x2 < n3) ? n3 : @x2
		@x3 = (@x2-a1 < 0) ? 0 : @x2-a1
		m1 = (s1+a1+m1 > s4) ? @x3 : m1
		@x3 = (a1+@x3>@x2) ? @x2-@x3 : a1
		@x3 =  (@x3 < n2) ? n2 : @x3
		a1 = (s1+a1+m1 > s4) ? @x3 : a1				
	*/             
	,@temp1 = CASE WHEN s.SuperPT-@m1-@a1 < 0 THEN 0 ELSE s.SuperPT-@m1-@a1 END
	,@s_new = CASE WHEN @s1+@a1+@m1 > s.SuperPT THEN @temp1 ELSE @s1 END
	,@temp1 = CASE WHEN @temp1+@m1+@a1 > s.SuperPT THEN s.SuperPT-@temp1 ELSE @m1+@a1 END
	,@temp2 = CASE WHEN m.MasterPT > m.MaxPT THEN m.MaxPT ELSE m.MasterPT END
	,@temp2 = CASE WHEN @temp1 > @temp2 THEN @temp2 ELSE @temp1 END
	,@temp2 = CASE WHEN @temp2 < m.MinPT THEN m.MinPT ELSE @temp2 END
	,@temp3 = CASE WHEN @temp2-@a1 < 0 THEN 0 ELSE @temp2-@a1 END
	,@m_new = CASE WHEN @s1+@a1+@m1 > s.SuperPT THEN @temp3 ELSE @m1 END
	,@temp3 = CASE WHEN @a1+@temp3 > @temp2 THEN @temp2-@temp3 ELSE @a1 END
	,@temp3 = CASE WHEN @temp3 < @n2 THEN @n2 ELSE @temp3 END
	,@a_new = CASE WHEN @s1+@a1+@m1 > s.SuperPT THEN @temp3 ELSE @a1 END
	,@s1 = @s_new
	,@m1 = @m_new
	,@a1 = @a_new

	--PT values must be in [0,100]
	,@s1 = CASE WHEN @s1 < 0 THEN 0 ELSE @s1 END
	,@s1 = CASE WHEN @s1 > 100 THEN 100 ELSE @s1 END
	,@m1 = CASE WHEN @m1 < 0 THEN 0 ELSE @m1 END
	,@m1 = CASE WHEN @m1 > 100 THEN 100 ELSE @m1 END
	,@a1 = CASE WHEN @a1 < 0 THEN 0 ELSE @a1 END
	,@a1 = CASE WHEN @a1 > 100 THEN 100 ELSE @a1 END

	--------------------------------	
	-- done apply all rule, then update to destination table
	,cs.AgentPT = @a1
	,cs.MasterPT = @m1
	,cs.SuperPT = @s1								       
FROM @MemberPTTbl cs 
	INNER JOIN dbo.CustPTSetting3rd_Agent acs WITH(NOLOCK) 
		ON @AgentID = acs.custid 
			AND cs.sporttype = acs.sporttype 
			AND cs.bettype = acs.bettype 
			AND cs.IsLive = acs.IsLive
	INNER JOIN dbo.CustPTSetting3rd_Agent m WITH(NOLOCK) 
		ON @MasterID = m.custid 
			AND cs.sporttype = m.sporttype 
			AND cs.bettype = m.bettype 
			AND cs.IsLive = m.IsLive
	INNER JOIN dbo.CustPTSetting3rd_Agent s WITH(NOLOCK)  
		ON @SuperID = s.custid 
			AND cs.sporttype = s.sporttype 
			AND cs.bettype = s.bettype 
			AND cs.IsLive = s.IsLive
		
--If this is the first member,insert into Group Setting
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
SELECT 
	@AgentID,SportType,BetType,Islive,
	SuperPT,MasterPT,AgentPT,IsAutoMPT,AutoMPT,IsAutoSPT,AutoSPT
FROM @MemberPTTbl
WHERE NOT EXISTS(SELECT TOP 1 1 FROM dbo.CustPTGroupSetting3rd_Member WHERE AgentID = @AgentID)
AND @SuperID IN (
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
		--UUS
		,17287861
		,18879367
		,14373244
		,18362423
		,18479460
		,18289591
	)

IF @@ROWCOUNT<>0
BEGIN
	INSERT INTO dbo.CustSettingMode3rd(CustID,IsGrouped)
		SELECT @CustID,1
END
ELSE
BEGIN
	IF EXISTS(SELECT TOP 1 1
				FROM dbo.CustPTGroupSetting3rd_Member grp
				JOIN @memberPTTbl tmp ON tmp.SportType = grp.SportType
										AND tmp.BetType = grp.BetType
										AND tmp.Islive = grp.Islive
				WHERE grp.AgentID = @AgentID
				AND (
					tmp.SuperPT <> grp.SuperPT
					OR
					tmp.MasterPT <> grp.MasterPT
					OR
					tmp.AgentPT <> grp.AgentPT
					OR
					tmp.IsAutoMPT <> grp.IsAutoMasterPT
					OR
					tmp.AutoMPT <> grp.AutoMasterPT
					OR
					tmp.IsAutoSPT <> grp.IsAutoSuperPT
					OR
					tmp.AutoSPT <> grp.AutoSuperPT
				))
		OR @SuperID NOT IN (
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
							--UUS
							,17287861
							,18879367
							,14373244
							,18362423
							,18479460
							,18289591
						)
	BEGIN
		--If this member's PT setting are diffrent from Group PT Setting
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
		SELECT 
		@CustID,SportType,BetType,Islive,
			SuperPT,MasterPT,AgentPT,IsAutoMPT,AutoMPT,IsAutoSPT,AutoSPT
		FROM @memberPTTbl
	
		INSERT INTO dbo.CustSettingMode3rd(CustID,IsGrouped)
			SELECT @CustID,0
	END
	ELSE
	BEGIN
		INSERT INTO dbo.CustSettingMode3rd(CustID,IsGrouped)
			SELECT @CustID,1
	END
END



/********************************************* Commision : SettingType = 3 ****************************************/
SELECT * INTO #SportBettypeFilter3
FROM dbo.f_CustSetting_SportBetTypeSettingSelect(@ProductID,3)

BEGIN TRY
IF @RoleID = 4
BEGIN
IF EXISTS(SELECT TOP 1 1 FROM #SportBettypeFilter3)
BEGIN
	INSERT INTO [dbo].[CustDiscount3rd_Agent]
	   ([CustID]
	   ,[SportType]
	   ,[BetType]
	   ,[Discount])
	SELECT 
		@CustID
		,ft.SportType
		,ft.BetType
		,0 -- 0 zero by default
	FROM #SportBettypeFilter3 ft 
		INNER JOIN #ProductSettingDetail fil ON ft.SettingType = fil.SettingType AND ft.SportType = fil.SportType AND ft.BetType = fil.BetType 
END
END
ELSE IF @RoleID = 3
BEGIN
INSERT INTO [dbo].[CustDiscount3rd_Agent]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[Discount])
SELECT 
	@CustID
	,dc.SportType
	,dc.BetType
	,0 -- 0 zero by default
FROM CustDiscount3rd_Agent dc WITH(NOLOCK) 
	INNER JOIN #SportBettypeFilter3 f ON dc.SportType = f.SportType AND dc.BetType = f.BetType
WHERE CustID = @SuperID
END
ELSE IF @RoleID = 2
BEGIN
INSERT INTO [dbo].[CustDiscount3rd_Agent]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[Discount])
SELECT 
	@CustID
	,dc.SportType
	,dc.BetType
	,0 -- 0 zero by default
FROM CustDiscount3rd_Agent dc WITH(NOLOCK) 
	INNER JOIN #SportBettypeFilter3 f ON dc.SportType = f.SportType AND dc.BetType = f.BetType
WHERE CustID = @MasterID
END
ELSE
BEGIN
--super.discount: super.discount
--master.discount: master.discount
--agent.discount: agent.discount
--playerdiscount: 0
INSERT INTO [dbo].[CustDiscount3rd_Member]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[PlayerDiscount]
   ,[AgentDiscount]
   ,[MasterDiscount]
   ,[SuperDiscount])
SELECT 
	@CustID
	,acs.SportType
	,acs.BetType
	,0
	,acs.Discount
	,mcs.Discount
	,scs.Discount
FROM dbo.CustDiscount3rd_Agent acs WITH (NOLOCK)
	INNER JOIN #SportBettypeFilter3 f ON acs.SportType = f.SportType AND acs.BetType = f.BetType
	INNER JOIN dbo.CustDiscount3rd_Agent mcs WITH (NOLOCK) ON acs.sporttype = mcs.sporttype AND acs.bettype = mcs.bettype AND mcs.custid = @MasterID
	INNER JOIN dbo.CustDiscount3rd_Agent scs WITH (NOLOCK) ON acs.sporttype = scs.sporttype AND acs.bettype = scs.bettype AND scs.custid = @SuperID
WHERE acs.custid=@AgentID
END
END TRY
BEGIN CATCH
SELECT @ErrCode = 3
DELETE FROM CustProductStatus WHERE CustID = @CustID
IF @RoleID = 1
BEGIN
DELETE FROM CustPTSetting3rd_Member WHERE CustID = @CustID
DELETE FROM CustSettingMode3rd WHERE CustID = @CustID
DELETE FROM CustBetSetting3rd_Member WHERE CustID = @CustID	
DELETE FROM CustDiscount3rd_Member WHERE CustID = @CustID
END
ELSE --SMA
BEGIN
DELETE FROM CustPTSetting3rd_Agent WHERE CustID = @CustID	
DELETE FROM CustBetSetting3rd_Agent WHERE CustID = @CustID
DELETE FROM CustDiscount3rd_Agent WHERE CustID = @CustID
END
RETURN
END CATCH

/*********************************************Charge Commision : SettingType = 5 ****************************************/


-- @RoleID = 4

	INSERT INTO [dbo].[CustDiscount3rd_Agent]
	   ([CustID]
	   ,[SportType]
	   ,[BetType]
	   ,[Discount])
	SELECT 
		@CustID
		,ft.SportType
		,ft.BetType
		,0 -- 0 zero by default
	FROM #SportBettypeFilter5 ft 
		INNER JOIN #ProductSettingDetail fil ON ft.SettingType = fil.SettingType AND ft.SportType = fil.SportType AND ft.BetType = fil.BetType 

-- @RoleID = 3

INSERT INTO [dbo].[CustDiscount3rd_Agent]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[Discount])
SELECT 
	@CustID
	,dc.SportType
	,dc.BetType
	,0 -- 0 zero by default
FROM CustDiscount3rd_Agent dc WITH(NOLOCK)
	INNER JOIN #SportBettypeFilter5 f ON dc.SportType = f.SportType AND dc.BetType = f.BetType 
WHERE CustID = @SuperID
-- @RoleID = 2

INSERT INTO [dbo].[CustDiscount3rd_Agent]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[Discount])
SELECT 
	@CustID
	,dc.SportType
	,dc.BetType
	,0 -- 0 zero by default
FROM CustDiscount3rd_Agent dc WITH(NOLOCK) 
	INNER JOIN #SportBettypeFilter5 f ON dc.SportType = f.SportType AND dc.BetType = f.BetType 
WHERE CustID = @MasterID
-- @roleid = 1
--super.discount: super.discount
--master.discount: master.discount
--agent.discount: agent.discount
--playerdiscount: Maximum Charge Comm
INSERT INTO [dbo].[CustDiscount3rd_Member]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[PlayerDiscount]
   ,[AgentDiscount]
   ,[MasterDiscount]
   ,[SuperDiscount])
SELECT 
	@CustID
	,acs.SportType
	,acs.BetType
	,ps.MaxDiscount
	,acs.Discount
	,mcs.Discount
	,scs.Discount
FROM dbo.CustDiscount3rd_Agent acs WITH (NOLOCK)
	INNER JOIN dbo.CustDiscount3rd_Agent mcs WITH (NOLOCK)
				ON acs.sporttype = mcs.sporttype
				AND acs.bettype = mcs.bettype
				AND mcs.custid = @MasterID
	INNER JOIN dbo.CustDiscount3rd_Agent scs WITH (NOLOCK)
				ON acs.sporttype = scs.sporttype
				AND acs.bettype = scs.bettype
				AND scs.custid = @SuperID
	INNER JOIN #SportBettypeFilter5 f ON acs.SportType = f.SportType AND acs.BetType = f.BetType 
	INNER JOIN dbo.ProductSettingDetail ps WITH (NOLOCK) ON ps.BetType = acs.BetType AND ps.SportType = acs.SportType AND ps.SettingType = 5
WHERE acs.custid=@AgentID

/********************************************* SMA WinLimit : SettingType = 6 ****************************************/


-- @RoleID = 4

	--MaxWinLimit: 0 (Unlimited)
	--MaxLossLimit: get from global setting based on currency
	--IsAutoReset: 1		
	INSERT INTO [dbo].[CustWinLossLimit_Agent]
	   ([CustID]
	   ,[SportType]
	   ,[BetType]
	   ,[MaxWinLimit]
	   ,[MaxLossLimit]
	   ,[IsAutoReset])
	SELECT
		@CustID
		,ft.SportType
		,ft.BetType
		,0
		,gs.DefaultLossLimit
		,1
	FROM #SportBettypeFilter6 ft 
		INNER JOIN #ProductSettingDetail fil ON ft.SettingType = fil.SettingType AND ft.SportType = fil.SportType AND ft.BetType = fil.BetType 
		INNER JOIN LossLimit_GlobalSetting gs ON gs.ProductId = ft.ProductID
		INNER JOIN CustInfo ci WITH (NOLOCK) ON gs.ExchangeId = ci.currency
	WHERE ci.custid = @CustID
END
--@RoleID = 3

--MaxWinLimit: super.MaxWinLimit
--MaxLossLimit: super.MaxLossLimit
--IsAutoReset: super.IsAutoReset
INSERT INTO [dbo].[CustWinLossLimit_Agent]
	([CustID]
	,[SportType]
	,[BetType]
	,[MaxWinLimit]
	,[MaxLossLimit]
	,[IsAutoReset])
SELECT
	@CustID
	,cs.SportType
	,cs.BetType
	,MaxWinLimit
	,MaxLossLimit
	,IsAutoReset
FROM dbo.CustWinLossLimit_Agent cs WITH (NOLOCK)
	INNER JOIN #SportBettypeFilter6 f ON f.Bettype = cs.BetType AND f.SportType = cs.SportType
WHERE custid = @SuperID

-- @RoleID = 2

--MaxWinLimit: master.MaxWinLimit
--MaxLossLimit: master.MaxLossLimit
--IsAutoReset: master.IsAutoReset
INSERT INTO [dbo].[CustWinLossLimit_Agent]
	([CustID]
	,[SportType]
	,[BetType]
	,[MaxWinLimit]
	,[MaxLossLimit]
	,[IsAutoReset])
SELECT
	@CustID
	,cs.SportType
	,cs.BetType
	,MaxWinLimit
	,MaxLossLimit
	,IsAutoReset
FROM dbo.CustWinLossLimit_Agent cs WITH (NOLOCK)
	INNER JOIN #SportBettypeFilter6 f ON f.Bettype = cs.BetType AND f.SportType = cs.SportType
WHERE custid = @MasterID

-- @Roleid = 1
--MaxWinLimit: agent.MaxWinLimit
--MaxLossLimit: agent.MaxLossLimit
--IsAutoReset: agent.IsAutoReset
INSERT INTO [dbo].[CustWinLossLimit_Member]
	([CustID]
	,[SportType]
	,[BetType]
	,[MaxWinLimit]
	,[MaxLossLimit]
	,[IsAutoReset])
SELECT
	@CustID
	,cs.SportType
	,cs.BetType
	,MaxWinLimit
	,MaxLossLimit
	,IsAutoReset
FROM dbo.CustWinLossLimit_Agent cs WITH (NOLOCK)
	INNER JOIN #SportBettypeFilter6 f ON f.Bettype = cs.BetType AND f.SportType = cs.SportType
WHERE custid = @AgentID


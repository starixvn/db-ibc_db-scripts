/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/
USE CustDB
GO

UPDATE CI
	SET currency = CIB.currency
	  , maxpermatch = CIB.maxpermatch
	  , maxpermatch2 = CIB. maxpermatch2
	  , maxpermatch3 = CIB.maxpermatch3
	  , maxpermatch5 = CIB.maxpermatch5
	  , maxpermatch8 = CIB.maxpermatch8
	  , maxpermatch10 = CIB.maxpermatch10
	  , maxpermatch11 = CIB. maxpermatch11
	  , MaxPerMatch44 = CIB.MaxPerMatch44
	  , maxpermatch201 = CIB.maxpermatch201
	  , maxpermatch151 = CIB.maxpermatch151
	  
	  , maxpermatch151_OT = CIB.maxpermatch151_OT
	  , MaxPerMatch151_AU = CIB.MaxPerMatch151_AU
	  , MaxPerMatch152_UK = CIB.MaxPerMatch152_UK
	  , MaxPerMatch152_AU = CIB.MaxPerMatch152_AU
	  , MaxPerMatch153_AU = CIB.MaxPerMatch153_AU
	  , maxpermatch99 = CIB.maxpermatch99
	  --, roleid, srecommend, mrecommend, recommend
	  , dangercust = CIB.dangercust
	  , autosuspend = CIB.autosuspend
	  , autosuspend2 = CIB.autosuspend2
	  , reject = CIB.reject
	  , credit = CIB.credit
	  , closed = CIB.closed
	  
	  , MatchLimit = CIB.MatchLimit
	  , VirtualMultiplier = CIB.VirtualMultiplier
	  , DisableHorseRacing = CIB.DisableHorseRacing
	  , DisableOpenTote = CIB.DisableOpenTote
	  , Disable151_AU = CIB.Disable151_AU
	  , Disable152_UK = CIB.Disable152_UK
	  , Disable152_AU = CIB.Disable152_AU
	  , Disable153_AU = CIB.Disable153_AU
	  , DisableFinancial = CIB.DisableFinancial
	  , DisableOutright = CIB.DisableOutright
	  , DisableCasino = CIB.DisableCasino
	  , DisableNumber = CIB.DisableNumber
	  , DisableBingo = CIB.DisableBingo
	  , maxpermatch161 = CIB.maxpermatch161
	  , MaxPerMatch99MP = CIB.MaxPerMatch99MP
	  , MaxPerBall161 = CIB.MaxPerBall161
	  , MaxPerMatch180 = CIB.MaxPerMatch180
	  , MaxPerMatch181 = CIB.MaxPerMatch181
	  , MaxPerMatch186 = CIB.MaxPerMatch186
	  , danger = CIB.danger
	  , danger2 = CIB.danger2
	  , danger3 = CIB.danger3
	  , Abnormal = CIB.Abnormal
	  , DisableP2P = CIB.DisableP2P
	  , DisableFunP2P = CIB.DisableFunP2P
	  , IsAutoResetP2P = CIB.IsAutoResetP2P
	  , DisableLiveCasino = CIB.DisableLiveCasino
	  , DisableVirtualSports = CIB.DisableVirtualSports
	  , HideVirtualSports = CIB.HideVirtualSports
	  , DoubleCommLosing = CIB.DoubleCommLosing
	  , isAutoResetLiveCasino = CIB.isAutoResetLiveCasino
	  , MaxWinLiveCasino = CIB.MaxWinLiveCasino
	  , DisableCasinoBonus = CIB.DisableCasinoBonus
	  , maxpermatch154 = CIB.maxpermatch154
	  , DisableHRFixedOdds = CIB.DisableHRFixedOdds
	  , maxpermatch182 = CIB.maxpermatch182
	  , maxpermatch184 = CIB.maxpermatch184
	  , HideKeno = CIB.HideKeno
	  , maxpermatch183 = CIB.maxpermatch183
	  , maxpermatch185 = CIB.maxpermatch185
	  , DisableEsports = CIB.DisableEsports
	  , DisableGoldDeluxe = CIB.DisableGoldDeluxe
	  , HideGoldDeluxe = CIB.HideGoldDeluxe
	  , DisableSuperLive = CIB.DisableSuperLive
	  , DisableColossusBet = CIB.DisableColossusBet
	  , HideColossusBet = CIB.HideColossusBet
	  , MaxPerMatch1MP = CIB.MaxPerMatch1MP

FROM custinfo CI WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN custinfo_20170505_BACKUP	 CIB  WITH (NOLOCK) ON CI.username = CIB.username
WHERE ci.username IN ('TVA96QG82','TY81H104')

UPDATE C
	SET firstname = CB.firstname
		, lastname = CB.lastname
		, phone = CB.phone
		, mobilephone = CB.mobilephone
		, fax = CB.fax
		, email = CB.email
		, address = CB.address
		, city = CB.city
		, state = CB.state
		, country = CB.country
		, postal = CB.postal
		, userpwd = CB.userpwd
		--, roleid, srecommend, mrecommend, recommend, 
		, currency = CB.currency
		, pwdexpiry = CB.pwdexpiry
		, creator = CB.creator
		, Site = CB.Site
		, creatdate = CB.creatdate
		, ugroup = CB.ugroup

FROM Customer C WITH(ROWLOCK,UPDLOCK)
	INNER JOIN Customer_20170505_BACKUP CB WITH (NOLOCK) ON C.username = CB.username
WHERE c.username IN ('TVA96QG82','TY81H104')

UPDATE CA
	SET MaxCredit = CAB.MaxCredit
		, IsInternal = CAB.IsInternal
		, TransferOption = CAB.TransferOption
		, Site = CAB.Site

FROM CustAgent CA WITH(ROWLOCK,UPDLOCK) 
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = CA.custid
	INNER JOIN custinfo_20170505_BACKUP CIB WITH (NOLOCK) ON CI.username = 	CIB.username
	INNER JOIN CustAgent_20170505_BACKUP CAB WITH (NOLOCK) ON CIB.custid = CAB.custID
				    
WHERE CI.username IN ('TVA96QG82','TY81H104')


UPDATE CLI
	SET OldUserPwd = CLIB.OldUserPwd
		, LastChangedPwdDate = CLIB.LastChangedPwdDate
		, isFirstLogin = CLIB.isFirstLogin
		, SecurityCodeCount = CLIB.SecurityCodeCount
		, SecurityCode = CLIB.SecurityCode
		, isForcedChangeSecurityCode = CLIB.isForcedChangeSecurityCode
		, LastChangedSecurityCodeDate = CLIB.LastChangedSecurityCodeDate

FROM CustLoginInfo CLI WITH(ROWLOCK,UPDLOCK) 
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = CLI.custid
	INNER JOIN custinfo_20170505_BACKUP CIB WITH (NOLOCK) ON CI.username = 	CIB.username
	INNER JOIN CustLoginInfo_20170505_BACKUP CLIB ON CLIB.custid = CIB.custid			    	        
WHERE CI.username IN ('TVA96QG82','TY81H104')


UPDATE CPS
	SET bitmapIsDisabled = CPSD.bitmapIsDisabled
		,bitmapIsHidden = CPSD.bitmapIsHidden
		,bitmapHasSynced = CPSD.bitmapHasSynced

FROM [CustProductStatus] CPS WITH(ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = CLI.custid
	INNER JOIN custinfo_20170505_BACKUP CIB WITH (NOLOCK) ON CI.username = 	CIB.username
	INNER JOIN CustProductStatus_20170505_BACKUP CPSD WITH (NOLOCK) ON CPSD.custid = CIB.custid	
WHERE CI.username IN ('TVA96QG82','TY81H104')     


UPDATE CS
	   SET   [SuperPT] = CSB.SuperPT
		   ,[MasterPT] = CSB.MasterPT
		   ,[AgentPT] = CSB.AgentPT
		   ,[IsAutoMasterPT] = CSB.IsAutoMasterPT
		   ,[AutoMasterPT] = CSB.AutoMasterPT
		   ,[IsAutoSuperPT] = CSB.IsAutoSuperPT
		   ,[AutoSuperPT] = CSB.AutoSuperPT
		   ,[MinPT] = CSB.MinPT
		   ,[MaxPT] = CSB.MaxPT
				   
FROM [CustPTSetting3rd_Agent] CS WITH(ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = CLI.custid
	INNER JOIN custinfo_20170505_BACKUP CIB WITH (NOLOCK) ON CI.username = 	CIB.username 
	INNER JOIN CustPTSetting3rd_Agent_20170505_BACKUP CSB ON  CSB.custid = CIB.custid 
				AND CS.SportType = CSB.SportType 
				AND CS.BetType = CSB.BetType
				AND CS.IsLive = CSB.IsLive
WHERE CI.username IN ('TVA96QG82','TY81H104')

UPDATE CBS
		SET [MinBet] = CSB.MinBet
		   ,[MaxBet] = CSB.MaxBet
		   ,[MaxPerMatch] = CSB.MaxPerMatch

FROM  [CustBetSetting3rd_Agent] CBS WITH(ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = CBS.custid
	INNER JOIN custinfo_20170505_BACKUP CIB WITH (NOLOCK) ON CI.username = 	CIB.username 
	INNER JOIN CustBetSetting3rd_Agent_20170505_BACKUP CSB ON  CSB.custid = CIB.custid 
				AND CS.SportType = CSB.SportType 
				AND CS.BetType = CSB.BetType
				
WHERE CI.username IN ('TVA96QG82','TY81H104')

UPDATE CS
	SET [Discount] = CSB.Discount
FROM  [CustDiscount3rd_Agent] CS WITH(ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = CS.custid
	INNER JOIN custinfo_20170505_BACKUP CIB WITH (NOLOCK) ON CI.username = 	CIB.username 
	INNER JOIN CustDiscount3rd_Agent_20170505_BACKUP CSB (NOLOCK) ON  CSB.custid = CIB.custid 
				AND CS.SportType = CSB.SportType 
				AND CS.BetType = CSB.BetType	
WHERE CI.username IN ('TVA96QG82','TY81H104')


UPDATE CWA
	SET [MaxWinLimit] =CSB.MaxWinLimit
	   ,[MaxLossLimit] = CSB.MaxLossLimit
	   ,[IsAutoReset] = CSB.IsAutoReset

FROM [CustWinLossLimit_Agent] CWA WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = CWA.custid
	INNER JOIN custinfo_20170505_BACKUP CIB WITH (NOLOCK) ON CI.username = 	CIB.username 
	INNER JOIN CustWinLossLimit_Agent_20170505_BACKUP CSB WITH (NOLOCK) ON  CSB.custid = CIB.custid 
				AND CS.SportType = CSB.SportType 
				AND CS.BetType = CSB.BetType	
				
WHERE CI.username IN ('TVA96QG82','TY81H104')


UPDATE CS
	SET StakeLevelList = CSB.StakeLevelList

FROM CustStakeLevel_Agent CS WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = CS.custid
	INNER JOIN custinfo_20170505_BACKUP CIB WITH (NOLOCK) ON CI.username = 	CIB.username 
	INNER JOIN CustStakeLevel_Agent_20170505_BACKUP CSB WITH (NOLOCK) ON  CSB.custid = CIB.custid 
				AND CS.SportType = CSB.SportType 
				AND CS.BetType = CSB.BetType	
				
WHERE CI.username IN ('TVA96QG82','TY81H104')
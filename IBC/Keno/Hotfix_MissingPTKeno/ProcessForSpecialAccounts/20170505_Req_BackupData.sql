/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/
USE CustDB
GO

SELECT custid, currency
	  , maxpermatch, maxpermatch2, maxpermatch3, maxpermatch5, maxpermatch8, maxpermatch10, maxpermatch11,MaxPerMatch44, maxpermatch201, maxpermatch151
	  , maxpermatch151_OT, MaxPerMatch151_AU, MaxPerMatch152_UK, MaxPerMatch152_AU, MaxPerMatch153_AU, maxpermatch99
	  , roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, autosuspend2, reject, credit, closed, username
	  , MatchLimit, VirtualMultiplier, DisableHorseRacing, DisableOpenTote, Disable151_AU, Disable152_UK, Disable152_AU, Disable153_AU
	  , DisableFinancial, DisableOutright, DisableCasino, DisableNumber,DisableBingo, maxpermatch161, MaxPerMatch99MP, MaxPerBall161
	  , MaxPerMatch180, MaxPerMatch181, MaxPerMatch186, danger, danger2, danger3, Abnormal, DisableP2P, DisableFunP2P, IsAutoResetP2P
	  , DisableLiveCasino, DisableVirtualSports, HideVirtualSports, DoubleCommLosing, isAutoResetLiveCasino, MaxWinLiveCasino
	  , DisableCasinoBonus, maxpermatch154, DisableHRFixedOdds, maxpermatch182, maxpermatch184, HideKeno, maxpermatch183, maxpermatch185
	  , DisableEsports, DisableGoldDeluxe, HideGoldDeluxe, DisableSuperLive,DisableColossusBet,HideColossusBet
	  , MaxPerMatch1MP
INTO custinfo_20170505_BACKUP	  
FROM custinfo  WITH(NOLOCK)	
WHERE custid IN (21442091,20696396,21442964,21443084,21443093)

SELECT username, firstname, lastname, phone, mobilephone, fax, email, address,
			    city, state, country, postal, userpwd, roleid, srecommend, mrecommend, recommend, 
			    currency, pwdexpiry, creator, Site, creatdate, ugroup
INTO Customer_20170505_BACKUP			    
FROM Customer WITH (NOLOCK)
WHERE custid IN (21442091,20696396,21442964,21443084,21443093)

SELECT custId, MaxCredit, IsInternal, TransferOption, Site
INTO CustAgent_20170505_BACKUP			    
FROM CustAgent WITH (NOLOCK)
WHERE custid IN (21442091,20696396)

SELECT CustID, OldUserPwd, LastChangedPwdDate, isFirstLogin, SecurityCodeCount,
	        SecurityCode, isForcedChangeSecurityCode, LastChangedSecurityCodeDate
INTO CustLoginInfo_20170505_BACKUP			    	        
FROM CustLoginInfo WITH (NOLOCK) 
WHERE custid IN (21442091,20696396,21442964,21443084,21443093)


SELECT [CustID],bitmapIsDisabled,bitmapIsHidden,bitmapHasSynced
INTO CustProductStatus_20170505_BACKUP
FROM [CustProductStatus] WITH (NOLOCK)
WHERE custid IN (21442091,20696396,21442964,21443084,21443093)          

SELECT [CustID],seqNo,bitmapVirtual
INTO CustVirtualSetting_20170505_BACKUP
FROM [CustVirtualSetting] WITH (NOLOCK)
WHERE custid IN (21442091,20696396,21442964,21443084,21443093)


SELECT [CustID],SportType,BetType,MaxWinLimit,IsAutoReset,MaxLossLimit
INTO CustWinLimit_20170505_BACKUP
FROM [CustWinLimit] WITH (NOLOCK)
WHERE custid IN (21442091,20696396,21442964,21443084,21443093)	

---------------- AGENT -----------------------------
SELECT [CustID]
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
				   ,[MaxPT]
INTO CustPTSetting3rd_Agent_20170505_BACKUP				   
FROM [CustPTSetting3rd_Agent] WITH(NOLOCK)	
WHERE custid IN (21442091,21442964)

SELECT  [CustID]
					   ,[SportType]
					   ,[BetType]
					   ,[MinBet]
					   ,[MaxBet]
					   ,[MaxPerMatch]
INTO CustBetSetting3rd_Agent_20170505_BACKUP
FROM  [CustBetSetting3rd_Agent] WITH (NOLOCK)
WHERE custid IN (21442091,21442964)
SELECT  [CustID]
					   ,[SportType]
					   ,[BetType]
					   ,[Discount]
INTO CustDiscount3rd_Agent_20170505_BACKUP					   
FROM  [CustDiscount3rd_Agent] WITH(NOLOCK)	
WHERE custid IN (21442091,21442964)

SELECT  [CustID]
					   ,[SportType]
					   ,[BetType]
					   ,[MaxWinLimit]
					   ,[MaxLossLimit]
					   ,[IsAutoReset]
INTO CustWinLossLimit_Agent_20170505_BACKUP					   
FROM [CustWinLossLimit_Agent] WITH(NOLOCK)	
WHERE custid IN (21442091,21442964)

SELECT CustID , SportType    , BetType    , StakeLevelList
INTO CustStakeLevel_Agent_20170505_BACKUP
FROM CustStakeLevel_Agent WITH(NOLOCK)	
WHERE custid IN (21442091,21442964)


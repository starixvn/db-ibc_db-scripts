/*
	Created: Vicky
	Task: insert LogAction for BBD
	DB: DBLOG/bodb_CustomerLog
	Date: 20190115
	
*/
USE [bodb_CustomerLog]
GO

IF EXISTS(SELECT 1 FROM LogAction WHERE ActionID IN (81006,81007,81009,81010,81011,81012))
	RETURN
--DELETE LogAction WHERE ActionID IN (81006,81007,81009,81010,81011,81012)

INSERT INTO LogAction(ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal,ActionNameVI)
VALUES 
 (81006,NULL,'NAP_Set_AutoPayout_SettingLeagueUpd','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League',NULL,'Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League',NULL,0,'Bet Builder - Turn On/Off Auto Setting on League')
,(81007,NULL,'NAP_Set_AutoPayout_SettingLeagueUpd','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match',NULL,'Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match',NULL,0,'Bet Builder - Turn On/Off Auto Setting on Match')
,(81009,NULL,'NAP_Admin_Settlement_BetBuilder','Calculate Single Match Parlay','Calculate Single Match Parlay',N'结算Single Match Parlay','Calculate Single Match Parlay','Calculate Single Match Parlay','Calculate Single Match Parlay','Calculate Single Match Parlay',NULL,0,'Calculate Single Match Parlay')
,(81010,NULL,'NAP_Admin_Settlement_BetBuilder','Undo Single Match Parlay Settlement','Undo Single Match Parlay Settlement',N'撤消Single Match Parlay','Undo Single Match Parlay Settlement','Undo Single Match Parlay Settlement','Undo Single Match Parlay Settlement','Undo Single Match Parlay Settlement',NULL,0,'Undo Single Match Parlay Settlement')
,(81011,NULL,'NAP_Admin_Settlement_BetBuilder','Log MarketIDs Single Match Parlay','Log MarketIDs Single Match Parlay',NULL,'Log MarketIDs Single Match Parlay','Log MarketIDs Single Match Parlay','Log MarketIDs Single Match Parlay','Log MarketIDs Single Match Parlay',NULL,0,'Log MarketIDs Single Match Parlay')
,(81012,NULL,'NAP_Admin_Settlement_BetBuilder','Auto Calculate Single Match Parlay','Auto Calculate Single Match Parlay',NULL,'Auto Calculate Single Match Parlay','Auto Calculate Single Match Parlay','Auto Calculate Single Match Parlay','Auto Calculate Single Match Parlay',NULL,0,'Auto Calculate Single Match Parlay')


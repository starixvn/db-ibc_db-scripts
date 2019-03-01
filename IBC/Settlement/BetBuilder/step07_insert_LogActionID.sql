/*
	Created: Vicky
	Task: insert LogAction for BBD
	DB: DBLOG/bodb_CustomerLog
	Date: 20190115
	
*/
USE [bodb_CustomerLog]
GO

--IF EXISTS(SELECT 1 FROM LogAction WITH(NOLOCK) WHERE ActionID IN (81006,81007,81009,81010,81011,81012))
--	RETURN
DELETE LogAction WITH (ROWLOCK, UPDLOCK) WHERE ActionID IN (81006,81007,81009,81010,81011,81012)


INSERT INTO LogAction(ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal,ActionNameVI)
VALUES 
 (81006,NULL,'NAP_Set_AutoPayout_SettingLeagueUpd','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League','Bet Builder - Turn On/Off Auto Setting on League',NULL,0,'Bet Builder - Turn On/Off Auto Setting on League')
,(81007,NULL,'NAP_Set_AutoPayout_SettingLeagueUpd','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match','Bet Builder - Turn On/Off Auto Setting on Match',NULL,0,'Bet Builder - Turn On/Off Auto Setting on Match')
,(81009,NULL,'NAP_Admin_Settlement_BetBuilder','Bet Builder - Calculate','Bet Builder - Calculate','Bet Builder - Calculate','Bet Builder - Calculate','Bet Builder - Calculate','Bet Builder - Calculate','Bet Builder - Calculate',NULL,0,'Bet Builder - Calculate')
,(81010,NULL,'NAP_Admin_Settlement_BetBuilder','Bet Builder - Uncalculate','Bet Builder - Uncalculate','Bet Builder - Uncalculate','Bet Builder - Uncalculate','Bet Builder - Uncalculate','Bet Builder - Uncalculate','Bet Builder - Uncalculate',NULL,0,'Bet Builder - Uncalculate')
,(81011,NULL,'NAP_Admin_Settlement_BetBuilder','Bet Builder - Log MarketIds','Bet Builder - Log MarketIds','Bet Builder - Log MarketIds','Bet Builder - Log MarketIds','Bet Builder - Log MarketIds','Bet Builder - Log MarketIds','Bet Builder - Log MarketIds',NULL,0,'Bet Builder - Log MarketIds')
,(81012,NULL,'NAP_Admin_Settlement_BetBuilder','Bet Builder - Auto Settle','Bet Builder - Auto Settle','Bet Builder - Auto Settle','Bet Builder - Auto Settle','Bet Builder - Auto Settle','Bet Builder - Auto Settle','Bet Builder - Auto Settle',NULL,0,'Bet Builder - Auto Settle')


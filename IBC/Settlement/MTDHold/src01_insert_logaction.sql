/*
	Created: Vicky
	Task: insert LogAction for MTD Hold
	DB: DBLOG/bodb_CustomerLog
	Date: 20181127
	
*/
USE [bodb_CustomerLog]
GO


INSERT INTO LogAction(ActionID,ActionTypeID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameIT,ActionNameTH,ActionNameKO,XsltContent,IsInternal,ActionNameVI)
VALUES 
 (81005,NULL,'NAP_Set_SettlementStatusUpd','Turn On/Off MTD hold',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL)


/*
	Created: 20191218@Helen
	Task: Recover ticket 7 days - insert log action 
*/
USE bodb_CustomerLog
GO

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES 
(90200,'TicketVoiding_RecoverHistorical_Single_Update'
		,'Recover Single ticket within 7 days'
		,'Recover Single ticket within 7 days'
		,'Recover Single ticket within 7 days'
		,'Recover Single ticket within 7 days'
		,'Recover Single ticket within 7 days'
		,'Recover Single ticket within 7 days'
		,0
		,'Recover Single ticket within 7 days'
		)
,(90201,'TicketVoiding_RecoverHistorical_MainParlay_Update'
		,'Recover Main Parlay ticket within 7 days'
		,'Recover Main Parlay ticket within 7 days'
		,'Recover Main Parlay ticket within 7 days'
		,'Recover Main Parlay ticket within 7 days'
		,'Recover Main Parlay ticket within 7 days'
		,'Recover Main Parlay ticket within 7 days'
		,0
		,'Recover Main Parlay ticket within 7 days'
		)
,(90202,'TicketVoiding_RecoverHistorical_SubParlay_Update'
		,'Recover Sub Parlay tickets within 7 days'
		,'Recover Sub Parlay tickets within 7 days'
		,'Recover Sub Parlay tickets within 7 days'
		,'Recover Sub Parlay tickets within 7 days'
		,'Recover Sub Parlay tickets within 7 days'
		,'Recover Sub Parlay tickets within 7 days'
		,0
		,'Recover Sub Parlay tickets within 7 days'
		)



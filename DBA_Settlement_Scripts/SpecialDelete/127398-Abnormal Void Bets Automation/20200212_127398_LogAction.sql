/*
	Created: 20200212@Helen
	Task: Abnormal Void Bets Automation [Redmine: #128359]
	DB: dblog/bodb_CustomerLog
*/
USE bodb_CustomerLog
GO

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES 
(90503,'TicketVoiding_ReCalculate_Single_Update'
		,'Resettle Marked Ticket'
		,'Resettle Marked Ticket'
		,'Resettle Marked Ticket'
		,'Resettle Marked Ticket'
		,'Resettle Marked Ticket'
		,'Resettle Marked Ticket'
		,0
		,'Resettle Marked Ticket'
		)
,(90504,'TicketVoiding_AutoVoid_Update'
		,'Void Bets Automation'
		,'Void Bets Automation'
		,'Void Bets Automation'
		,'Void Bets Automation'
		,'Void Bets Automation'
		,'Void Bets Automation'
		,0
		,'Void Bets Automation'
		)

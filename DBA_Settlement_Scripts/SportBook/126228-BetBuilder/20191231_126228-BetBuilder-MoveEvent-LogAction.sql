/*
	Created: 20191230@Helen
	Task: Move BetBuilder Tickets to New Match - [Redmine:126228]
	DB: dblog/bodb_CustomerLog
*/
USE bodb_CustomerLog
GO
INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES 
(81015,'NAP_Admin_Settlement_BetBuilder_MoveEvent'
		,'BetBuilder - Move Event'
		,'BetBuilder - Move Event'
		,'BetBuilder - Move Event'
		,'BetBuilder - Move Event'
		,'BetBuilder - Move Event'
		,'BetBuilder - Move Event'
		,0
		,'BetBuilder - Move Event'
		)

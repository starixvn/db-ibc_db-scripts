/*
	Created by: Helen
	Date 20200308
	Task:  Auto Void Settled Tickets of Formula Bet Feature [Redmine:#129971]
	DB: dblog/bodb_CustomerLog
*/
USE bodb_CustomerLog
GO

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES 
(90506,'TicketVoiding_AutoVoidFormulaBets_Single_Update'
		,'Auto Void Formula Bets Single Ticket Update'
		,'Auto Void Formula Bets Single Ticket Update'
		,'Auto Void Formula Bets Single Ticket Update'
		,'Auto Void Formula Bets Single Ticket Update'
		,'Auto Void Formula Bets Single Ticket Update'
		,'Auto Void Formula Bets Single Ticket Update'
		,0
		,'Auto Void Formula Bets Single Ticket Update'
		)

,(90507,'TicketVoiding_AutoVoidFormularBets_Single'
		,'Auto Void Formula Bets Single Ticket'
		,'Auto Void Formula Bets Single Ticket'
		,'Auto Void Formula Bets Single Ticket'
		,'Auto Void Formula Bets Single Ticket'
		,'Auto Void Formula Bets Single Ticket'
		,'Auto Void Formula Bets Single Ticket'
		,0
		,'Auto Void Formula Bets Single Ticket'
		)

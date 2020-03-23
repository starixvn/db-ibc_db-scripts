/*
	Created: 20200323@Max
	Task:[TVS] Highlight Abnormal Voiding Reques [Redmine: #129639]
	DB: dblog/bodb_CustomerLog
*/
USE bodb_CustomerLog
GO

INSERT INTO dbo.LogAction (ActionID,SPName,ActionNameEN,ActionNameCH,ActionNameCS,ActionNameJP,ActionNameTH,ActionNameKO,IsInternal,ActionNameVI)
VALUES 
(90508,'Nap_SpecialDelete_UnMarkedTickets_Update'
		,'Auto Mark Ticket When Add Request'
		,'Auto Mark Ticket When Add Request'
		,'Auto Mark Ticket When Add Request'
		,'Auto Mark Ticket When Add Request'
		,'Auto Mark Ticket When Add Request'
		,'Auto Mark Ticket When Add Request'
		,0
		,'Auto Mark Ticket When Add Request'
		)
,(90509,'Nap_SpecialDelete_UnMarkedTickets_Update'
		,'Auto Mark Ticket by Auto Void Winning Bet'
		,'Auto Mark Ticket by Auto Void Winning Bet'
		,'Auto Mark Ticket by Auto Void Winning Bet'
		,'Auto Mark Ticket by Auto Void Winning Bet'
		,'Auto Mark Ticket by Auto Void Winning Bet'
		,'Auto Mark Ticket by Auto Void Winning Bet'
		,0
		,'Auto Mark Ticket by Auto Void Winning Bet'
		)
,(90510,'Nap_SpecialDelete_MarkedTickets_Update'
		,'Unmark Auto by System'
		,'Unmark Auto by System'
		,'Unmark Auto by System'
		,'Unmark Auto by System'
		,'Unmark Auto by System'
		,'Unmark Auto by System'
		,0
		,'Unmark Auto by System'
		)


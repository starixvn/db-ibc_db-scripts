USE bodb_CustomerLog
GO
/*
	Created: 20190606@Kathy
	Task : Insert new logaction 90502 & update existing logaction 90500, 90501
	DB: DBLOG.bodb_CustomerLog [Redmine:#114596]
*/

-- Update existing logaction & inser new 1 logaction 
--SELECT *
--FROM logaction
--where actionid in (90500, 90501, 90502)

DECLARE @ActionName NVARCHAR(256)
	SET @ActionName = 'Mark Ticket - Insert in table MarkedTransaction'

UPDATE dbo.LogAction
	SET SPName = 'Nap_SpecialDelete_UnMarkedTickets_Update'
		,ActionNameEn = @ActionName
		,ActionNameCH = @ActionName
		,ActionNameCS = @ActionName
		,ActionNameJp = @ActionName
		,ActionNameIT = @ActionName
		,ActionNameTH = @ActionName
		,ActionNameVi = @ActionName

WHERE	ActionId = 90500


SET @ActionName = 'UnMarked Ticket - Delete ticket in table MarkedTransaction'
UPDATE dbo.LogAction
	SET SPName = 'Nap_SpecialDelete_MarkedTickets_Update'
		,ActionNameEn = @ActionName
		,ActionNameCH = @ActionName
		,ActionNameCS = @ActionName
		,ActionNameJp = @ActionName
		,ActionNameIT = @ActionName
		,ActionNameTH = @ActionName
		,ActionNameVi = @ActionName

WHERE	ActionId = 90501

SET @ActionName = 'UnMark Ticket For Match - Delete ticket in table MarkedTransaction'

INSERT INTO dbo.LogAction (ActionId, SPName, ActionNameEn) VALUES (90502, 'Nap_SpecialDelete_AllMarkedTicketsSummary_Update', 'UnMark Ticket For Match - Delete ticket in table MarkedTransaction')

UPDATE dbo.LogAction
	SET ActionNameEn = @ActionName
		,ActionNameCH = @ActionName
		,ActionNameCS = @ActionName
		,ActionNameJp = @ActionName
		,ActionNameIT = @ActionName
		,ActionNameTH = @ActionName
		,ActionNameVi = @ActionName

WHERE	ActionId = 90502


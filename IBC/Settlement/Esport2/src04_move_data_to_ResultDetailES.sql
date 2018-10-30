/*
	Created: Vicky
	Task: moving data of esport to new table ResultDetailES
	DB: DBPRO/bodb02
	Date: 20180912
*/
USE [bodb02]
GO

DELETE ResultDetailES WHERE ResourceID = '00'

INSERT INTO ResultDetailES(Matchid, ResourceID, HomeValue, AwayValue, ResultStatusID, SettlementStatusID, CreateBy, CreateDate, LastModifyBy, LastModifyDate)
SELECT m.Matchid
	,'00'
	,m.finalhomescore
	,m.finalawayscore
	, CASE WHEN m.eventstatus = 'completed' THEN 5 ELSE 0 END AS ResultStatusID
	, CASE WHEN m.eventstatus = 'completed' AND m.betstatus LIKE 'Refund%' THEN 1
		   WHEN m.eventstatus = 'completed' THEN 4
		   ELSE 0 END
		AS SettlementStatusID
	,m.creator
	,GETDATE()
	,m.creator
	,GETDATE()
FROM Match m
WHERE m.Sporttype = 43 
	AND (m.finalhomescore IS NOT NULL OR m.finalawayscore IS NOT NULL)
	
	
	

	
	
	
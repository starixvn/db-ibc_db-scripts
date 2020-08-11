/*<info serverAlias="DBLIC-bodb_licenseeReportArchive"></info>*/
/*
	Create: 20200807@Sol
	DB : DBLIC-bodb_licenseeReportArchive
	Task: update gamecode of rptDep_AuditTickets table from 196 to 186 [redmine: #139154]
*/

USE bodb_licenseeReportArchive;

GO 

DECLARE @TransTable AS TABLE (TransactionId BIGINT)

INSERT INTO @TransTable(TransactionId)
SELECT r.TransactionId 
FROM rptDep_AuditTickets r WITH(NOLOCK)
WHERE
	GameCode = 196 
	AND GameName = 'Virtual Tennis'
	AND Brand = 'nova88'

---- nova88 - 218 rows affected
UPDATE rptDep_AuditTickets WITH(ROWLOCK)
	SET GameCode = 186
WHERE 
	TransactionId IN (SELECT TransactionId FROM @TransTable)

GO
/*<info serverAlias="DBLIC-bodb_licenseeReportArchive"></info>*/
/*
	Create: 20200804@Sol
	DB : DBLIC-bodb_licenseeReportArchive
	Task: update winlostdate of rptDep_AuditTickets table [redmine: #138899]
*/

USE bodb_licenseeReportArchive;

GO 

---- opal88 - 23 rows affected
UPDATE rptDep_AuditTickets WITH(ROWLOCK)
	SET WinLostDate = '20200803'
WHERE 
	Brand = 'opal88'
	AND WinLostDate BETWEEN '20200601' AND '20200731'

GO

---- ivorysport - 203 rows affected
UPDATE rptDep_AuditTickets WITH(ROWLOCK)
	SET WinLostDate = '20200803'
WHERE 
	Brand = 'ivorysport'
	AND WinLostDate BETWEEN '20200601' AND '20200731'

GO

---- nova88 - 145 rows affected
UPDATE rptDep_AuditTickets WITH(ROWLOCK)
	SET WinLostDate = '20200803'
WHERE 
	Brand = 'nova88'
	AND WinLostDate BETWEEN '20200601' AND '20200731'

GO
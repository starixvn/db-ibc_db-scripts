/*<info serverAlias="DBLIC-bodb_licenseeReportArchive"></info>*/
/*
	Create: 20200814@Sol
	DB : DBLIC-bodb_licenseeReportArchive
	Task: update winlostdate of rptDep_AuditTickets table [redmine: #138899]
*/

USE bodb_licenseeReportArchive;

GO 

---- ivorysport - 11 rows affected
UPDATE rptDep_AuditTickets WITH(ROWLOCK)
	SET WinLostDate = '20200803'
WHERE 
	Brand = 'ivorysport'
	AND WinLostDate BETWEEN '20200501' AND '20200531'

GO

---- nova88 - 1 rows affected
UPDATE rptDep_AuditTickets WITH(ROWLOCK)
	SET WinLostDate = '20200803'
WHERE 
	Brand = 'nova88'
	AND WinLostDate BETWEEN '20200501' AND '20200531'

GO
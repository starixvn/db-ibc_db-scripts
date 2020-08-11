/*<info serverAlias="DBPLO-bodb_Ploutos"></info>*/
/*
	Create: 20200807@Sol
	DB : DBPLO-bodb_Ploutos
	Task: update gamecode of BetTicket table from 196 to 186 [redmine: #139154]
*/

USE bodb_Ploutos;

GO 


DECLARE @TransTable AS TABLE (TransactionId BIGINT)

INSERT INTO @TransTable(TransactionId)
SELECT r.TransactionId 
FROM bodb_LicenseeReportArchive.dbo.rptDep_AuditTickets r WITH(NOLOCK)
WHERE
	r.Brand = 'Nova88'
	AND GameCode = 196
	AND GameName = 'Virtual Tennis'

---- nova88 - 218 rows affected
UPDATE BetTicket WITH(ROWLOCK)
	SET GameCode = '0186'
WHERE
	BrandCode = 'Nova88'
	AND GameCode = '0196'
	AND TransactionId IN (SELECT TransactionId FROM @TransTable)

GO
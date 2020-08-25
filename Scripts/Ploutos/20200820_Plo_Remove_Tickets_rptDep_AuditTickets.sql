/*<info serverAlias="DBLIC-bodb_licenseeReportArchive"></info>*/
/*
	Create: 20200820@Sol
	DB : DBLIC-bodb_licenseeReportArchive
	Task: remove tickets in rptDep_AuditTickets table [redmine: #139964]
*/

USE bodb_licenseeReportArchive;

GO 

---- opal88
---- remove tickets in BetTicket table
DELETE FROM rptDep_AuditTickets WHERE Brand = 'Opal88' AND
							TransactionId IN (
												109533389853
												,109533433608
												,109533463709
												,109277806782
												,109560381545
											)

GO
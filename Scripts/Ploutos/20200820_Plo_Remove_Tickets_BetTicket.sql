/*<info serverAlias="DBPLO-bodb_Ploutos"></info>*/
/*
	Create: 20200820@Sol
	DB : DBPLO-bodb_Ploutos
	Task: remove tickets in closing business time [redmine: #139964]
*/

USE bodb_Ploutos;

GO

---- opal88
---- remove tickets in BetTicket table
DELETE FROM BetTicket WHERE BrandCode = 'Opal88' AND
							TransactionId IN (
												109533389853
												,109533433608
												,109533463709
												,109277806782
												,109560381545
											)

GO
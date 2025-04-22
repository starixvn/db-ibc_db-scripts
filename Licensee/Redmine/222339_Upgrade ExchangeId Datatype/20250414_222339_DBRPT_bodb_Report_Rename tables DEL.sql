/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBRPT-bodb_Report
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

USE bodb_Report
GO

SP_RENAME 'rptCustomerTurnover','DEL_rptCustomerTurnover'
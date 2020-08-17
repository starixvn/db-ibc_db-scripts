/*<info serverAlias="DBCRM-bodb_CRM"></info>*/

USE bodb_CRM
GO

/*
	Created: 20200817@Malcolm
	DB: DBCRM.bodb_CRM
	Task:  update date
	Revisions:
		- 20200817@Malcolm:  update data [RedmineID: #137144]
*/

UPDATE dbo.crmLogAction WITH(ROWLOCK)
SET ActionNameEN = 'Update PIC status', ActionTypeID = 1
WHERE ActionID = 903



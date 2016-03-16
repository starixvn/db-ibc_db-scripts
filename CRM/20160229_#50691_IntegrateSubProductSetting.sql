/*
	Created: 20160229@Billy
	Task: Update DB Structure to Support Sub-Product Implementation [Redmine: #53110]
	DB: DBCRM\bodb_CRM
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCRM\bodb_CRM	--
----------------------------------------------------------

ALTER TABLE	dbo.crmFeedback
			ADD	SubProductID	INT		NULL


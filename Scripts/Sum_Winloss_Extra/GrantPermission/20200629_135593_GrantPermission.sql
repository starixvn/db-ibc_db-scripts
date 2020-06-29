/*<info serverAlias="DBSUM-bodb_Summary" ></info>*/

/*
	Created: 20200619@Malcolm
	Task: grant permission [Redmine: #135593]
	DB: DBSUM.bodb_Summary


*/
USE bodb_Summary
GO

GRANT SELECT ON dbo.Sum_Winloss_Extra TO bodbExtAccNet;  
GO  
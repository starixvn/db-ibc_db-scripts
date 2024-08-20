/*<info serverAlias="DBACC-bodb_Licensee,DBLIC-bodb_Licensee"></info>*/
/*	
	Created: 20240820@Sally
	Task: Remove linked server to DBCUST [RedmineID: #206891]
	DB: DBACC-bodb_Licensee,DBLIC-bodb_Licensee
	- Grant permission for 'wsv_nap' Account on bodb_Licensee
*/
USE bodb_Licensee
GO

GRANT SELECT ON [dbo].[LA_CombinedGroup] TO [wsv_nap]
GRANT SELECT ON [dbo].[LA_CombinedGroupAssignment] TO [wsv_nap]
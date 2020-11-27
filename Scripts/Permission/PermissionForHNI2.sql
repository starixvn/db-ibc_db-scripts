 /*<info serverAlias="DBLIC-bodb_licensee" ></info>*/
USE bodb_licensee
GO
/*
    Created: 20201127@Sophia
	Task: Grant permission for HNI [redmine: #135865]
	DB: DBLIC-bodb_licensee

*/

GRANT SELECT ON [LA_GroupMinFeeAssignment] TO bodbAdminNet
GO 
 
/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
USE bodb_3rdProduct
GO

/*
	Created: 20230925@Evan
	Task: Add new column for Sum_winloss_Exchange table [RedmineID: #193954]
	DB: DB053/DB052 -bodb_3rdProduct
*/

ALTER TABLE Sum_winloss_Exchange ADD IsResettled BIT
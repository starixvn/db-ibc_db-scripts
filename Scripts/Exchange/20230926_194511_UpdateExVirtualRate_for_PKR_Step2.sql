/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20230926@Evan
	DB: DBLIC-bodb_3rdProduct
	Task: Update ExVirtualRate for PKR [Redmine: #194511]
*/

USE bodb_3rdProduct
GO

UPDATE Sum_winloss_Exchange WITH(ROWLOCK)
SET ExVirtualRate = 1
WHERE Currency = 121

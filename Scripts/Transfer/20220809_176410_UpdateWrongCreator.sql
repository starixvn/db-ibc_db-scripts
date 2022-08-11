/*<info serverAlias="DBTXN-bodb02" isFunction="0" isNested=""></info>*/
/*
	Created: 20220809@Danny
	DB: DBTXN.bodb02
	Task: update creator of transfer ticket - [Redmind: #176410]

*/

USE bodb02

GO 

UPDATE t
SET t.Creator = 10278938 -- starixIT	
FROM dbo.transfer t WITH(ROWLOCK, UPDLOCK)
WHERE t.bettype = 21003 
AND t.WinlostDate = '2022-08-08'
AND t.Creator = 49687449 -- zt828SuperEURO	




/*<info serverAlias="DBTXN-bodb02" isFunction="0" isNested=""></info>*/
/*
	Created: 20210602@Sol
	DB: DBTXN.bodb02
	Task: add more forex account - [Redmind: #156283]

*/

USE bodb02

GO 

UPDATE s
	SET s.VValue = 'MYS-Forex G/(L),PHL-Forex G/(L),VNM-Forex G/(L),KHM-Forex G/(L)'
FROM dbo.SystemSettings s
WHERE s.VName = 'ForexAccount'

GO
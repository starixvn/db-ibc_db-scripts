/*<info serverAlias="DBPRO-bodb02" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/
/*	
	Create : 20200514@Malcolm
	Task:  Update language[redmine: #132760]
	DB: DBPRO/bodb02
*/
USE bodb02
GO 

UPDATE t
SET t.Resource_ch = N'娛樂城',
	t.Resource_cs = N'娱乐城',
	t.Resource_th = N'คาสิโน'
FROM RefResource t
WHERE RefId = 'Product' AND ResourceId = 53

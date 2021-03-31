/*<info serverAlias="DBTXN-bodb02" isFunction="0" isNested=""></info>*/

/*
	Created: 20210323@Danny
	DB: DBTXN.bodb02
	Task: Insert isCaptureBalance flag into SystemSettings table

*/


USE bodb02

SET NOCOUNT ON

--INSERT INTO dbo.SystemSettings (VName,VValue) VALUES ('isCaptureBalance', 1)
UPDATE 
SET t.VValue = 0
FROM dbo.SystemSettings t WITH(ROWLOCK)
WHERE t.VName = 'isCaptureBalance'
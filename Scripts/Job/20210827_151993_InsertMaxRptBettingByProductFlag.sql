/*<info serverAlias="DBLIC-bodb02" isFunction="0" isNested=""></info>*/

/*
	Created: 20210323@Danny
	DB: DBLIC.bodb02
	Task: Insert MaxRptBettingByProduct flag into SystemSettings table

*/


USE bodb02

SET NOCOUNT ON

IF NOT EXISTS (SELECT 1 FROM dbo.SystemSettings WITH(NOLOCK) WHERE VName = 'MaxRptBettingByProduct')
	INSERT INTO dbo.SystemSettings (VName,VValue) VALUES ('MaxRptBettingByProduct', NULL)

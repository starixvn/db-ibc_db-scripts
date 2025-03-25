/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250324@Tacy	
	Task: In-House - Disable DR [RedmineID: #219424]
	DB: DBCUST-CustDB

*/


/**********************************ExchangeDailyOanda*****************************************/

IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'ExchangeDailyOanda')
BEGIN
	UPDATE RepInfo
	SET active = 0
	WHERE [name] =  'ExchangeDailyOanda'
END
GO
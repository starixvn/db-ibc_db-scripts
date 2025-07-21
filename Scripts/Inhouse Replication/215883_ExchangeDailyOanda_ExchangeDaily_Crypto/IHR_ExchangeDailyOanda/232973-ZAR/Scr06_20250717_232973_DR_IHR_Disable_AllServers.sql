/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250717@Kelvin
	DB: DBCUST-CustDB
	Task : LAP - Support based ZAR (RedmineID: #232973)

*/


/**********************************ExchangeDailyOanda*****************************************/

IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'ExchangeDailyOanda')
BEGIN
	UPDATE RepInfo
	SET active = 0
	WHERE [name] =  'ExchangeDailyOanda'
END
GO
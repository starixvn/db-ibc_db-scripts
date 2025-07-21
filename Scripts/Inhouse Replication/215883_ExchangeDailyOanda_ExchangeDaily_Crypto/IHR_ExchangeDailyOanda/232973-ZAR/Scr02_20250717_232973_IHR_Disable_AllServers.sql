/*<info serverAlias="DBCustRepl-ReplCustDB,IRS_DBSIC-CustDB,IRS_DBSID-CustDB,IRS_DBCTG-CustDB,IRS_DBAGE-bodb02,IRS_DBBOF-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,IRS_DBWH-bodb02"></info>*/
/*
	Created: 20250717@Kelvin
	DB: DBCustRepl-ReplCustDB,IRS_DBSIC-CustDB,IRS_DBSID-CustDB,IRS_DBCTG-CustDB,IRS_DBAGE-bodb02,IRS_DBBOF-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,IRS_DBWH-bodb02
	Task : LAP - Support based ZAR (RedmineID: #232973)

*/

/*
USE CustDB
USE ReplCustDB
USE bodb02
*/

/**********************************ExchangeDailyOanda*****************************************/

IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'ExchangeDailyOanda')
BEGIN
	UPDATE RepInfo
	SET active = 0
	WHERE [name] =  'ExchangeDailyOanda'
END
GO
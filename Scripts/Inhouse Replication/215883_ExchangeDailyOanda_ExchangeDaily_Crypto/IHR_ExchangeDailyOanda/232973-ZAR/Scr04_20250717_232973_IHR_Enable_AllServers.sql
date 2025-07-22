/*<info serverAlias="DBCustRepl-ReplCustDB,IRS_DBSIC-CustDB,IRS_DBSID-CustDB,IRS_DBCTG-CustDB,IRS_DBAGE-bodb02,IRS_DBBOF-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,IRS_DBWH-bodb02" executers="" isFunction="0" isNested="0"></info>*/
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

/* Validate server and database */
----------------------------------------------------------------------------------------------------------------------------------------
DECLARE @IsCheckServer BIT = 0

IF (@@SERVERNAME IN ('IHRDISTC1') AND DB_NAME() IN ('ReplCustDB'))
	OR (@@SERVERNAME IN ('DBSITEC3\INST3','DBSITEC1','DBSITEC2\INST2','DBTRANS\INST2') AND DB_NAME() IN ('CustDB'))
	OR (@@SERVERNAME IN ('DB053','DB052','DB055','DB054','DB061','DB062','DBKULC1','DBDW','DBDW2') AND DB_NAME() IN ('bodb02'))
	BEGIN
		SET @IsCheckServer = 1
	END

IF @IsCheckServer = 0
BEGIN
	PRINT ('ServerName or Database is wrong')
	RETURN
END
----------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'ExchangeDailyOanda')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [name] =  'ExchangeDailyOanda'END
GO
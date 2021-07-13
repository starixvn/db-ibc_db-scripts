/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Create: 20210713@Sol
	DB : DBCUST-bodb_Licensee
	Task: update date range - [Redmine: #158387]
*/

USE bodb_Licensee;

GO

---- PHL-LSEE-SUNRISEB2B EUR - 27373109 
UPDATE dbo.LicenseeTransferCode WITH(ROWLOCK, UPDLOCK)
	SET ToDate = '20210531'
WHERE LicenseeName = 'Sunriseb2b' AND CustID = 27373109 AND FromDate = '20190801'

GO

---- PHL-LSEE-SUNRISEB2B CNY - 51045389
UPDATE dbo.LicenseeTransferCode WITH(ROWLOCK, UPDLOCK)
	SET FromDate = '20210601'
WHERE LicenseeName = 'Sunriseb2b' AND CustID = 51045389 AND FromDate = '20210701'

GO
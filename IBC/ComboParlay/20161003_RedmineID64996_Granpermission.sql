 /*
	Created: 20161003@Winnie
	Task: PRMS grant permission - [Redmine: #64996]
	DB: DBEXT/bodb02
*/

USE bodb02
GO
GRANT SELECT ON match14 TO [bodbRMSNet]
GRANT SELECT ON bettransm14 TO [bodbRMSNet]

 /*
	Created: 20160907@Winnie
	Task: PRMS grant permission - [Redmine: #64996]
	DB: DBARC/bodb_archive
*/


USE bodb_archive
GO
GRANT SELECT ON match_bk TO [bodbRMSNet]
GRANT SELECT ON bettransm TO [bodbRMSNet]

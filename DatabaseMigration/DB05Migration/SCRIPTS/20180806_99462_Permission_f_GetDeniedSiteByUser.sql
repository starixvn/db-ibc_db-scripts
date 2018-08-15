/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration, permission for web account to access NAP_UserControl - [Redmine:99462]
	SERVER: DBCUST/CUSTDB
			
	
*/
-------1: PERMISSION FOR f_GetDeniedSiteByUser function on NAP_UserControl ---------------------------------
USE CustDB
GO
GRANT SELECT ON Site TO [bodbExtAccNet]
GO
GRANT SELECT ON Site TO [bodbAdminNet]
GO
GRANT SELECT ON Site TO [bodbDownlineNet]
GO
GRANT SELECT ON Site TO [bodbDownlineNetView]
GO
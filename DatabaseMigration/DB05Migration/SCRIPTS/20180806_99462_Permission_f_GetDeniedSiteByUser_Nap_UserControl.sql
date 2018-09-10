/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration, permission for web account - [Redmine:99462]
	SERVER: DBCUST/NAP_UserControl
			
	
*/
-------1: PERMISSION FOR f_GetDeniedSiteByUser function on NAP_UserControl ---------------------------------
USE NAP_UserControl
GO
GRANT SELECT ON dbo.f_GetDeniedSiteByUser TO bodbAdminNet
GO
GRANT SELECT ON dbo.f_GetDeniedSiteByUser TO bodbDownlineNet
GO
GRANT SELECT ON dbo.f_GetDeniedSiteByUser TO bodbDownlineNetView
GO
GRANT SELECT ON dbo.f_GetDeniedSiteByUser TO bodbExtAccNet
GO
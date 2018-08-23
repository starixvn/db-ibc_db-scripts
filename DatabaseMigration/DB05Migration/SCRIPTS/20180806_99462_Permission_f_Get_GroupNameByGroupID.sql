/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DBCUST/NAP_UserControl
	
	Jenkins not support grant permission for function	
*/
USE NAP_UserControl
GO
GRANT EXECUTE ON dbo.f_Get_GroupNameByGroupID_UAT4 TO [bodbAdminNet] AS [dbo]
GO



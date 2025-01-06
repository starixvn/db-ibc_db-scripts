/*<info serverAlias="IRS_DBG-bodb02,IRS_DBCTG-custdb,IRS_DBSID-custdb,IRS_DBSIC-custdb,IRS_DBPRO-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250106@Lewis	
	Task: In-House
	DB: IRS_DBG-bodb02,IRS_DBCTG-custdb,IRS_DBSID-custdb,IRS_DBSIC-custdb,IRS_DBPRO-bodb02
	
	Revisions:
		- 20250106@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'exchange')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 0
		AND [name] =  'exchange'
END
ELSE
BEGIN  
	SELECT 'exchange not exists !!!'
END
GO
/***************************************************************************/




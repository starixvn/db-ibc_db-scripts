/*<info serverAlias="DBACC-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241223@Lewis	
	Task: In-House
	DB: DBACC-bodb02
	
	Revisions:
		- 20241223@Lewis: Created [RedmineID: #215667]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'LeagueSetting')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 0
		AND [name] =  'LeagueSetting'
END
ELSE
BEGIN  
	SELECT 'LeagueSetting not exists !!!'
END
GO
/***************************************************************************/




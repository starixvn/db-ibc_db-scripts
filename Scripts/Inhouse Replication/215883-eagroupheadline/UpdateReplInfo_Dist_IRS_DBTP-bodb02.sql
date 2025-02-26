/*<info serverAlias="IRS_DBTP-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250115@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02
	
	Revisions:
		- 20250115@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'EaGroupHeadline')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 0
		AND [name] =  'EaGroupHeadline'
END
ELSE
BEGIN  
	SELECT 'EaGroupHeadline not exists !!!'
END
GO
/***************************************************************************/




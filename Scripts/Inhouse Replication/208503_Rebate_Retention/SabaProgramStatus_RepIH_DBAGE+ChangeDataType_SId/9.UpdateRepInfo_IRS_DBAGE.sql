/*<info serverAlias="IRS_DBAGE-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241021@Lewis	
	Task: In-House
	DB: IRS_DBAGE-bodb02
	
	Revisions:
		- 20241021@Lewis: Created [RedmineID: #208503]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'SabaProgramStatus')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 0
		AND [name] =  'SabaProgramStatus'
END
ELSE
BEGIN  
	SELECT 'SabaProgramStatus not exists !!!'
END
GO
/***************************************************************************/




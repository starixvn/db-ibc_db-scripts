/*<info serverAlias="DBBOF-bodb02,DBAGE-bodb02,DBACC-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: DBBOF-bodb02,DBAGE-bodb02,DBACC-bodb02
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPTSetting')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'Acc_GroupExtraPTSetting'
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPTSetting not exists !!!'
END
GO
/***************************************************************************/


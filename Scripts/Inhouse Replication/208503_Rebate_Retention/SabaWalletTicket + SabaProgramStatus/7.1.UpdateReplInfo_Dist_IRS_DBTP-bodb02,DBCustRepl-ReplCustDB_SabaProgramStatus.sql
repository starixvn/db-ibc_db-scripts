/*<info serverAlias="IRS_DBTP-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20240923@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02
	
	Revisions:
		- 20240923@Lewis: Created [RedmineID: #]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'SabaProgramStatus')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'SabaProgramStatus'
END
ELSE
BEGIN  
	SELECT 'SabaProgramStatus not exists !!!'
END
GO
/***************************************************************************/




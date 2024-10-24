/*<info serverAlias="IRS_DBCTG-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241024@Bobby	
	Task: In-House
	DB: IRS_DBCTG-bodb02
	
	Revisions:
		- 20241024@Bobby: Created [RedmineID: #209191]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'TransferExtra')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 0
		AND [name] =  'TransferExtra'
END
ELSE
BEGIN  
	SELECT 'TransferExtra not exists !!!'
END
GO
/***************************************************************************/




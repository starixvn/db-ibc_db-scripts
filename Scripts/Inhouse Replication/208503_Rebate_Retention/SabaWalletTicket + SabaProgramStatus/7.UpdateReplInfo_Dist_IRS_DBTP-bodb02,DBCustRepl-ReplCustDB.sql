/*<info serverAlias="IRS_DBTP-bodb02,DBRepl-ReplDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20240917@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02,DBRepl-ReplDB
	
	Revisions:
		- 20240917@Lewis: Created [RedmineID: #]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'SabaWalletTicket')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 21
		AND [name] =  'SabaWalletTicket'
END
ELSE
BEGIN  
	SELECT 'SabaWalletTicket not exists !!!'
END
GO
/***************************************************************************/




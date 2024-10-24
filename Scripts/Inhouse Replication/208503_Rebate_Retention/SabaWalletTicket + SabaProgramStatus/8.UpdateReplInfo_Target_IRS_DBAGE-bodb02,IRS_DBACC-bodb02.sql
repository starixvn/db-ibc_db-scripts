/*<info serverAlias="IRS_DBAGE-bodb02,IRS_DBACC-bodb02,DBCTG-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20240917@Lewis	
	Task: In-House
	DB: IRS_DBAGE-bodb02,IRS_DBACC-bodb02,DBCTG-bodb02
	
	Revisions:
		- 20240917@Lewis: Created [RedmineID: #208503]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'SabaWalletTicket')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'SabaWalletTicket'
END
ELSE
BEGIN  
	SELECT 'SabaWalletTicket not exists !!!'
END
GO
/***************************************************************************/




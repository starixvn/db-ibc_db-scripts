/*<info serverAlias="IRS_DBAGE-bodb02,IRS_DBACC-bodb02,DBCTG-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20240917@Lewis	
	Task: In-House
	DB: IRS_DBAGE-bodb02,IRS_DBACC-bodb02,DBCTG-bodb02
	
	Revisions:
		- 20240917@Lewis: Created [RedmineID: #208503]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'SabaWalletTicket')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 13,'SabaWalletTicket',0,'repupdatetime',0,'TransId','Repl_GetSabaWalletTicket_Dist','Repl_PutSabaWalletTicket',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'SabaWalletTicket exists !!!'
END
GO
/***************************************************************************/




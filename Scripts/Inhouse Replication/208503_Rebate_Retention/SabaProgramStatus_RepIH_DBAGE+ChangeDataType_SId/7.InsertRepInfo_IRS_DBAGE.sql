/*<info serverAlias="IRS_DBAGE-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241021@Lewis	
	Task: In-House
	DB: IRS_DBAGE-bodb02
	
	Revisions:
		- 20241021@Lewis: Created [RedmineID: #208503]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'SabaProgramStatus')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'SabaProgramStatus',0,'repupdatetime',0,'SId|SiteDBGroupId','Repl_GetSabaProgramStatus_Dist','Repl_PutSabaProgramStatus',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'SabaProgramStatus exists !!!'
END
GO
/***************************************************************************/




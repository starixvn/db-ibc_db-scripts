/*<info serverAlias="IRS_DBTP-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250115@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02
	
	Revisions:
		- 20250115@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'EaGroupHeadline')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'EaGroupHeadline',0,'repupdatetime',0,'GroupHeadlineId|GroupId|GroupName|SiteId|ExchangeId','Repl_GetEaGroupHeadline','Repl_PutEaGroupHeadline_Dist',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'EaGroupHeadline exists !!!'
END
GO
/***************************************************************************/




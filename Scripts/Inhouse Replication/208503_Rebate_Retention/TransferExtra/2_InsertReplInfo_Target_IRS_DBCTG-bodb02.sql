/*<info serverAlias="IRS_DBCTG-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241024@Bobby	
	Task: In-House
	DB: IRS_DBCTG-bodb02
	
	Revisions:
		- 20241024@Bobby: Created [RedmineID: #209191]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'TransferExtra')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'TransferExtra',0,'repupdatetime',0,'TransId','Repl_GetTransferExtra','Repl_PutTransferExtra',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'TransferExtra exists !!!'
END
GO
/***************************************************************************/




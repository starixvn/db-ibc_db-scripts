/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPT2Setting')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 13,'Acc_GroupExtraPT2Setting',0,'repupdatetime',0,'ID','Repl_GetAcc_GroupExtraPT2Setting','Repl_PutAcc_GroupExtraPT2Setting_Dist',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPT2Setting exists !!!'
END
GO
/***************************************************************************/




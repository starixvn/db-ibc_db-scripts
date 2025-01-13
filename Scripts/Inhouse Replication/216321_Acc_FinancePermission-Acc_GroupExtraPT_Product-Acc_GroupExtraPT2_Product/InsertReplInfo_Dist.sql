/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_FinancePermission')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 13,'Acc_FinancePermission',0,'repupdatetime',0,'ID','Repl_GetAcc_FinancePermission','Repl_PutAcc_FinancePermission_Dist',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'Acc_FinancePermission exists !!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPT_Product')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 13,'Acc_GroupExtraPT_Product',0,'repupdatetime',0,'ID','Repl_GetAcc_GroupExtraPT_Product','Repl_PutAcc_GroupExtraPT_Product_Dist',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPT_Product exists !!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPT2_Product')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 13,'Acc_GroupExtraPT2_Product',0,'repupdatetime',0,'ID','Repl_GetAcc_GroupExtraPT2_Product','Repl_PutAcc_GroupExtraPT2_Product_Dist',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPT2_Product exists !!!'
END
GO
/***************************************************************************/




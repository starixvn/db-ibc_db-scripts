/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241106@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
	Revisions:
		- 20241106@Lewis: Created [RedmineID: #000000]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE name = 'Acc_DWLList')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'Acc_DWLList',0,'repupdatetime',0,'custid|product','DR_Repl_GetAcc_DWLList_Dist','DR_Repl_PutAcc_DWLList_Dist',1000,10,60000,0
END
ELSE
BEGIN 
	SELECT 'Acc_DWLList exists !!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE name = 'Acc_DWLList_ExtraPT')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'Acc_DWLList_ExtraPT',0,'repupdatetime',0,'CustId','DR_Repl_GetAcc_DWLList_ExtraPT_Dist','DR_Repl_PutAcc_DWLList_ExtraPT_Dist',1000,10,60000,0
END
ELSE
BEGIN 
	SELECT 'Acc_DWLList_ExtraPT exists !!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE name = 'Acc_DWLList_ExtraPT_xtest')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'Acc_DWLList_ExtraPT_xtest',0,'repupdatetime',0,'CustId','DR_Repl_GetAcc_DWLList_ExtraPT_xtest_Dist','DR_Repl_PutAcc_DWLList_ExtraPT_xtest_Dist',1000,10,60000,0
END
ELSE
BEGIN 
	SELECT 'Acc_DWLList_ExtraPT_xtest exists !!!'
END
GO
/***************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE name = 'Acc_DWLList_xtest')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'Acc_DWLList_xtest',0,'repupdatetime',0,'custid|product','DR_Repl_GetAcc_DWLList_xtest_Dist','DR_Repl_PutAcc_DWLList_xtest_Dist',1000,10,60000,0
END
ELSE
BEGIN 
	SELECT 'Acc_DWLList_xtest exists !!!'
END
GO
/***************************************************************************/

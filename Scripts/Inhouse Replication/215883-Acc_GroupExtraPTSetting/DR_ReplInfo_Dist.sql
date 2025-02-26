/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: DBCUST-CustDB
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE name = 'Acc_GroupExtraPTSetting')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'Acc_GroupExtraPTSetting',0,'repupdatetime',0,'ID','DR_Repl_GetAcc_GroupExtraPTSetting_Dist','DR_Repl_PutAcc_GroupExtraPTSetting_Dist',1000,10,60000,0
END
ELSE
BEGIN 
	SELECT 'Acc_GroupExtraPTSetting exists !!!'
END
GO
/***************************************************************************/

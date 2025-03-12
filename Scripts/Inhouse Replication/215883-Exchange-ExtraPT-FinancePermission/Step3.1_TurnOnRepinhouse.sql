/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_FinancePermission')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'Acc_FinancePermission'
END
ELSE
BEGIN  
	SELECT 'Acc_FinancePermission not exists !!!'
END
GO
/***************************************************************************/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPT_Product')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'Acc_GroupExtraPT_Product'
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPT_Product not exists !!!'
END
GO
/***************************************************************************/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPT2_Product')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'Acc_GroupExtraPT2_Product'
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPT2_Product not exists !!!'
END
GO
/***************************************************************************/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPT2Setting')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'Acc_GroupExtraPT2Setting'
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPT2Setting not exists !!!'
END
GO
/***************************************************************************/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPTSetting')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'Acc_GroupExtraPTSetting'
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPTSetting not exists !!!'
END
GO
/***************************************************************************/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'EaGroupHeadline')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 0
		AND [name] =  'EaGroupHeadline'
END
ELSE
BEGIN  
	SELECT 'EaGroupHeadline not exists !!!'
END
GO
/***************************************************************************/


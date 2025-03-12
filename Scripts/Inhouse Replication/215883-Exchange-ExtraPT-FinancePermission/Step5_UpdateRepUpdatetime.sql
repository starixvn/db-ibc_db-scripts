/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House 
	DB: 
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
--Acc_FinancePermission

UPDATE Acc_FinancePermission WITH (ROWLOCK,UPDLOCK) SET RepUpdateTime = dbo.f_GetDateTime2()

--Acc_GroupExtraPT_Product

UPDATE Acc_GroupExtraPT_Product WITH (ROWLOCK,UPDLOCK) SET RepUpdateTime = dbo.f_GetDateTime2()

--Acc_GroupExtraPT2_Product

UPDATE Acc_GroupExtraPT2_Product WITH (ROWLOCK,UPDLOCK) SET RepUpdateTime = dbo.f_GetDateTime2()

--Acc_GroupExtraPT2Setting

UPDATE Acc_GroupExtraPT2Setting WITH (ROWLOCK,UPDLOCK) SET RepUpdateTime = dbo.f_GetDateTime2()


--Acc_GroupExtraPTSetting

UPDATE Acc_GroupExtraPTSetting WITH (ROWLOCK,UPDLOCK) SET RepUpdateTime = dbo.f_GetDateTime2()

--EaGroupHeadline

UPDATE EaGroupHeadline WITH (ROWLOCK,UPDLOCK) SET RepUpdateTime = dbo.f_GetDateTime2()



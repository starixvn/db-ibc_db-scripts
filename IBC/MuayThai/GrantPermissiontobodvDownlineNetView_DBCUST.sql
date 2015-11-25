/*
	20151125@Dominic: Grant execution permission to bodbDownlineNetView on SPs to select setting
	Run at : DBCUST/CustDB
*/
GRANT EXECUTE ON [dbo].[Acc_CustSetting_CheckIsDeposit] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_SuperSettingSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_MasterSettingSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_AgentSettingSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_MemberSettingSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_CustomerInfoSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_CustomerLineInfoSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_ActorStatusSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_GroupedPTMemberLstSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_CustomerRoleSeleczt] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_ProductProfileSelect] TO bodbDownlineNetView AS [dbo]  
GRANT EXECUTE ON [dbo].[Acc_CustSetting_SettingDetailSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_StatusSettingSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_DisableMasterAutoPTSelect] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_CommMatrix] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_PTMatrix] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Acc_CustSetting_SettingLevel] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Age_CustomerSelPositionTakingByProductID_SAg] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Age_CustomerSelPositionTakingByProductID_MAg] TO bodbDownlineNetView AS [dbo] 
GRANT EXECUTE ON [dbo].[Age_CustomerSelPositionTakingByProductID_Ag] TO bodbDownlineNetView AS [dbo] 
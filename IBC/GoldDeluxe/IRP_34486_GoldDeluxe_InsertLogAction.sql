USE [bodb_CustomerLog]
GO

INSERT INTO [dbo].[LogAction]
           ([ActionID]
           ,[ActionTypeID]
           ,[SPName]
           ,[ActionNameEN]
           ,[ActionNameCH]
           ,[ActionNameCS]
           ,[ActionNameJP]
           ,[ActionNameIT]
           ,[ActionNameTH]
           ,[ActionNameKO]           
           ,[ActionNameVI]		   
           ,[IsInternal])
 SELECT  238, 2, 'Acc_CustomerUpdSuperGoldDeluxe_Commission', N'Update Gold Deluxe Commission for super', N'Update Gold Deluxe Commission for super', N'Update Gold Deluxe Commission for super', N'Update Gold Deluxe Commission for super', N'Update Gold Deluxe Commission for super', N'Update Gold Deluxe Commission for super', N'Update Gold Deluxe Commission for super', N'Update Gold Deluxe Commission for super',0
 UNION ALL
 SELECT  239, 2, 'Acc_CustomerUpdMasterGoldDeluxe_Commission',N'Update Gold Deluxe Commission for master',N'Update Gold Deluxe Commission for master',N'Update Gold Deluxe Commission for master',N'Update Gold Deluxe Commission for master',N'Update Gold Deluxe Commission for master',N'Update Gold Deluxe Commission for master',N'Update Gold Deluxe Commission for master',N'Update Gold Deluxe Commission for master',0
 UNION ALL
 SELECT  240, 2, 'Acc_CustomerUpdAgentGoldDeluxe_Commission', N'Update Gold Deluxe Commission for agent', N'Update Gold Deluxe Commission for agent', N'Update Gold Deluxe Commission for agent', N'Update Gold Deluxe Commission for agent', N'Update Gold Deluxe Commission for agent', N'Update Gold Deluxe Commission for agent', N'Update Gold Deluxe Commission for agent', N'Update Gold Deluxe Commission for agent',0
 UNION ALL
 SELECT  241, 2, 'Acc_CustomerUpdMemberGoldDeluxe_Commission', N'Update Gold Deluxe Commission for member', N'Update Gold Deluxe Commission for member', N'Update Gold Deluxe Commission for member', N'Update Gold Deluxe Commission for member', N'Update Gold Deluxe Commission for member', N'Update Gold Deluxe Commission for member', N'Update Gold Deluxe Commission for member', N'Update Gold Deluxe Commission for member',0
 UNION ALL

  SELECT  457, 1, 'Acc_CustomerUpdSuperGoldDeluxe_Positiontaking', N'Update Gold Deluxe Position Taking for super', N'Update Gold Deluxe Position Taking for super', N'Update Gold Deluxe Position Taking for super', N'Update Gold Deluxe Position Taking for super', N'Update Gold Deluxe Position Taking for super', N'Update Gold Deluxe Position Taking for super', N'Update Gold Deluxe Position Taking for super', N'Update Gold Deluxe Position Taking for super',0
 UNION ALL
 SELECT  458, 1, 'Acc_CustomerUpdMasterGoldDeluxe_PositionTaking', N'Update Gold Deluxe Position Taking for master', N'Update Gold Deluxe Position Taking for master', N'Update Gold Deluxe Position Taking for master', N'Update Gold Deluxe Position Taking for master', N'Update Gold Deluxe Position Taking for master', N'Update Gold Deluxe Position Taking for master', N'Update Gold Deluxe Position Taking for master', N'Update Gold Deluxe Position Taking for master',0
 UNION ALL
 SELECT  459, 1, 'Acc_CustomerUpdAgentGoldDeluxe_Positiontaking', N'Update Gold Deluxe Position Taking for agent', N'Update Gold Deluxe Position Taking for agent', N'Update Gold Deluxe Position Taking for agent', N'Update Gold Deluxe Position Taking for agent', N'Update Gold Deluxe Position Taking for agent', N'Update Gold Deluxe Position Taking for agent', N'Update Gold Deluxe Position Taking for agent', N'Update Gold Deluxe Position Taking for agent', 0
 UNION ALL
 SELECT  460, 1, 'Acc_CustomerUpdMemberGoldDeluxe_Positiontaking', N'Update Gold Deluxe Position Taking for member', N'Update Gold Deluxe Position Taking for member', N'Update Gold Deluxe Position Taking for member', N'Update Gold Deluxe Position Taking for member', N'Update Gold Deluxe Position Taking for member', N'Update Gold Deluxe Position Taking for member', N'Update Gold Deluxe Position Taking for member', N'Update Gold Deluxe Position Taking for member', 0
 UNION ALL
 SELECT  461, 1, 'Acc_CustomerUpdMemberGoldDeluxe_SAg', N'Update Super''s Gold Deluxe Position Taking for member', N'Update Super''s Gold Deluxe Position Taking for member', N'Update Super''s Gold Deluxe Position Taking for member', N'Update Super''s Gold Deluxe Position Taking for member', N'Update Super''s Gold Deluxe Position Taking for member', N'Update Super''s Gold Deluxe Position Taking for member', N'Update Super''s Gold Deluxe Position Taking for member', N'Update Super''s Gold Deluxe Position Taking for member',0
 UNION ALL
 SELECT  462, 1, 'Acc_CustomerUpdMemberGoldDeluxe_MAg', N'Update Master''s Gold Deluxe Position Taking for member', N'Update Master''s Gold Deluxe Position Taking for member', N'Update Master''s Gold Deluxe Position Taking for member', N'Update Master''s Gold Deluxe Position Taking for member', N'Update Master''s Gold Deluxe Position Taking for member', N'Update Master''s Gold Deluxe Position Taking for member', N'Update Master''s Gold Deluxe Position Taking for member', N'Update Master''s Gold Deluxe Position Taking for member',0

 UNION ALL
 SELECT  507, 1, 'Acc_CustOverrideUpdGoldDeluxe', N'Update Gold Deluxe Min Position Taking', N'Update Gold Deluxe Min Position Taking', N'Update Gold Deluxe Min Position Taking', N'Update Gold Deluxe Min Position Taking', N'Update Gold Deluxe Min Position Taking', N'Update Gold Deluxe Min Position Taking', N'Update Gold Deluxe Min Position Taking', N'Update Gold Deluxe Min Position Taking', 0
 
 UNION ALL
 SELECT  1155, NULL, 'Acc_CustomerUpdDisableGoldDeluxe', N'Update enable/disable Gold Deluxe status', N'Update enable/disable Gold Deluxe status', N'Update enable/disable Gold Deluxe status', N'Update enable/disable Gold Deluxe status', N'Update enable/disable Gold Deluxe status', N'Update enable/disable Gold Deluxe status', N'Update enable/disable Gold Deluxe status', N'Update enable/disable Gold Deluxe status', 0
 
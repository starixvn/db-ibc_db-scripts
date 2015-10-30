/*
	Description: A Script to insert new defined ActionID into LogAction table for new SP.
                 Please check for existed record before execute this script.
	Creator: 20151021@Billy
    DB: DBLOG.bodb_CustomerLog
*/

USE [bodb_CustomerLog]
GO
INSERT  INTO [bodb_CustomerLog].[dbo].[LogAction] 
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
                ,[IsInternal]
                )
        VALUES  (237
                ,2
                ,'Acc_CustSetting_DiscountUpd'
                ,'Update Other Products Commission for customers'
                ,'Update Other Products Commission for customers'
                ,'Update Other Products Commission for customers'
                ,'Update Other Products Commission for customers'
                ,'Update Other Products Commission for customers'
                ,'Update Other Products Commission for customers'
                ,'Update Other Products Commission for customers'
                ,'Update Other Products Commission for customers'
                ,0),

                (384
                ,3
                ,'Acc_CustSetting_BetLimitUpd'
                ,'Update Other Products Bet Setting for customers'
                ,'Update Other Products Bet Setting for customers'
                ,'Update Other Products Bet Setting for customers'
                ,'Update Other Products Bet Setting for customers'
                ,'Update Other Products Bet Setting for customers'
                ,'Update Other Products Bet Setting for customers'
                ,'Update Other Products Bet Setting for customers'
                ,'Update Other Products Bet Setting for customers'
                ,0),

                (448
                ,1
                ,'Acc_CustSetting_SuperPTUpd'
                ,'Update Other Product Position Taking for Super'
                ,'Update Other Product Position Taking for Super'
                ,'Update Other Product Position Taking for Super'
                ,'Update Other Product Position Taking for Super'
                ,'Update Other Product Position Taking for Super'
                ,'Update Other Product Position Taking for Super'
                ,'Update Other Product Position Taking for Super'
                ,'Update Other Product Position Taking for Super'
                ,0),

                (449
                ,1
                ,'Acc_CustSetting_MasterPTUpd'
                ,'Update Other Product Position Taking for Master'
                ,'Update Other Product Position Taking for Master'
                ,'Update Other Product Position Taking for Master'
                ,'Update Other Product Position Taking for Master'
                ,'Update Other Product Position Taking for Master'
                ,'Update Other Product Position Taking for Master'
                ,'Update Other Product Position Taking for Master'
                ,'Update Other Product Position Taking for Master'
                ,0),

                (450
                ,1
                ,'Acc_CustSetting_AgentPTOnMemberMultiUpd'
                ,'Update Other Products Position Taking for member (Multiple)'
                ,'Update Other Products Position Taking for member (Multiple)'
                ,'Update Other Products Position Taking for member (Multiple)'
                ,'Update Other Products Position Taking for member (Multiple)'
                ,'Update Other Products Position Taking for member (Multiple)'
                ,'Update Other Products Position Taking for member (Multiple)'
                ,'Update Other Products Position Taking for member (Multiple)'
                ,'Update Other Products Position Taking for member (Multiple)'
                ,0),

                (451
                ,1
                ,'Acc_CustSetting_MasterPTOnMemberMultiUpd'
                ,'Update Master''s Other Products Position Taking for member (Multiple)'
                ,'Update Master''s Other Products Position Taking for member (Multiple)'
                ,'Update Master''s Other Products Position Taking for member (Multiple)'
                ,'Update Master''s Other Products Position Taking for member (Multiple)'
                ,'Update Master''s Other Products Position Taking for member (Multiple)'
                ,'Update Master''s Other Products Position Taking for member (Multiple)'
                ,'Update Master''s Other Products Position Taking for member (Multiple)'
                ,'Update Master''s Other Products Position Taking for member (Multiple)'
                ,0),

                (452
                ,1
                ,'Acc_CustSetting_SuperPTOnMemberMultiUpd'
                ,'Update Super''s Other Products Position Taking for member (Multiple)'
                ,'Update Super''s Other Products Position Taking for member (Multiple)'
                ,'Update Super''s Other Products Position Taking for member (Multiple)'
                ,'Update Super''s Other Products Position Taking for member (Multiple)'
                ,'Update Super''s Other Products Position Taking for member (Multiple)'
                ,'Update Super''s Other Products Position Taking for member (Multiple)'
                ,'Update Super''s Other Products Position Taking for member (Multiple)'
                ,'Update Super''s Other Products Position Taking for member (Multiple)'
                ,0),

                (453
                ,1
                ,'Acc_CustSetting_AgentPTOnMemberUpd'
                ,'Update Other Products Position Taking for member'
                ,'Update Other Products Position Taking for member'
                ,'Update Other Products Position Taking for member'
                ,'Update Other Products Position Taking for member'
                ,'Update Other Products Position Taking for member'
                ,'Update Other Products Position Taking for member'
                ,'Update Other Products Position Taking for member'
                ,'Update Other Products Position Taking for member'
                ,0),

                (454
                ,1
                ,'Acc_CustSetting_AgentPTUpd'
                ,'Update Other Product Position Taking for Agent'
                ,'Update Other Product Position Taking for Agent'
                ,'Update Other Product Position Taking for Agent'
                ,'Update Other Product Position Taking for Agent'
                ,'Update Other Product Position Taking for Agent'
                ,'Update Other Product Position Taking for Agent'
                ,'Update Other Product Position Taking for Agent'
                ,'Update Other Product Position Taking for Agent'
                ,0),

                (455
                ,1
                ,'Acc_CustSetting_SuperPTOnMemberUpd'
                ,'Update Super''s Other Product Position Taking for member'
                ,'Update Super''s Other Product Position Taking for member'
                ,'Update Super''s Other Product Position Taking for member'
                ,'Update Super''s Other Product Position Taking for member'
                ,'Update Super''s Other Product Position Taking for member'
                ,'Update Super''s Other Product Position Taking for member'
                ,'Update Super''s Other Product Position Taking for member'
                ,'Update Super''s Other Product Position Taking for member'
                ,0),

                (456
                ,1
                ,'Acc_CustSetting_MasterPTOnMemberUpd'
                ,'Update Master''s Other Product Position Taking for member'
                ,'Update Master''s Other Product Position Taking for member'
                ,'Update Master''s Other Product Position Taking for member'
                ,'Update Master''s Other Product Position Taking for member'
                ,'Update Master''s Other Product Position Taking for member'
                ,'Update Master''s Other Product Position Taking for member'
                ,'Update Master''s Other Product Position Taking for member'
                ,'Update Master''s Other Product Position Taking for member'
                ,0),

                (1152
                ,NULL
                ,'Acc_CustSetting_DisableStatUpd'
                ,'Update enabled/disabled Other Products status'
                ,'Update enabled/disabled Other Products status'
                ,'Update enabled/disabled Other Products status'
                ,'Update enabled/disabled Other Products status'
                ,'Update enabled/disabled Other Products status'
                ,'Update enabled/disabled Other Products status'
                ,'Update enabled/disabled Other Products status'
                ,'Update enabled/disabled Other Products status'
                ,0),

                (1153
                ,NULL
                ,'Acc_CustSetting_SyncStatUpd'
                ,'Update initial Other Products status'
                ,'Update initial Other Products status'
                ,'Update initial Other Products status'
                ,'Update initial Other Products status'
                ,'Update initial Other Products status'
                ,'Update initial Other Products status'
                ,'Update initial Other Products status'
                ,'Update initial Other Products status'
                ,0)
GO
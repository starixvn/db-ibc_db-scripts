/*
	Description: A Script to insert new defined ActionID into LogAction table for new SP. [RedmineID: #62547]
	Creator: 20161205@Winnie
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
        VALUES  (851
                ,NULL
                ,'Acc_CustSetting_WinLossLimitUpd'
                ,'Update Other Products Member Loss Limit for customers'
                ,'Update Other Products Member Loss Limit for customers'
                ,'Update Other Products Member Loss Limit for customers'
                ,'Update Other Products Member Loss Limit for customers'
                ,'Update Other Products Member Loss Limit for customers'
                ,'Update Other Products Member Loss Limit for customers'
                ,'Update Other Products Member Loss Limit for customers'
                ,'Update Other Products Member Loss Limit for customers'
                ,0)
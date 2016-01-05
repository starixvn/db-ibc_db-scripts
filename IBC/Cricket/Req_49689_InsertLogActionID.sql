/*
	Description: A Script to insert new defined ActionID into LogAction table for new SP.
	Creator: 20160104@Dominic
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
        VALUES  (248
                ,2
                ,'Acc_CustSetting_DiscountUpd'
                ,'Update Other Products Charge Commission for customers'
                ,'Update Other Products Charge Commission for customers'
                ,'Update Other Products Charge Commission for customers'
                ,'Update Other Products Charge Commission for customers'
                ,'Update Other Products Charge Commission for customers'
                ,'Update Other Products Charge Commission for customers'
                ,'Update Other Products Charge Commission for customers'
                ,'Update Other Products Charge Commission for customers'
                ,0)
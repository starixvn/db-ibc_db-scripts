/*
	Description: A Script to insert new defined ActionID into LogAction table for new SPs
	Creator: 20151208@Billy
    DB: DBLOG/bodb_CustomerLog
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
        VALUES  (2045
                ,3
                ,'Acc_Dep_CustomerUpdSetting_MinMaxBet'
                ,'Update Bet Settings for Deposit Customers'
                ,'Update Bet Settings for Deposit Customers'
                ,'Update Bet Settings for Deposit Customers'
                ,'Update Bet Settings for Deposit Customers'
                ,'Update Bet Settings for Deposit Customers'
                ,'Update Bet Settings for Deposit Customers'
                ,'Update Bet Settings for Deposit Customers'
                ,'Update Bet Settings for Deposit Customers'
                ,0)
GO
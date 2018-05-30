/*
    Creator: Razor
	Date: 2018-05-30
	Task: Manage Customer Limit Date
	DB: DBLOG/bodb_CustomerLog

	Revisions:
		- 20180530@Razor: Manage Customer Limit Date [Redmine:#96025]

	Param's Explanation:
*/

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
           ,[XsltContent]
           ,[IsInternal]
           ,[ActionNameVI])
     VALUES
           (31501
           ,NULL
           ,'Acc_CustomerDateLimitIns'
           ,'Insert Customer Limit Date'
           ,'Insert Customer Limit Date'
           ,'Insert Customer Limit Date'
           ,'Insert Customer Limit Date'
           ,'Insert Customer Limit Date'
           ,'Insert Customer Limit Date'
           ,'Insert Customer Limit Date'
           ,NULL
           ,1
           ,'Insert Customer Limit Date')
GO


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
           ,[XsltContent]
           ,[IsInternal]
           ,[ActionNameVI])
     VALUES
           (31502
           ,NULL
           ,'Acc_CustomerDateLimitDel'
           ,'Delete Customer Limit Date'
           ,'Delete Customer Limit Date'
           ,'Delete Customer Limit Date'
           ,'Delete Customer Limit Date'
           ,'Delete Customer Limit Date'
           ,'Delete Customer Limit Date'
           ,'Delete Customer Limit Date'
           ,NULL
           ,1
           ,'Delete Customer Limit Date')
GO

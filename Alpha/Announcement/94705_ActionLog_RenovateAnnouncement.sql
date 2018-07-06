/*
    Creator: Razor
	Date: 2018-07-12
	Task: Add action for Message Customer Read Status
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
           (1050
           ,NULL
           ,'Age_MsgCustReadStatus_Upd'
           ,'Update Message Customer Read Status'
           ,'Update Message Customer Read Status'
           ,'Update Message Customer Read Status'
           ,'Update Message Customer Read Status'
           ,'Update Message Customer Read Status'
           ,'Update Message Customer Read Status'
           ,'Update Message Customer Read Status'
           ,NULL
           ,1
           ,'Update Message Customer Read Status')
GO

/*
    Creator: Razor
	Date: 2018-08-02
	Task: Splitting Super Profile for EXT
	DB: DBLOG/bodb_CustomerLog

	Revisions:
		- 20180802@Razor: Splitting Super Profile for EXT [Redmine:#86934]

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
           (677
           ,NULL
           ,'EAS_CustomerUpdSuperInfo'
           ,'Update Super Profile'
           ,'Update Super Profile'
           ,'Update Super Profile'
           ,'Update Super Profile'
           ,'Update Super Profile'
           ,'Update Super Profile'
           ,'Update Super Profile'
           ,NULL
           ,1
           ,'Update Super Profile')
GO

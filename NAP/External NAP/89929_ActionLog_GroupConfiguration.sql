/*
    Creator: Razor
	Date: 2018-12-03
	Task: Add Group configuration page
	DB: DBLOG/bodb_CustomerLog

	Revisions:
		- 20181203@Razor: Add Group configuration page [Redmine: #89929]

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
           (20131
           ,NULL
           ,'EAS_GroupConfigurationUpd'
           ,'Update Group Configuration'
           ,'Update Group Configuration'
           ,'Update Group Configuration'
           ,'Update Group Configuration'
           ,'Update Group Configuration'
           ,'Update Group Configuration'
           ,'Update Group Configuration'
           ,NULL
           ,1
           ,'Update Group Configuration')
GO

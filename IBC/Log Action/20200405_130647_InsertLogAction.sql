/*
Created: 20200405@Sophia
Task: Insert log action - Add ExtraPT for super from existing super [Redmine:#130647]
DB: DBLOG.[bodb_CustomerLog]
Revisions:

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
           (95010
           ,4
           ,'EAS_CustomerInsMember_CloneSetting_ExtraPT'
           ,'Add ExtraPT for super from existing super'
           ,'Add ExtraPT for super from existing super'
           ,'Add ExtraPT for super from existing super'
           ,'Add ExtraPT for super from existing super'
           ,'Add ExtraPT for super from existing super'
           ,'Add ExtraPT for super from existing super'
           ,'Add ExtraPT for super from existing super'
           ,NULL
           ,1
           ,'Add ExtraPT for super from existing super')
GO



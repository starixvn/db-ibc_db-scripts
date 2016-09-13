/*
	Created: 201609013@Winnie
	Task: Insert log Action - [Redmine: #63736]
	DB: DBLOG/bodb_CustomerLog
*/

USE bodb_CustomerLog
GO

INSERT INTO [LogAction]
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
           (249
           ,2
           ,'Acc_CustomerNoCommIns'
           ,'Add customer have no commission'
           ,'Add customer have no commission'
           ,'Add customer have no commission'
           ,'Add customer have no commission'
           ,'Add customer have no commission'
           ,'Add customer have no commission'
           ,'Add customer have no commission'
           ,'Add customer have no commission'
           ,1
           ,'Add customer have no commission')
GO
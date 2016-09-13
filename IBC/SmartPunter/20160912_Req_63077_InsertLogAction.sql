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
           (663
           ,4
           ,'Acc_CustomerSelCheckSmartPunter'
           ,'Select smart punter'
           ,'Select smart punter'
           ,'Select smart punter'
           ,'Select smart punter'
           ,'Select smart punter'
           ,'Select smart punter'
           ,'Select smart punter'
           ,'Select smart punter'
           ,1
           ,'Select smart punter')
GO
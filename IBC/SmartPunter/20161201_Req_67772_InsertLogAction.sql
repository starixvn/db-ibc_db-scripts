/*
	Created: 20161201@Winnie
	Task: Insert log Action - [RedmineID: #67772]
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
           (31008
           ,NULL
           ,'Age_UserLog_SmartPunterInsMultiple'
           ,'View Bet List'
           ,'View Bet List'
           ,'View Bet List'
           ,'View Bet List'
           ,'View Bet List'
           ,'View Bet List'
           ,'View Bet List'
           ,'View Bet List'
           ,1
           ,'View Bet List')
GO



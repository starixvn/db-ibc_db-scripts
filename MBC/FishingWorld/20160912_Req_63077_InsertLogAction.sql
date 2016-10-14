/*
	Created: 20161014@Winnie
	Task: Insert log Action - [Redmine: #62547]
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
           (851
           ,NULL
           ,'Acc_CustSetting_WinLossLimitUpd'
           ,'Update Other Products Member Loss Limit for customers'
           ,'Update Other Products Member Loss Limit for customers'
           ,'Update Other Products Member Loss Limit for customers'
           ,'Update Other Products Member Loss Limit for customers'
           ,'Update Other Products Member Loss Limit for customers'
           ,'Update Other Products Member Loss Limit for customers'
           ,'Update Other Products Member Loss Limit for customers'
           ,'Update Other Products Member Loss Limit for customers'
           ,0
           ,'Update Other Products Member Loss Limit for customers')
GO
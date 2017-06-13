/*
	Created by: Winnie
	Date: 2017-06-12
	Task: insert log action
	add the column IsAllDayBalTransfer 
	Server: DBLOG/bodb_CustomerLog	
*/ 

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBLOG/bodb_CustomerLog			--
------------------------------------------------------------------

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
           (705
           ,NULL
           ,'Acc_CustomerUpdAllDayBalTransfer'
           ,'Enabled/Disabled All day balance transfer'
           ,'Enabled/Disabled All day balance transfer'
           ,'Enabled/Disabled All day balance transfer'
           ,'Enabled/Disabled All day balance transfer'
           ,'Enabled/Disabled All day balance transfer'
           ,'Enabled/Disabled All day balance transfer'
           ,'Enabled/Disabled All day balance transfer'
           ,NULL
           ,0
           ,'Enabled/Disabled All day balance transfer')
GO



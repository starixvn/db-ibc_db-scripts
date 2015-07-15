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
           ,[ActionNameVI]		   
           ,[IsInternal])
SELECT  1156, NULL, 'Acc_CustomerUpdDisableSuperLive', N'Update Enable/Disable Super Live status', N'Update Enable/Disable Super Live status', N'Update Enable/Disable Super Live status', N'Update Enable/Disable Super Live status', N'Update Enable/Disable Super Live status', N'Update Enable/Disable Super Live status', N'Update Enable/Disable Super Live status', N'Update Enable/Disable Super Live status', 0
 
 
 
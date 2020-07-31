/*<info serverAlias="DBCUST-CUSTDB"></info>*/

USE [CustDB]
GO

/*
Create : 20200730@Sophia
Task: UMConfig for Transfer [Redmine: #136992]
DB : DBCUST.CUSTDB
*/

/*

DELETE [UMConfig] Where FunctionType = 101 

INSERT INTO [dbo].[UMConfig]
           ([ProductID]
           ,[SportType]
           ,[BetType]
           ,[IsLive]
           ,[SettingType]
           ,[FunctionType]
           ,[SiteID]
           ,[Currency]
           ,[SuperID]
           ,[BeginTime]
           ,[EndTime])
     VALUES
           (0
           ,0
           ,0
           ,0
           ,0
           ,101 --- transfer
           ,0--21
           ,0--67
           ,0--179457
           ,'2020-07-30 21:53:05.620'
           ,'2020-07-31 00:01:05.620'
		   )
		   
*/

SELECT * FROM UMConfig  Where FunctionType = 101 
GO

  
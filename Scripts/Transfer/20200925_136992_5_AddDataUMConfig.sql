/*<info serverAlias="DBCUST-CUSTDB,DBTXN-CUSTDB"></info>*/

USE [CustDB]
GO

/*
Create : 20200730@Sophia
Task: UMConfig for Transfer [Redmine: #136992]
DB : DBCUST.CUSTDB
*/

INSERT INTO [dbo].[UMConfig_UAT]
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
           ,23003140
           ,'2020-09-25 04:00:00'
           ,'2020-09-26 06:00:00'
		   )
		   
INSERT INTO [dbo].[UMConfig_UAT]
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
           ,1
           ,0--67
           ,0
           ,'2020-09-25 05:00:00'
           ,'2020-09-25 08:00:00'
		   )
		   

SELECT * FROM UMConfig_UAT  Where FunctionType = 101 
GO

  
/*<info serverAlias="DBCUST-CUSTDB"></info>*/

USE [CustDB]
GO
  
/*
Create : 202001001@Sophia
Task: Update data test for QC: UMConfig [Redmine: #136992]
DB : DBCUST.CUSTDB
*/ 
 
 
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
           ,3 
           ,20 
           ,26912753
           ,'2020-10-02 1:00:00'
           ,'2020-10-07 1:00:00'
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
           ,3 
           ,20 
           ,26912753
           ,'2020-10-02 1:00:00'
           ,'2020-10-07 1:00:00'
		   )
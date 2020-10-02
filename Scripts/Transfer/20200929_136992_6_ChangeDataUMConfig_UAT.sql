/*<info serverAlias="DBCUST-CUSTDB"></info>*/

USE [CustDB]
GO
  
/*
Create : 202001001@Sophia
Task: Update data test for QC: UMConfig_UAT [Redmine: #136992]
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
           ,0 
           ,0 
           ,1176070
           ,'2020-10-02 01:00:00'
           ,'2020-10-03 21:00:00'
		   )
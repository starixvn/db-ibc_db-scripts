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
           ,1 
           ,20 
           ,23003140
           ,'2020-10-02 1:00:00'
           ,'2020-10-06 2:00:00'
		   )
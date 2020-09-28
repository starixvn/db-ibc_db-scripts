/*<info serverAlias="DBCUST-CUSTDB"></info>*/

USE [CustDB]
GO

/*
Create : 20200730@Sophia
Task: MsgError for being auto transfer [Redmine: #137141]
DB : DBCUST.CUSTDB
*/

INSERT INTO [dbo].[MsgError]
           ([MsgID]
           ,[MsgGroupID]
           ,[MsgNameEN]
           ,[MsgNameCT]
           ,[MsgNameCS]
           ,[MsgNameJP]
           ,[MsgNameTH]
           ,[MsgNameKO]
           ,[MsgNameES]
           ,[MsgNameVI]
           ,[IsActive]
           ,[MsgNameCN])
     VALUES
           (50015
           ,6
		   ,'Your line is being auto transferred. Please wait a few minutes and try again.'
           ,N'你的線路正在自動轉移。請稍等幾分鐘後再嘗試。'
           ,N'你的线路正在自动转移。请稍等几分钟后再尝试。'
           ,N'Your line is being auto transferred. Please wait a few minutes and try again.'
           ,N'สายของคุณกำลังโอนโดยอัตโนมัติ โปรดรอสักครู่แล้วลองอีกครั้ง'
           ,N'Your line is being auto transferred. Please wait a few minutes and try again.'
           ,N'Your line is being auto transferred. Please wait a few minutes and try again.'
           ,N'Your line is being auto transferred. Please wait a few minutes and try again.'
           ,1
           ,N'Your line is being auto transferred. Please wait a few minutes and try again.'
		   )
GO 
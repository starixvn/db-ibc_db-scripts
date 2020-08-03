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
		   ,'Your line is being auto transfer. Please wait a few minutes and try again.'
           ,'Your line is being auto transfer. Please wait a few minutes and try again.'
           ,'Your line is being auto transfer. Please wait a few minutes and try again.'
           ,'Your line is being auto transfer. Please wait a few minutes and try again.'
           ,'Your line is being auto transfer. Please wait a few minutes and try again.'
           ,'Your line is being auto transfer. Please wait a few minutes and try again.'
           ,'Your line is being auto transfer. Please wait a few minutes and try again.'
           ,'Your line is being auto transfer. Please wait a few minutes and try again.'
           ,1
           ,'Your line is being auto transfer. Please wait a few minutes and try again.'
		   )
GO
 
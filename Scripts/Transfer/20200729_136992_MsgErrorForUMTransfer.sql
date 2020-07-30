/*<info serverAlias="DBCUST-CUSTDB"></info>*/

USE [CustDB]
GO

/*
Create : 20200730@Sophia
Task: MsgError for UM Transfer [Redmine: #136992]
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
           (90015
           ,10
		   ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,1
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
		   )
GO
 
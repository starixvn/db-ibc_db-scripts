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
		   ,'Transfer is under maintenance  from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,N'轉賬正在維護中從 <FromTime> (GMT+8) 至 <ToTime> (GMT+8)：轉賬失敗'
           ,N'转账正在维护中 从 <FromTime> (GMT+8) 至 <ToTime> (GMT+8)：转账失败'
           ,'Transfer is under maintennance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,N'การถ่ายโอนอยู่ในระหว่างการปรับปรุง ตั้งแต่ <FromTime> (GMT + 8) ถึง <ToTime> (GMT + 8) : การถ่ายโอนล้มเหลว'
           ,'Transfer is under maintenance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,'Transfer is under maintenance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
           ,N'Giao dịch không thành công: Tính năng chuyển khoản hiện đang bảo trì từ <FromTime> (GMT+8) đến <ToTime> (GMT+8)'
           ,1
           ,'Transfer is under maintenance from <FromTime> (GMT+8) to <ToTime> (GMT+8): Transfer failed'
		   )
GO
 
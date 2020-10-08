/*<info serverAlias="DBCUST-CUSTDB"></info>*/

USE [CustDB]
GO

/*
Create : 20200730@Sophia
Task: MsgError for being auto transfer, update languague [Redmine: #137141]
DB : DBCUST.CUSTDB
*/
 
 UPDATE  MsgError 
 SET MsgNameVI = N'Tuyến dưới của bạn đang được chuyển khoản tự động. Vui lòng chờ một vài phút và thử lại.'
 WHERE MsgID = 50015 
/*
	Description: A Script to update translated messages for actionid 248 (charge Comm) Redmine #49689
	Creator: 20160316@Dominic
    DB: DBLOG.bodb_CustomerLog
*/

USE [bodb_CustomerLog]
GO
UPDATE [dbo].[LogAction] 
SET 
	ActionNameCH = N'更新其他產品的抽取傭金',
	ActionNameCS = N'更新其他产品的抽取佣金',
	ActionNameTH = N'อัพเดทการตั้งค่า การเก็บค่าธรรมเนียมคอมมิชชั่น ในผลิตภันฑ์อื่น ๆ ให้กับลูกค้า'
WHERE ActionID = 248
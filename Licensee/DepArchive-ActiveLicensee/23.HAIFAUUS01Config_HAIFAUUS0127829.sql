/*
	Task: Insert archive config for HAIFAUUS0127829 - Redmine #103644
	Creator: Dominic@20190130
	Run at: CustDB@DBCUST
*/
USE CustDB
GO

--1 affected rows
INSERT INTO [dbo].[Dep_Customer_Archived]
           ([CustID]
           ,[ArchivedDate]
           ,[Username]
           ,[Username2]
           ,[Recommend]
           ,[ClosingBalance]
           ,[CustIDBalanceDummy]
           ,[Status])
     VALUES
           (24745851 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS0127829' --Username
           ,'haifa$test-148748973' --Username2
           ,4345531 --Recommend
           ,0 --ClosingBalance
           ,33870903 --CustIDBalanceDummy
           ,'waiting')

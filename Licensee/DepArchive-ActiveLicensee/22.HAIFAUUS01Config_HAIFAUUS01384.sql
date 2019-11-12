/*
	Task: Insert archive config for HAIFAUUS01384 - Redmine #103644
	Creator: Dominic@20190124
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
           (5930591 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01384' --Username
           ,'haifa$test-1039586' --Username2
           ,4345531 --Recommend
           ,50.32 --ClosingBalance
           ,33870903 --CustIDBalanceDummy
           ,'waiting')

/*
	Task: Insert archive config for HAIFAUUS01077 - Redmine #103644
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
           (4831248 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01077' --Username
           ,'haifa$1612206' --Username2
           ,4345531 --Recommend
           ,10.00 --ClosingBalance
           ,33870903 --CustIDBalanceDummy
           ,'waiting')

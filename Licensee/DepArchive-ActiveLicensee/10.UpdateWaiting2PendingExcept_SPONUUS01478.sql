/*
	Task: - Update status of 'waiting' members in Dep_Customer_Archived_Config to 'pending'
		  - Insert data for SPONUUS01478 for testing purposes 
	Redmine: #107171
	Creator: Dominic@20190114
	Run at: CustDB@DBCUST
*/
USE CustDB
GO


--Step 1: Update status of 'waiting' members in Dep_Customer_Archived_Config to 'pending'
--61786 affected rows
WHILE (1=1)
BEGIN
	UPDATE TOP (5000) [dbo].[Dep_Customer_Archived] WITH(ROWLOCK)
	Set status='pending'
	WHERE status='waiting'

	IF @@ROWCOUNT < 5000
		BREAK

	WAITFOR DELAY '00:00:02'
END

--Step 2: Insert data for SPONUUS01478 for testing purposes 
-- 1 affected row
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
           (29681326 -- CustID
           ,GETDATE() --ArchivedDate
           ,'SPONUUS01478' --Username
           ,'spondemo$csdtest03' --Username2
           ,3233923 --Recommend
           ,1911.05 --ClosingBalance
           ,33554701 --CustIDBalanceDummy
           ,'waiting')

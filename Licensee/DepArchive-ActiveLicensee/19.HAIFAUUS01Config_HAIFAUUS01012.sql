/*
	Task: Insert archive config for HAIFAUUS01012,HAIFAUUS01013 - Redmine #103644
	Creator: Dominic@20190123
	Run at: CustDB@DBCUST
*/
USE CustDB
GO

DECLARE @CustIDBalanceDummy INT
SELECT  @CustIDBalanceDummy = ISNULL(CustID,-1)
FROM Customer (NOLOCK)
WHERE recommend=4345531
AND username='HAIFAUUS01ClearBal'
AND roleid = 1

IF ISNULL(@CustIDBalanceDummy,-1) = -1
BEGIN
	SELECT 'The dedicated dummy account is missed!'
END

--2 affected rows
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
           (4368034 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01012' --Username
           ,'haifa$qatest12' --Username2
           ,4345531 --Recommend
           ,9058199.70 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
		   
		   (4368037 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01013' --Username
           ,'haifa$qatest13' --Username2
           ,4345531 --Recommend
           ,9058198.68 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting')


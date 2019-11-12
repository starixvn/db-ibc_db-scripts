/*
	Task: Insert archive config for HAIFAUUS01009, HAIFAUUS01010, HAIFAUUS01011, HAIFAUUS01013, HAIFAUUS01014 - Redmine #103644
	Creator: Dominic@20190228
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
           (4368028 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01009' --Username
           ,'haifa$qatest09' --Username2
           ,4345531 --Recommend
           ,9058558.4856 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
		   
		   (4368030 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01010' --Username
           ,'haifa$qatest10' --Username2
           ,4345531 --Recommend
           ,9057837.893 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),

		   (4368031 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01011' --Username
           ,'haifa$qatest11' --Username2
           ,4345531 --Recommend
           ,9058206.59 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),

		   (4368037 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01013' --Username
           ,'haifa$qatest13' --Username2
           ,4345531 --Recommend
           ,9058240.68 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),

		   (4368038 -- CustID
           ,GETDATE() --ArchivedDate
           ,'HAIFAUUS01014' --Username
           ,'haifa$qatest14' --Username2
           ,4345531 --Recommend
           ,9058179.02 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting')


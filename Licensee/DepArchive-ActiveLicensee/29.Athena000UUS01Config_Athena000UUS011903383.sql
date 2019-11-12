/*
	Task: Insert archive config for test account (Redmine #103644) : 
			Athena000UUS011903383
			Athena000UUS011903384
			Athena000UUS011903379
			Athena000UUS011903377
			Athena000UUS011903405
			Athena000UUS011903436
			Athena000UUS011903437
			Athena000UUS011903439
			Athena000UUS011903504
			Athena000UUS011903505
			Athena000UUS011903506
			Athena000UUS011903507
			Athena000UUS011903508
			Athena000UUS011903509
	Creator: Dominic@20190403
	Run at: CustDB@DBCUST
*/
USE CustDB
GO

DECLARE @CustIDBalanceDummy INT
SELECT  @CustIDBalanceDummy = ISNULL(CustID,-1)
FROM Customer (NOLOCK)
WHERE recommend=10063439
AND username='Athena000UUS01ClearBal'
AND roleid = 1

IF ISNULL(@CustIDBalanceDummy,-1) = -1
BEGIN
	SELECT 'The dedicated dummy account is missed!'
END

--14 affected rows
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
(29131442 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903377' --Username
           ,'Athena000$david501' --Username2
           ,10063439 --Recommend
           ,500 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29239785 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903379' --Username
           ,'Athena000$david401' --Username2
           ,10063439 --Recommend
           ,922.6685 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29244079 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903383' --Username
           ,'Athena000$david402' --Username2
           ,10063439 --Recommend
           ,3370.6 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29252399 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903384' --Username
           ,'Athena000$david403' --Username2
           ,10063439 --Recommend
           ,2028.1823 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29268238 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903405' --Username
           ,'Athena000$david404' --Username2
           ,10063439 --Recommend
           ,1999.66 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29314580 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903436' --Username
           ,'Athena000$david405' --Username2
           ,10063439 --Recommend
           ,50.61 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29314694 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903437' --Username
           ,'Athena000$david406' --Username2
           ,10063439 --Recommend
           ,5.95 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29317435 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903439' --Username
           ,'Athena000$david407' --Username2
           ,10063439 --Recommend
           ,5 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29453406 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903504' --Username
           ,'Athena000$david601' --Username2
           ,10063439 --Recommend
           ,1000 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29456988 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903505' --Username
           ,'Athena000$david602' --Username2
           ,10063439 --Recommend
           ,5000 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29457252 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903506' --Username
           ,'Athena000$david603' --Username2
           ,10063439 --Recommend
           ,5050 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29457415 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903507' --Username
           ,'Athena000$david604' --Username2
           ,10063439 --Recommend
           ,1000 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),
(29460902 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903508' --Username
           ,'Athena000$david605' --Username2
           ,10063439 --Recommend
           ,1000 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting'),

(29460903 -- CustID
           ,'20190303' --ArchivedDate
           ,'Athena000UUS011903509' --Username
           ,'Athena000$david607' --Username2
           ,10063439 --Recommend
           ,2000 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting')

/*
	Task: Insert test data for following members of Athena000UUS01 - Redmine #99882
		Username2         Username
		david209          Athena000UUS011903369
		davidnobonus	  Athena000UUS011903520
		eunice001		  Athena000UUS011903372
		eunice002         Athena000UUS011903373
		eunice003         Athena000UUS011903376
		bonustest11       Athena000UUS011903704
		bonustest001      Athena000UUS011903420
		bonustest003      Athena000UUS011903444
		bonustest004      Athena000UUS011903445
		david987          Athena000UUS011903536
		eunice032         Athena000UUS011903551
		eunice033         Athena000UUS011903554
		eunice034         Athena000UUS011903553
	
	Creator: Dominic@20190328
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

--13 affected rows
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
			( 28642949-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903369' --Username
				,'Athena000$david209' --Username2
				,10063439 --Recommend
				, 8500--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 29023866-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903372' --Username
				,'Athena000$eunice001' --Username2
				,10063439 --Recommend
				, 214.825--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 29028251-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903373' --Username
				,'Athena000$eunice002' --Username2
				,10063439 --Recommend
				, 548.65--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 29039400-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903376' --Username
				,'Athena000$eunice003' --Username2
				,10063439 --Recommend
				, 1250--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 29285885-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903420' --Username
				,'Athena000$bonustest001' --Username2
				,10063439 --Recommend
				, 215.865--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 29325481-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903444' --Username
				,'Athena000$bonustest003' --Username2
				,10063439 --Recommend
				, 113.36--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 29326016-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903445' --Username
				,'Athena000$bonustest004' --Username2
				,10063439 --Recommend
				, 111--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 29525790-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903520' --Username
				,'Athena000$davidnobonus' --Username2
				,10063439 --Recommend
				, 499.05--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 29911407-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903536' --Username
				,'Athena000$david987' --Username2
				,10063439 --Recommend
				, 10000--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 31803488-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903551' --Username
				,'Athena000$eunice032' --Username2
				,10063439 --Recommend
				, 3000--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 31807401-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903553' --Username
				,'Athena000$eunice034' --Username2
				,10063439 --Recommend
				, 5050.8--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 31823722-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903554' --Username
				,'Athena000$eunice033' --Username2
				,10063439 --Recommend
				, 11990.07--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting'),

			( 32554003-- CustID
				,GETDATE() --ArchivedDate
				,'Athena000UUS011903704' --Username
				,'Athena000$bonustest11' --Username2
				,10063439 --Recommend
				, 10000--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting')


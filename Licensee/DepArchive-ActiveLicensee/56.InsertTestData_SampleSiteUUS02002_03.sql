/*
	Creator: Dominic@20191113
	Task: Insert test data for following members SampleSiteUUS02002 (35668484) and SampleSiteUUS02003 (38599197)- Support #123721
	Run at: CustDB@DBCUST
*/
USE CustDB
GO

DECLARE @CustIDBalanceDummy INT
SELECT  @CustIDBalanceDummy = ISNULL(CustID,-1)
FROM Customer (NOLOCK)
WHERE recommend=35663073
AND username='SampleSiteUUS02ClearBal'
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
			( 35668484-- CustID
				,GETDATE() --ArchivedDate
				,'SampleSiteUUS02002' --Username
				,'SampleSite$test01_20190401_2' --Username2
				,35663073 --Recommend
				, 448.86--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting')

			, ( 38599197-- CustID
				,GETDATE() --ArchivedDate
				,'SampleSiteUUS02003' --Username
				,'SampleSite$test20190912' --Username2
				,35663073 --Recommend
				, 80--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting')


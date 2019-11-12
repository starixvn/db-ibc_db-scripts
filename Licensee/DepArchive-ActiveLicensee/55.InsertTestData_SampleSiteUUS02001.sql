/*
	Creator: Dominic@20191112
	Task: Insert test data for following members SampleSiteUUS02001 (35663571) - Support #123721
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
			( 35663571-- CustID
				,GETDATE() --ArchivedDate
				,'SampleSiteUUS02001' --Username
				,'SampleSite$test01_20190401' --Username2
				,35663073 --Recommend
				, 7298.20--ClosingBalance
				,@CustIDBalanceDummy --CustIDBalanceDummy
				,'waiting')


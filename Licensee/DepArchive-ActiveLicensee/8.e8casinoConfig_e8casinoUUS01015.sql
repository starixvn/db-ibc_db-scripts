/*
	Task: Insert archive config for e8casinoUUS01015 - Redmine #103644
	Creator: Dominic@20190110
	Run at: CustDB@DBCUST
*/
USE CustDB
GO

DECLARE @CustIDBalanceDummy INT
SELECT  @CustIDBalanceDummy = ISNULL(CustID,-1)
FROM Customer (NOLOCK)
WHERE recommend=27462580
AND username='e8casinoUUS01ClearBal'
AND roleid = 1

IF ISNULL(@CustIDBalanceDummy,-1) = -1
BEGIN
	SELECT 'The dedicated dummy account is missed!'
END

--4 affected rows
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
           (27574212 -- CustID
           ,GETDATE() --ArchivedDate
           ,'e8casinoUUS01015' --Username
           ,'e8casino$qatest15' --Username2
           ,27462580 --Recommend
           ,100000 --ClosingBalance
           ,@CustIDBalanceDummy --CustIDBalanceDummy
           ,'waiting')


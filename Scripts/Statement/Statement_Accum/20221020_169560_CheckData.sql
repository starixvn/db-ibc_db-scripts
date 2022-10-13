/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested="1"></info>*/
USE bodb_Report

--CREATE TABLE Statement_Accum_CheckData	
--(
--	[CustId] [int] NOT NULL,
--	[TotalAmt] [money] NULL,
--	IsFinished BIT DEFAULT 0
--)

--CREATE INDEX idx_Statement_Accum_CheckData ON Statement_Accum_CheckData(CustId)

--CREATE TABLE Statement_Accum_WrongBalance	
--(
--	[CustId] [int] NOT NULL,
--	[TotalAmt] [money] NULL,
--	[TotalAmt_Recal] [money]
--)

--DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
--INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
--EXEC bodb02.dbo.Age_SelBalanceUpDay

--DECLARE @BalanceUpDay SMALLDATETIME, @MoveBetsDay SMALLDATETIME
--SELECT  @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay FROM @MBBU

--INSERT INTO Statement_Accum_CheckData(CustId, TotalAmt)
--SELECT CustId, TotalAmt 
--FROM bodb_Report.dbo.Statement_Accum s WITH(NOLOCK)
--WHERE AccDate = @BalanceUpDay 

--Alter table  Statement_Accum_CheckData ADD MinAccDate DATETIME
--SELECT CustID , MIN(Accdate) MinAccDate
--Into #t
--FROM  Statement_Accum with(nolock)
--GROUP BY CustID

--UPDATE x.MinAccDate = t.MinAccDate
--FROM Statement_Accum_CheckData x
--INNER JOIN #t t ON x.CustID = t.CustID


--DROP TABLE #t

TRUNCATE TABLE Statement_Accum_WrongBalance_UAT

UPDATE Statement_Accum_CheckData_UAT with(rowlock)
SET MinAccDate = DATEADD(DAY, -14, MinAccDate), IsFinished = 0
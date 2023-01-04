/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	RUN at KBT@DB061/DB062
	Created: Bobby@20221226
	Task: Correct GEN data for Statement_Accum on BU [20221216]
	Redmine: https://nexdev.net/issues/169560
*/
USE [bodb02]
GO

DECLARE @RC int
DECLARE @FromDate smalldatetime = '2022-12-09 00:00:00'
DECLARE @ToDate smalldatetime = '2022-12-15 00:00:00'

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[SSIS_Statement_Accum_Export_bk] 
   @FromDate
  ,@ToDate
GO

-- report result to requester pls.
SELECT COUNT(1) AS [TotalRow], COUNT(DISTINCT custid) AS CustCount, SUM(TotalAmt) AS TotalAmt
FROM bodb_Report.dbo.Statement_Accum WITH(NOLOCK)
WHERE AccDate='2022-12-16 00:00:00'
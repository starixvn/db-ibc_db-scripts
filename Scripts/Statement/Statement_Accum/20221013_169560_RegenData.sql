/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20221013@Danny
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
*/

USE bodb_Report
GO

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-07-08 00:00:00', @ToDate = '2022-07-14 00:00:00'

/*
2022-07-15 00:00:00.0000000	2022-07-21 00:00:00.0000000	
2022-07-22 00:00:00.0000000	2022-07-28 00:00:00.0000000	
2022-07-29 00:00:00.0000000	2022-08-04 00:00:00.0000000	
2022-08-05 00:00:00.0000000	2022-08-11 00:00:00.0000000	
2022-08-12 00:00:00.0000000	2022-08-18 00:00:00.0000000	
2022-08-19 00:00:00.0000000	2022-08-25 00:00:00.0000000	
2022-08-26 00:00:00.0000000	2022-09-01 00:00:00.0000000
2022-09-02 00:00:00.0000000	2022-09-08 00:00:00.0000000	
2022-09-09 00:00:00.0000000	2022-09-15 00:00:00.0000000	
2022-09-16 00:00:00.0000000	2022-09-22 00:00:00.0000000	
2022-09-23 00:00:00.0000000	2022-09-29 00:00:00.0000000
*/

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-07-15 00:00:00', @ToDate = '2022-07-21 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-07-22 00:00:00', @ToDate = '2022-07-28 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-07-29 00:00:00', @ToDate = '2022-08-04 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-08-05 00:00:00', @ToDate = '2022-08-11 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-08-12 00:00:00', @ToDate = '2022-08-18 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-08-19 00:00:00', @ToDate = '2022-08-25 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-08-26 00:00:00', @ToDate = '2022-09-01 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-09-02 00:00:00', @ToDate = '2022-09-08 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-09-09 00:00:00', @ToDate = '2022-09-15 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-09-16 00:00:00', @ToDate = '2022-09-22 00:00:00'

--INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
--EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-09-23 00:00:00', @ToDate = '2022-09-29 00:00:00'

INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
EXEC bodb02.dbo.SSIS_Statement_Accum_Export_bk @FromDate = '2022-09-30 00:00:00', @ToDate = '2022-10-06 00:00:00'

/*
DECLARE @Max_AccDate DATETIME, @FromDate DATETIME, @ToDate DATETIME

SELECT @Max_AccDate = MAX(accDate) FROM dbo.Statement_Accum WITH(NOLOCK)

DECLARE @BUDates TABLE (BUDate DATETIME, ID INT Identity (1,1))
INSERT INTO @BUDates(BUDate)
SELECT AccDate FROM dbo.Statement WITH(NOLOCK)
WHERE CustID = 3 AND accdate > @Max_AccDate AND transtype = 'BAL'
ORDER BY AccDate ASC

DECLARE @BalanceDATE TABLE (FromDate DATETIME, ToDate DATETIME, ID INT)

; WITH t AS
(
	SELECT @Max_AccDate AS FromDate, DATEADD(DAY, -1, BUDate) AS ToDate, ID
	FROM @BUDates
	WHERE ID = 1
	UNION ALL
	SELECT DATEADD(DAY, 1, t.Todate),  DATEADD(DAY, -1, bu.BUDate) AS ToDate, bu.ID
	FROM t
	INNER JOIN @BUDates bu ON t.ID = bu.ID - 1
)

INSERT INTO @BalanceDate (FromDate, ToDate, ID)
SELECT FromDate, ToDate, ID FROM t

DECLARE @i INT  = 1 , @__fdate SMALLDATETIME, @__tdate SMALLDATETIME
WHILE EXISTS (SELECT TOP 1 1 FROM  @BalanceDATE WHERE ID = @i)
BEGIN
	SELECT @__fdate = FromDate,  
			@__tdate = ToDate
	FROM @BalanceDate WHERE ID = @i

	INSERT INTO Statement_Accum (CustId,AccDate,TotalAmt)
	EXEC dbo.SSIS_Statement_Accum_Export_bk @FromDate = @__fdate, @ToDate = @__tdate

	SELECT @i = @i+ 1

	WAITFOR DELAY '00:00:15' --15s

END
*/
	



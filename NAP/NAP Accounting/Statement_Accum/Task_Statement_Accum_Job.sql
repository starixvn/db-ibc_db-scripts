/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[Task_Statement_Accum_Job]
AS

/*
	Created: 20220421@Percy
	DB: DBRPT-bodb_Report
	Task: Statement_Accum - Generate data

	Revisions:
		- 20220421@Percy: Initialize SP [RedmineID: #102322]
*/

BEGIN
	SET NOCOUNT ON

	DECLARE @FromCreatedDate DATE, @ToCreatedDate DATE
	DECLARE @CustIds VARCHAR(MAX), @StartAccDate DATETIME
	DECLARE @i INT, @n INT, @batch INT = 1000

	WHILE 1 = 1
	BEGIN
		SET @FromCreatedDate = NULL
		SELECT @FromCreatedDate = MIN(CreatedDate) FROM dbo.Cust_Statement WITH (NOLOCK) WHERE IsFinished = 0
		SELECT @ToCreatedDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @FromCreatedDate) + 1, 0)) -- get end of month

		IF @FromCreatedDate IS NULL
			BREAK

		SELECT @StartAccDate = CASE WHEN @FromCreatedDate < '2011-12-31' THEN '2011-12-31' ELSE @FromCreatedDate END

		-- Get cust list
		SELECT @i = 1, @n = COUNT(1) FROM dbo.Cust_Statement WITH (NOLOCK) WHERE CreatedDate BETWEEN @FromCreatedDate AND @ToCreatedDate AND IsFinished = 0
		SET @n = @n/@batch + 1
		
		WHILE 1 = 1
		BEGIN
			SET @CustIds = NULL
			;WITH CTE_CustId AS (SELECT TOP (@batch) CustId FROM dbo.Cust_Statement WITH (NOLOCK) WHERE CreatedDate BETWEEN @FromCreatedDate AND @ToCreatedDate AND IsFinished = 0)
			SELECT @CustIds = COALESCE(@CustIds + ',', '') + CONVERT(VARCHAR(20), CustId) FROM CTE_CustId

			IF ISNULL(@CustIds, '') = ''
				BREAK

			PRINT ('Start Customers with CreatedDate = ' + CONVERT(VARCHAR(10), @ToCreatedDate, 120) + ', batch ' + CONVERT(VARCHAR(10), @i) + ' / ' + CONVERT(VARCHAR(10), @n))

			EXEC dbo.Task_Statement_Accum @CustIds = @CustIds, @StartAccDate = @StartAccDate
			-- this SP will update IsFinished = 1

			SET @i = @i + 1
		END

		WAITFOR DELAY '00:00:00.003'
	END
END
GO
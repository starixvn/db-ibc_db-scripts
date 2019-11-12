/*
	Task: Reactivate dormant members that have tickets of GD and AG within the last 3 years - https://nexdev.net/issues/110714
	Creator: Dominic@20190322
	Run at: CustDB@DBCUST
*/
USE CustDB

CREATE TABLE #CustID(CustID INT, IsExecuted BIT)


SELECT * 
INTO #TMP1
FROM OPENQUERY(DB052,'SELECT DISTINCT c.CustID 
FROM [bodb_PlaytechCS].[dbo].[bettrans_AGCasino] b (NOLOCK)
INNER JOIN bodb02.dbo.Dep_Customer_Archived c (NOLOCK) ON b.CustID=c.CustID
WHERE ArchivedDate >= ''20190101''
AND c.status=''completed''
AND ABS(DATEDIFF(DAY,Winlostdate,ArchivedDate)) <= 1095')



SELECT * 
INTO #TMP2
FROM OPENQUERY(DB052,'SELECT DISTINCT c.CustID 
FROM [bodb_PlaytechCS].[dbo].[bettrans_GoldDeluxe] b (NOLOCK)
INNER JOIN bodb02.dbo.Dep_Customer_Archived c (NOLOCK) ON b.CustID=c.CustID
WHERE ArchivedDate >= ''20190101''
AND c.status=''completed''
AND ABS(DATEDIFF(DAY,transdate,ArchivedDate)) <= 1095')


INSERT INTO #CustID(CustID,IsExecuted) 
SELECT CustID,0
FROM [dbo].[Dep_Customer_Archived] (NOLOCK)
WHERE CustID IN (
	SELECT CustID
	FROM #TMP1
	UNION ALL
	SELECT CustID
	FROM #TMP2
) AND Status = 'completed'

CREATE UNIQUE CLUSTERED INDEX IX_Cust ON #CustID(CustID)

DECLARE @CustID INT

WHILE EXISTS(SELECT 1 FROM #CustID WHERE IsExecuted=0)
BEGIN
	UPDATE TOP(1) t
	SET IsExecuted=1
		,@CustID=CustID
	FROM #CustID t
	WHERE IsExecuted=0

	IF NOT EXISTS(SELECT 1 FROM Customer (NOLOCK) WHERE CustID=@CustID)
	BEGIN
		EXEC [Dot_Dep_Customer_Archive_ReactiveCustomer] @CustID  = @CustID
		WAITFOR DELAY '00:00:00.030'
	END
	
END

DROP TABLE #CustID
 

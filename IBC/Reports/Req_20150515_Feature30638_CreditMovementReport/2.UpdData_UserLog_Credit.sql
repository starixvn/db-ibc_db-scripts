USE [bodb_CustomerLog]
---update data from the beginning of last month to today
DECLARE @MINDATE DATETIME, @MAXDATE DATETIME

SELECT @MAXDATE = GETDATE() 
SELECT @MINDATE = DATEADD (MM, -2 , DATEADD(mm, DATEDIFF(mm,0,@MAXDATE), 0) )  
  
  
----Get Exchange Rate

DECLARE @ExchangeDaily TABLE(ExchangeDate SMALLDATETIME, ExchangeId INT, Actualrate FLOAT)
	
INSERT INTO @ExchangeDaily (Exchangedate, ExchangeId, Actualrate)
SELECT Exchangedate, exchangeid, Actualrate
FROM bodb02.dbo.Lrf_f_GetExchangeDaily( @MINDATE, @MAXDATE)

----Update ActualRate by Date
 
 DECLARE @Date DATE
 SELECT @Date = @MINDATE
  
WHILE @Date < @MAXDATE + 1
BEGIN 

	UPDATE	L 
	SET		L.ActualRate = ED.Actualrate
	FROM	bodb_CustomerLog.dbo.UserLog_Credit L WITH (NOLOCK)		
			INNER JOIN bodb02.dbo.Customer C WITH (NOLOCK) 
				ON  C.CustID = L.CustId 		
			INNER JOIN @ExchangeDaily ED 
				ON	ED.ExchangeId = C.Currency 
					AND ED.ExChangeDate = DATEADD(dd, 1, DATEDIFF(dd, 1, L.LogDate))
	WHERE ISNULL(L.ActualRate,0) = 0

	PRINT  @Date 
	SELECT @Date = DATEADD (dd, 1, @Date)
	
END
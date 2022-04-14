/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20220413@Sol
	Task: re-gen data by insert into TicketVoiding_RoutineTasks table - [Redmine: #171415] 
	DB: DBTXN-bodb02
*/ 
 
USE bodb02;

GO 

DECLARE @AffectedList VARCHAR(MAX)
CREATE TABLE #tbl (Custid INT, Winlostdate SMALLDATETIME)
CREATE CLUSTERED INDEX CX_Order ON #tbl(winlostdate, custid) --for winlostdate in order only

DECLARE @bettype SMALLINT, @winlostdate SMALLDATETIME

SELECT @bettype = 4599, @winlostdate = '20220407'

;WITH rs AS
(
	SELECT DISTINCT b.custid, b.winlostdate 
	FROM bettransrng14 b WITH(NOLOCK)
	WHERE b.gameID  = @bettype and b.winlostdate >= @winlostdate
)
INSERT INTO #tbl(custid, winlostdate) -- 37 rows affected
SELECT custid, winlostdate FROM rs

SET @AffectedList = CAST((
		SELECT CustId AS '@c'
				,WinlostDate AS '@w'
		FROM #tbl 
		GROUP BY CustId
				,WinlostDate
		FOR XML PATH('r'), ROOT('root'), TYPE
	) AS VARCHAR(MAX))

--output to review
SELECT @AffectedList

EXEC dbo.TicketVoiding_Admin_Bet14_RoutineTask_Insert @AffectedList = @AffectedList

DROP TABLE #tbl
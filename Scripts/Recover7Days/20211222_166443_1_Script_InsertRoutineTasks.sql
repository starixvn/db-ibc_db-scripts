/*<info serverAlias="DBTXN-bodb02" executers="" viewers="" isFunction="0"></info>*/
USE bodb02
GO

/*
Create: 20221222@Sophia
Task:  Insert data into queue TicketVoiding_RoutineTasks [redmine: 166443]
DB: DBTXN-bodb02
*/

CREATE TABLE #TicketVoiding_RoutineTasks (custid INT, winlostdate SMALLDATETIME)
INSERT INTO #TicketVoiding_RoutineTasks (custid, winlostdate)
VALUES (56475760,'2021-12-14 0:00:00'),
(56475760,'2021-12-14 0:00:00'),
(53634893,'2021-12-15 0:00:00'),
(58703902,'2021-12-15 0:00:00'),
(33655935,'2021-12-15 0:00:00'),
(56475760,'2021-12-15 0:00:00')

DECLARE @AffectedList		VARCHAR(MAX)
SET @AffectedList = CAST((
	SELECT	CustId AS '@c'
			,WinlostDate AS '@w'
	FROM	#TicketVoiding_RoutineTasks 
	GROUP BY CustId
			,WinlostDate
	FOR XML PATH('r'), ROOT('root'), TYPE
) AS VARCHAR(MAX))

-- insert routine task
EXEC dbo.TicketVoiding_Admin_Bet14_RoutineTask_Insert 
	@AffectedList = @AffectedList
 

 Select * from TicketVoiding_RoutineTasks WITH (NOLOCK)  where Status <> 2
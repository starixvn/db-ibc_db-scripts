/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20220608@Sol
	Task: re-gen data by insert into TicketVoiding_RoutineTasks table - [Redmine: #173876] 
	DB: DBTXN-bodb02
*/ 
 
USE bodb02;

GO 

DECLARE @AffectedList VARCHAR(MAX)

SET @AffectedList = CAST((
		SELECT CustId AS '@c'
				,WinlostDate AS '@w'
		FROM 
			(
				VALUES (52210028, '2022-06-01')
			) AS t (custid, winlostdate)
		FOR XML PATH('r'), ROOT('root'), TYPE
	) AS VARCHAR(MAX))

--output to review
SELECT @AffectedList

EXEC dbo.TicketVoiding_Admin_Bet14_RoutineTask_Insert @AffectedList = @AffectedList

GO
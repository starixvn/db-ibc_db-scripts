/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20230612@Evan
	DB: DBTXN-bodb02
	Task: Update status of step is running in TicketVoiding_RoutineTasks 
	https://nexdev.net/issues/189234
*/
USE bodb02;

GO 
	--Select * from TicketVoiding_RoutineTasks (NOLOCK) where  status= 3 and  RequestID >= 40
	UPDATE a 
	SET Status= 0
	FROM TicketVoiding_RoutineTasks a WITH (ROWLOCK)
	WHERE Status= 3 and  RequestID >= 40

GO
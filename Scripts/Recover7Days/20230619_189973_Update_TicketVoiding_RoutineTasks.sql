/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Created: 20230619@Sophia
	DB: DBTXN-bodb02
	Task: Update status of step is running in TicketVoiding_RoutineTasks : Redmine :189973 
 
*/
USE bodb02;

GO 
	--Select * from TicketVoiding_RoutineTasks (NOLOCK) where  status= 3 and  RequestID >= 83
	UPDATE a 
	SET Status= 0
	FROM TicketVoiding_RoutineTasks a WITH (ROWLOCK)
	WHERE Status= 3 and  RequestID >= 83

GO
/*<info serverAlias="DBTXN-bodb02"></info>*/

/*
Create: 20221220@Sophia
Task: Update status of core table (TicketVoiding_RoutineTasks) to continue reGen data step 6 7 8   [Redmine: #166294] 
DB: DBTXN-bodb02

*/ 
USE bodb02
GO

UPDATE TicketVoiding_RoutineTasks WITH (ROWLOCK)
SET Status = 2
WHERE ID = 125 AND RequestID = 16 

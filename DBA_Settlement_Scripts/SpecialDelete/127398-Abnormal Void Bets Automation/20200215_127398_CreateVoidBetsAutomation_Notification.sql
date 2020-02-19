/*	Created by: Helen
	Date 20200219
	Task:Auto void notification [Redmine: #128359]
	DB: DBTXN/bodb02 - Add one more step on the job vndba:Check slowly parlay settlement, calling SP
*/
USE bodb02
GO
EXEC TicketVoiding_AutoVoid_Notification_Job
GO
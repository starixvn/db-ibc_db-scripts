/*	Created by: Max
	Date 20200227
	Task: Auto Void Winning Bets - [Redmine: #129184]
	DB: DBTXN/bodb02
	
	- Add one step as first step into the job name "bodb02 : TicketVoiding - VoidBets Automation" on DBTRANS - [VIEW]
	- Adjust waitfor delay 00:00:45 in the last step

*/
USE bodb02
GO
EXEC dbo.TicketVoiding_AutoMarkProblemAccount_Job
GO


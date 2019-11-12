/*
	Task: Archive Dormant Licensee - Increase the batch size of ClearBal job - Support #107171
	Run at: MSDB@DBTRANS
	Creator: Dominic@20190121
	Task: Update the 1st step of SQL job "Archive Deposit Member - Step 2: Clear Balance and CustInfo"
				to clear balance at 200-member batches

*/
USE MSDB
GO

EXEC MSDB.DBO.SP_UPDATE_JOBSTEP @JOB_NAME = 'Archive Deposit Member - Step 2: Clear Balance and CustInfo'
              ,@STEP_ID = 1
              ,@COMMAND = 'Exec bodb02.dbo.Task_Dep_Cust_Archive_Clear_Balance @BatchSize=200'
/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

/*
	Created: 20201102@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Golive feature
*/

USE msdb ;  
GO  
---- Step 1: STOP JOB
-- Job orig
EXEC dbo.sp_stop_job   N'bodb_RMS: Copy tickets to rmBettrans';  
EXEC dbo.sp_stop_job   N'bodb_RMS: Copy & Sum Data';  
EXEC dbo.sp_stop_job   N'bodb_RMS: Check Sum & Delete Data';  

-- Job uat
EXEC dbo.sp_stop_job   N'bodb_RMS: Copy parlay tickets to rmBettrans';  
EXEC dbo.sp_stop_job   N'bodb_RMS: Copy & Sum Data MBU';  
EXEC dbo.sp_stop_job   N'bodb_RMS: MBU Check Sum & Delete Data';  

GO  

----- STEP 2: Rename table

-- Rename table original to bk
EXEC sp_rename 'dbo.rmBettrans', 'rmBettrans_bk';  
EXEC sp_rename 'dbo.rmSumWinloss', 'rmSumWinloss_bk';  
EXEC sp_rename 'dbo.rmSumWinloss_Old', 'rmSumWinloss_Old_bk';  

-- Rename table UAT to original
EXEC sp_rename 'dbo.rmBettrans_UAT', 'rmBettrans';  
EXEC sp_rename 'dbo.rmSumWinloss_UAT', 'rmSumWinloss';  
EXEC sp_rename 'dbo.rmSumWinloss_Old_UAT', 'rmSumWinloss_Old';  


---- STEP 3: Deploy SP job


---- STEP 4: Deploy SP report


----- STEP 5: Start job

EXEC dbo.sp_start_job   N'bodb_RMS: Copy parlay tickets to rmBettrans';  
EXEC dbo.sp_start_job   N'bodb_RMS: Copy & Sum Data MBU';  
EXEC dbo.sp_start_job   N'bodb_RMS: MBU Check Sum & Delete Data';  







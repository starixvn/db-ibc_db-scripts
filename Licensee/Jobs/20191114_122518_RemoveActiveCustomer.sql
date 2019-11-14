/*
Create: 20191114@Sophia
Task: remove step 'Gen data for Active Customer Report @bodb_LicenseeReport' [redmine: #122518]
DB: DBLIC
*/
	    
USE msdb ;  
GO  
 
EXEC dbo.sp_delete_jobstep  
    @job_name = N'bodb_LicenseeReport: DW - Generate Daily',
	@step_id = 9
   ---@step_name=N'Gen data for Active Customer Report @bodb_LicenseeReport'
GO   
 
 
EXEC sp_update_jobstep      @job_name = N'bodb_LicenseeReport: DW - Generate Daily',  @step_id=8, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0
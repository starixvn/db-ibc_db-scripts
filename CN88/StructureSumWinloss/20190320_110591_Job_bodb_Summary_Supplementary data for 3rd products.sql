USE [msdb]
GO
/*

Created: 20190320@Sophia 
Task: add Gen data to CS_Sum_Winloss and CS_Sum_Cancelled   [redmine: #110591]
*/



EXEC sp_update_jobstep       
     @job_name = 'bodb_Summary: Supplementary data for 3rd products' 
	 , @step_id = 2  
    ,@on_success_action = 3
    ,@on_success_step_id =0


EXEC sp_add_jobstep    
	 @job_name =  'bodb_Summary: Supplementary data for 3rd products'   
      ,  @step_id =  3   
      ,  @step_name = 'Gen data from CS_Sum_Winloss table'  
      ,  @subsystem =  'TSQL'    
      ,  @command =  'EXEC dbo.Task_DailyRptCS_SumWinloss_Job'    
      ,  @cmdexec_success_code =  0 
      ,  @on_success_action =3  
	  ,  @on_success_step_id = 0 
      ,  @on_fail_action = 2
	  ,  @on_fail_step_id = 0     
      , @database_name =  'bodb_Summary'     
	  , @retry_attempts=0 
	  , @retry_interval=0 
      , @os_run_priority = 0 
      , @flags  = 0


EXEC sp_add_jobstep     
		@job_name =  'bodb_Summary: Supplementary data for 3rd products'   
      ,  @step_id =  4   
      ,  @step_name = 'Gen data from CS_Sum_Cancelled table'  
      ,  @subsystem =  'TSQL'    
      ,  @command =  'EXEC dbo.Task_DailyRptCS_SumCancelled_Job'    
      ,  @cmdexec_success_code =  0 
      ,  @on_success_action =1  
	  ,  @on_success_step_id = 0 
      ,  @on_fail_action = 2
	  ,  @on_fail_step_id = 0     
      , @database_name =  'bodb_Summary'     
	  , @retry_attempts=0 
	  , @retry_interval=0 
      , @os_run_priority = 0 
      , @flags  = 0



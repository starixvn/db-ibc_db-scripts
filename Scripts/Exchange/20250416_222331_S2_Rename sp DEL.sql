/*<info serverAlias="DBEXT-bodb02"></info>*/

/*
	Created by: 20250416@Kelvin
	DB: DBEXT-bodb02
	Task: Enhance ExchangeDailyOANDA job - Check & Correct [RedmineID: #222331]
*/

GO

--DB053/DB052
--=====================================================================================================================================
USE bodb02

GO
SP_RENAME 'Task_Acc_ExchangeDaily_Check','DEL_Task_Acc_ExchangeDaily_Check'

--=====================================================================================================================================

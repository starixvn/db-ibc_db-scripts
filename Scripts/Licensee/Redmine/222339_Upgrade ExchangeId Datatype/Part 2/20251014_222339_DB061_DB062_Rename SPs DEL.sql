/*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Created: 20251014@Kelvin
	DB: DBACC-bodb02
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

--DB061/DB062
USE bodb02
GO
sp_rename 'Task_DOT_dep_DailySummary_TST','DEL_Task_DOT_dep_DailySummary_TST'
GO
sp_rename 'Task_DOT_dep_DailySummary_TST_Ag','DEL_Task_DOT_dep_DailySummary_TST_Ag'
GO
sp_rename 'Task_DOT_dep_DailySummary_TST_bk_Ag','DEL_Task_DOT_dep_DailySummary_TST_bk_Ag'
GO
sp_rename 'Task_DOT_dep_DailySummary_TST14','DEL_Task_DOT_dep_DailySummary_TST14'
GO
sp_rename 'Task_DOT_dep_DailySummary_TST14_Ag','DEL_Task_DOT_dep_DailySummary_TST14_Ag'

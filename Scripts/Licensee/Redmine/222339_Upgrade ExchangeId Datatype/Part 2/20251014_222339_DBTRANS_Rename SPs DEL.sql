/*<info serverAlias="DBCTG-bodb02"></info>*/
/*
	Created: 20251014@Kelvin
	DB: DBCTG-bodb02
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

--DBTRANS
USE bodb02
GO
sp_rename 'Task_Dep_AdjustData3rdProduct_tmp','DEL_Task_Dep_AdjustData3rdProduct_tmp'
GO
sp_rename 'Task_Dep_AdjustHistoricalData3rdProduct','DEL_Task_Dep_AdjustHistoricalData3rdProduct'
GO
sp_rename 'Task_Dep_SumHistoryData3rdProduct','DEL_Task_Dep_SumHistoryData3rdProduct'


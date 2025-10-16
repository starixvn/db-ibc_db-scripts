/*<info serverAlias="DBSID-bodb02"></info>*/
/*
	Created: 20251014@Kelvin
	DB: DBSID-bodb02
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

--DBGRP01L/DBGRP02L
USE bodb02
GO
sp_rename 'SiteDB_Lrf_Rpt_WinLoss','DEL_SiteDB_Lrf_Rpt_WinLoss'
GO
sp_rename 'Task_Dep_AdjustData3rdProduct_tmp','DEL_Task_Dep_AdjustData3rdProduct_tmp'
GO
sp_rename 'Task_Dep_AdjustHistoricalData3rdProduct','DEL_Task_Dep_AdjustHistoricalData3rdProduct'
GO
sp_rename 'Task_Dep_SumHistoryData3rdProduct','DEL_Task_Dep_SumHistoryData3rdProduct'


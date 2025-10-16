/*<info serverAlias="DBSIC-bodb02"></info>*/
/*
	Created: 20251014@Kelvin
	DB: DBSIC-bodb02
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

--DBGRP03L
USE bodb02
GO
sp_rename 'Task_Dep_DailySum_OddsAdjustment','DEL_Task_Dep_DailySum_OddsAdjustment'


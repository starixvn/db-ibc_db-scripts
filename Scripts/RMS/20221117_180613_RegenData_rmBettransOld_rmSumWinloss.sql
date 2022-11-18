/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

/*
	Created: 20221117@Danny
	DB: DBRMS.bodb_RMS
	Task: Regen data

*/

USE bodb_RMS ;  

-- Regen rmBettrans_Old
EXEC Task_RMS_MBU_CheckSumData_rmBettrans_Old @winlostdate = '2022-11-08'
EXEC Task_RMS_MBU_CheckSumData_rmBettrans_Old @winlostdate = '2022-11-09'
EXEC Task_RMS_MBU_CheckSumData_rmBettrans_Old @winlostdate = '2022-11-13'


-- Regen rmSumWinloss
EXEC Task_RMS_MBU_CheckSumData_rmSumWinloss @winlostdate = '2022-11-08'
EXEC Task_RMS_MBU_CheckSumData_rmSumWinloss @winlostdate = '2022-11-09'
EXEC Task_RMS_MBU_CheckSumData_rmSumWinloss @winlostdate = '2022-11-13'
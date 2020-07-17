/*<info serverAlias="DBTXN-bodb02"></info>*/

/*
Create: 20200717@Sophia
Task: ReGen Data of Sum_Winloss_Old - wrong netStake [Redmine: #137604] 
DB: DBTXN.bodb02

*/

use bodb02
GO

EXEC  Task_sum_winloss_14  '2020-07-06 00:00:00', '23725035'
EXEC  Task_sum_winloss_14  '2020-07-07 00:00:00', '33120673, 44091311'
/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
USE bodb_RMS
-- Remove data test

--DELETE FROM  rmUserTrackingLog WITH (ROWLOCK, UPDLOCK)
--WHERE username IN ('starix83', 'starix24')

DROP TABLE DEL_rmBettrans
DROP TABLE DEL_rmSumWinloss
DROP TABLE DEL_rmSumWinloss_Old
DROP TABLE rmBettrans_Old_UAT

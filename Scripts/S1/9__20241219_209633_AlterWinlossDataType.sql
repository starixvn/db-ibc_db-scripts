/*<info serverAlias="DBAGE-bodb02"></info>*/
/*
	Created: 20240923@Danny
	DB: DBAGE.bodb02
	Task: Add new WhiteLableWinloss table RedmineId #209633
*/
USE bodb02
GO

ALTER TABLE WhiteLabelWinloss ALTER COLUMN Winloss DECIMAL(20,6);

ALTER TABLE WhiteLabelWinloss_History ALTER COLUMN OldWinloss DECIMAL(20,6);
ALTER TABLE WhiteLabelWinloss_History ALTER COLUMN NewWinloss DECIMAL(20,6);





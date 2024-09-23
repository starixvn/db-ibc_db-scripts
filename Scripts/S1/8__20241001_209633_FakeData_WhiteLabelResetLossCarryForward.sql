/*<info serverAlias="DBAGE-bodb02"></info>*/
/*
	Created: 20240923@Danny
	DB: DBAGE.bodb02
	Task: Add new WhiteLableWinloss table RedmineId #209633
*/
USE bodb02

INSERT INTO  WhiteLabelResetLossCarryForward(CustID,	YearMonth,	IsDisabled,	RepUpdateTime) VALUES (169660506, '2024-08-01', 0, GETDATE())
INSERT INTO  WhiteLabelResetLossCarryForward(CustID,	YearMonth,	IsDisabled,	RepUpdateTime) VALUES (169659405, '2024-09-01', 0, GETDATE())

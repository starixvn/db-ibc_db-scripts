/*<info serverAlias="DBAGE-bodb02"></info>*/
/*
	Created: 20240923@Danny
	DB: DBAGE.bodb02
	Task: Add new WhiteLabelResetLossCarryForward table RedmineId #209633
*/
USE bodb02

GO
CREATE TABLE [dbo].[WhiteLabelResetLossCarryForward](
	[CustID] [int] NULL,
	[YearMonth] [smalldatetime] NULL,
	[IsDisabled] [bit] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
) ON [DATA]











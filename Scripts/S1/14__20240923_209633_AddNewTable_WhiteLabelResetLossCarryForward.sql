/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20240923@Danny
	DB: DBCUST.CustDB
	Task: Add new WhiteLabelResetLossCarryForward table RedmineId #209633
*/

GO
CREATE TABLE [dbo].[WhiteLabelResetLossCarryForward](
	[CustID] [int] NULL,
	[YearMonth] [smalldatetime] NULL,
	[IsDisabled] [bit] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
) ON [DATA]











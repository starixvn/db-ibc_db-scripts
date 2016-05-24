USE bodb_RMS
GO
SET NOCOUNT ON

ALTER TABLE [dbo].[rmBettrans]
ADD TotalBet INT

ALTER TABLE [dbo].[rmTransaction]
ADD selection TINYINT

ALTER TABLE [dbo].[rmSumWinloss]
ADD [IsMixParlay] BIT

ALTER TABLE [dbo].[rmSumWinloss_OLD]
ADD [IsMixParlay] BIT
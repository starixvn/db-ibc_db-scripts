/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20240223@Bobby
	Task: 172604 - LAP - Winloss Analysis - Add Job steps
	DB: DBLIC.msdb
	Remark: Set up on SIT
*/

USE [bodb_LicenseeReport]
GO

CREATE NONCLUSTERED INDEX [IX_CustID] ON [dbo].[rptLicenseeWinloss]
(
	[CustId] ASC,
	[WinlostDate] ASC
)
GO

CREATE CLUSTERED COLUMNSTORE INDEX [CCI_rptLicenseeWinloss] ON [dbo].[rptLicenseeWinloss] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)

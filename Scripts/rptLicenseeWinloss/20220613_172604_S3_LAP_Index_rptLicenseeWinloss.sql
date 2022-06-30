/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20220630@Sophia
	DB: DB053-bodb_LicenseeReport
	Task: index on rptLicenseeWinloss [Redmine: #172604]
	Step 3: Index
*/

 
USE [bodb_LicenseeReport]
GO

/****** Object:  Index [CIX_rptLicenseeWinloss]    Script Date: 6/30/2022 9:01:26 AM ******/
CREATE CLUSTERED INDEX [CIX_rptLicenseeWinloss] ON [dbo].[rptLicenseeWinloss]
(
	[WinlostDate] ASC,
	[Recommend] ASC,
	[Sporttype] ASC,
	[Bettype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
GO


-------------


/****** Object:  Index [IX_CustID]    Script Date: 6/30/2022 9:01:32 AM ******/
CREATE NONCLUSTERED INDEX [IX_CustID] ON [dbo].[rptLicenseeWinloss]
(
	[WinlostDate] ASC,
	[CustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
GO



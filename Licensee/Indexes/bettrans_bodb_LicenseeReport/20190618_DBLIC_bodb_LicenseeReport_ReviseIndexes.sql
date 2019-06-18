USE [bodb_LicenseeReport]
GO

/*
	Created: 20190618@Percy
	DB: DB052.bodb_LicenseeReport, DB053.bodb_LicenseeReport, DB054.bodb_LicenseeReport
	Task: Indexes on bettrans (bodb_LicenseeReport)
		1. Include column [refno] into index: [IX_winlostdate_bettype_currency]
		2. New index on column [custid]
*/

CREATE NONCLUSTERED INDEX [IX_winlostdate_bettype_currency] ON [dbo].[bettrans]
(
	[winlostdate] ASC,
	[bettype] ASC,
	[currency] ASC
)
INCLUDE ( 	[liveindicator],
	[customercategory],
	[custid],
	[stake],
	[winlost],
	[actual_stake],
	[awinlost],
	[mwinlost],
	[swinlost],
	[playercomm],
	[comm],
	[acomm],
	[scomm],
	[virtualrate],
	[isBA],
	[statusid],
	[matchid],
	[recommend],
	[refno]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [LicenseeReport_Staging_Data]
GO


CREATE NONCLUSTERED INDEX [IX_custid] ON [dbo].[bettrans]
(
	[custid] ASC
)
INCLUDE ( 	[winlostdate],
	[bettype],
	[refno],
	[winlost],
	[awinlost]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [LicenseeReport_Staging_Data]
GO
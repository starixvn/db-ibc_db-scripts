/*<info serverAlias="DBSIC-bodb02,DBCTG-bodb02,DBAGE-bodb02,DBACC-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: DBSIC-bodb02,DBCTG-bodb02,DBAGE-bodb02,DBACC-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/
CREATE NONCLUSTERED INDEX [IX_SabaWalletTicket_CustID] ON [dbo].[SabaWalletTicket]
(
	CustID ASC
	, WinlostDate ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON Transfer_Index
GO
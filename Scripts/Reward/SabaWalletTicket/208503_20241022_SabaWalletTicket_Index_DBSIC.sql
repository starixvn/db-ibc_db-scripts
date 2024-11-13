/*<info serverAlias="DBSIC-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: DBSIC-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/
CREATE NONCLUSTERED INDEX [IX_SabaWalletTicket_Recommend_WinlostDate]  ON dbo.SabaWalletTicket
(
	Recommend ASC
	, WinlostDate ASC
) ON Transfer_Index
go

CREATE NONCLUSTERED INDEX [IX_SabaWalletTicket_Mrecommend_WinlostDate]  ON dbo.SabaWalletTicket
(
	Mrecommend ASC
	, WinlostDate ASC
) ON Transfer_Index
go

CREATE NONCLUSTERED INDEX [IX_SabaWalletTicket_Srecommend_WinlostDate]  ON dbo.SabaWalletTicket
(
	Srecommend ASC
	, WinlostDate ASC
) ON Transfer_Index
go

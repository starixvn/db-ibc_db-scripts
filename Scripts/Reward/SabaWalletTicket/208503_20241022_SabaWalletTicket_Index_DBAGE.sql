/*<info serverAlias="DBAGE-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: DBAGE-bodb02
	Task: Index for DBAGE [RedmineID: #208503]
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

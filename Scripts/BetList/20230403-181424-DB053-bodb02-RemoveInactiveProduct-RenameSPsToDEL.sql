/*<info serverAlias="DB053-bodb02"></info>*/
/*
	Created : 20230403@Kos
	DB: DB053-bodb02
	Task: Rename SPs to DEL_ and drop test version [RedmineID: #181424]
*/

USE [bodb02]
GO

sp_rename 'Lrf_BetList_CB_Detail', 'DEL_Lrf_BetList_CB_Detail'
GO

sp_rename 'Lrf_BetList_SelByDayAll_Mem', 'DEL_Lrf_BetList_SelByDayAll_Mem'
GO

sp_rename 'Lrf_BetList_SelDeleted', 'DEL_Lrf_BetList_SelDeleted'
GO

sp_rename 'Lrf_BetList_SelDeleted_UserList', 'DEL_Lrf_BetList_SelDeleted_UserList'
GO

sp_rename 'Lrf_BetList_SelWinlossDaily', 'DEL_Lrf_BetList_SelWinlossDaily'
GO

DROP PROCEDURE dbo.Lrf_BetList_CB_Detail_UAT1
GO

DROP PROCEDURE dbo.Lrf_BetList_CB_Detail_xpre
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_UAT1
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_UAT2
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_UAT3
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_xpre
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_xtest
GO



/*<info serverAlias="DB061-bodb02"></info>*/
/*
	Created : 20230403@Kos
	DB: DB061-bodb02
	Task: Rename SPs to DEL_ and drop test version [RedmineID: #181424]
*/

USE [bodb02]
GO

sp_rename 'Lrf_BetList_CustomerList_Mem', 'DEL_Lrf_BetList_CustomerList_Mem'
GO

sp_rename 'Lrf_BetList_SelByDayAll_Mem_Old', 'DEL_Lrf_BetList_SelByDayAll_Mem_Old'
GO

sp_rename 'Lrf_BetList_SelWinLossRacingByDate_Mem', 'DEL_Lrf_BetList_SelWinLossRacingByDate_Mem'
GO

sp_rename 'Lrf_BetList_SelWinlostRacing', 'DEL_Lrf_BetList_SelWinlostRacing'
GO

sp_rename 'Lrf_BetList_WinlostByLeague_Mem', 'DEL_Lrf_BetList_WinlostByLeague_Mem'
GO

sp_rename 'Lrf_BettransSelBetSlip_Old', 'Lrf_BettransSelBetSlip_Old'
GO


DROP PROCEDURE dbo.Lrf_BetList_CustomerList_Mem_UAT1
GO

DROP PROCEDURE dbo.Lrf_BetList_CustomerList_Mem_UAT2
GO

DROP PROCEDURE dbo.Lrf_BetList_CustomerList_Mem_UAT3
GO

DROP PROCEDURE dbo.Lrf_BetList_CustomerList_Mem_xpre
GO

DROP PROCEDURE dbo.Lrf_BetList_CustomerList_Mem_xtest
GO

DROP PROCEDURE dbo.Lrf_BetList_MobileReport_SelWinloss_Mem_xpre
GO

DROP PROCEDURE dbo.Lrf_BetList_MobileReport_SelWinloss_Mem_xtest
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_Old_UAT1
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_Old_UAT2
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_Old_UAT3
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_Old_xpre
GO

DROP PROCEDURE dbo.Lrf_BetList_SelByDayAll_Mem_Old_xtest
GO

DROP PROCEDURE dbo.Lrf_BetList_SelWinLossDaily_xtest
GO

DROP PROCEDURE dbo.Lrf_BetList_SelWinLossRacingByDate_Mem_UAT3
GO

DROP PROCEDURE dbo.Lrf_BetList_SelWinLossRacingByDate_Mem_xpre
GO

DROP PROCEDURE dbo.Lrf_BetList_SelWinLossRacingByDate_Mem_xtest
GO

DROP PROCEDURE dbo.Lrf_BetList_SelWinlostRacing_UAT3
GO

DROP PROCEDURE dbo.Lrf_BetList_SelWinlostRacing_xpre
GO

DROP PROCEDURE dbo.Lrf_BetList_SelWinlostRacing_xtest
GO

DROP PROCEDURE dbo.Lrf_BetList_WinlostByLeague_Mem_UAT1
GO

DROP PROCEDURE dbo.Lrf_BetList_WinlostByLeague_Mem_UAT3
GO

DROP PROCEDURE dbo.Lrf_BetList_WinlostByLeague_Mem_xpre
GO

DROP PROCEDURE dbo.Lrf_BetList_WinlostByLeague_Mem_xtest
GO

DROP PROCEDURE dbo.Lrf_BettransSelBetSlip_Old_xtest
GO

DROP PROCEDURE dbo.Lrf_Rpt_WinlostRacing_xpre
GO

DROP PROCEDURE dbo.Lrf_Rpt_WinlostRacing_xtest
GO
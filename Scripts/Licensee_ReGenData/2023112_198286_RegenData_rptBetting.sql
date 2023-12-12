 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
USE [bodb_LicenseeReport]

GO

/*
	Create : 20231212@Danny 
	Regen data for rptBetting [Redmine: #198286] 
	DB: DB052.bodb_LicenseeReport
*/
 
  DELETE FROM rpt_Betting with(rowlock) WHERE rptDate = '2023-12-06'

  DELETE FROM rpt_BettingByProduct with(rowlock) WHERE rptDate = '2023-12-06'


  INSERT INTO rpt_Betting (
  [rptDate],[SiteID],[Bettype],[LeagueID],
	[CurrencyID] ,[Status] ,[IsLive],
	[BetCount],[MemberCount],[Turnover],
	[WinLoss],[WinLossA],[WinLossM],[WinLossS],
	[CommissionP],[CommissionA],[CommissionM],[CommissionS],[WinLossVirtual],
	[CommissionSVirtual],[CustomerCategory],[BuyBackAmount],
	[WinPrizeAmount],[CashOutAmount],[oddsspread],[ExtraAmount],
	[TicketType],[WinLossE] ,[CommissionE])

	SELECT  [rptDate],[SiteID],[Bettype],[LeagueID],
		[CurrencyID] ,[Status] ,[IsLive],
		[BetCount],[MemberCount],[Turnover],
		[WinLoss],[WinLossA],[WinLossM],[WinLossS],
		[CommissionP],[CommissionA],[CommissionM],[CommissionS],[WinLossVirtual],
		[CommissionSVirtual],[CustomerCategory],[BuyBackAmount],
		[WinPrizeAmount],[CashOutAmount],[oddsspread],[ExtraAmount],
		[TicketType],[WinLossE] ,[CommissionE]
	FROM DB053.bodb_licenseeReport.dbo.rpt_Betting with(nolock) where rptDate = '2023-12-06'


	INSERT INTO rpt_BettingByProduct (
		[rptDate] ,
		[SiteID] ,
		[ProductID],
		[Bettype] ,
		[CurrencyId],
		[StatusId],
		[CustomerCategory],
		[GrossWL],
		[MemberWL],
		[Turnover],
		[BetCount],
		[CommissionA],
		[CommissionP],
		[BuyBackAmount],
		[WinPrizeAmount],
		[CashOutAmount],
		[ValidBetAmount],
		[TicketType],
		[ExtraAmount]
	)
	SELECT [rptDate] ,
		[SiteID] ,
		[ProductID],
		[Bettype] ,
		[CurrencyId],
		[StatusId],
		[CustomerCategory],
		[GrossWL],
		[MemberWL],
		[Turnover],
		[BetCount],
		[CommissionA],
		[CommissionP],
		[BuyBackAmount],
		[WinPrizeAmount],
		[CashOutAmount],
		[ValidBetAmount],
		[TicketType],
		[ExtraAmount]
	FROM DB053.bodb_licenseeReport.dbo.rpt_BettingByProduct with(nolock) where rptDate = '2023-12-06'

	 
GO
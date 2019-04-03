USE [bodb_LicenseeReport]
GO

/*
	Created: 20190403@Percy
	DB: DBLIC.bodb_LicenseeReport
	Task: Backup data for troubleshoot data issue
		bettrans (staging)
		rpt_Betting
		rpt_Betting_BA
*/

DECLARE @WinlostDate SMALLDATETIME
SELECT  @WinlostDate = ''

-- Clear old data
DELETE dbo.bettrans_CheckData WITH (ROWLOCK, UPDLOCK)
WHERE winlostdate = @WinlostDate

DELETE dbo.rpt_Betting_CheckData WITH (ROWLOCK, UPDLOCK)
WHERE rptDate = @WinlostDate

DELETE dbo.rpt_Betting_BA_CheckData WITH (ROWLOCK, UPDLOCK)
WHERE rptDate = @WinlostDate
-- End Clear old data


-- Insert new data
INSERT INTO [dbo].[bettrans_CheckData]
(
	[transid],[custid],[stake],[statusid],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm]
	,[apositiontaking],[mpositiontaking],[tpositiontaking],[liveindicator],[betteam],[winlostdate],[betfrom]
	,[actualrate],[matchid],[recommend],[mrecommend],[actual_stake],[currency],[scomm],[spositiontaking]
	,[swinlost],[srecommend],[refno],[transdate],[bettype],[virtualrate],[isBA],[discount],[customercategory]
	,[site],[CashInAmount],[WinPrizeAmount],[CashOutAmount],[oddsspread],[ExtraInfo],[betdaqid],[hdp2],[TicketType]
)
SELECT
	[transid],[custid],[stake],[statusid],[status],[winlost],[awinlost],[mwinlost],[playercomm],[comm],[acomm]
	,[apositiontaking],[mpositiontaking],[tpositiontaking],[liveindicator],[betteam],[winlostdate],[betfrom]
	,[actualrate],[matchid],[recommend],[mrecommend],[actual_stake],[currency],[scomm],[spositiontaking]
	,[swinlost],[srecommend],[refno],[transdate],[bettype],[virtualrate],[isBA],[discount],[customercategory]
	,[site],[CashInAmount],[WinPrizeAmount],[CashOutAmount],[oddsspread],[ExtraInfo],[betdaqid],[hdp2],[TicketType]
FROM dbo.bettrans WITH (NOLOCK)
WHERE winlostdate = @WinlostDate

INSERT INTO [dbo].[rpt_Betting_CheckData]
(
	[RecordID],[rptDate],[SiteID],[Bettype],[LeagueID],[CurrencyID],[Status],[IsLive],[BetCount],[MemberCount]
	,[Turnover],[WinLoss],[WinLossA],[WinLossM],[WinLossS],[CommissionP],[CommissionA],[CommissionM],[CommissionS]
	,[WinLossVirtual],[CommissionSVirtual],[CustomerCategory],[BuyBackAmount],[WinPrizeAmount],[CashOutAmount]
	,[oddsspread],[ExtraAmount],[TicketType]
)
SELECT
	[RecordID],[rptDate],[SiteID],[Bettype],[LeagueID],[CurrencyID],[Status],[IsLive],[BetCount],[MemberCount]
	,[Turnover],[WinLoss],[WinLossA],[WinLossM],[WinLossS],[CommissionP],[CommissionA],[CommissionM],[CommissionS]
	,[WinLossVirtual],[CommissionSVirtual],[CustomerCategory],[BuyBackAmount],[WinPrizeAmount],[CashOutAmount]
	,[oddsspread],[ExtraAmount],[TicketType]
FROM dbo.rpt_Betting WITH (NOLOCK)
WHERE rptDate = @WinlostDate
	
INSERT INTO [dbo].[rpt_Betting_BA_CheckData]
(
	[RecordID],[rptDate],[SiteID],[Bettype],[LeagueID],[CurrencyID],[Status],[IsLive],[BetCount],[MemberCount]
	,[Turnover],[WinLoss],[WinLossA],[WinLossM],[WinLossS],[CommissionP],[CommissionA],[CommissionM],[CommissionS]
	,[WinLossVirtual],[CommissionSVirtual],[BuyBackAmount],[CustomerCategory],[TicketPayout],[ExtraAmount],[TicketType]
)
SELECT
	[RecordID],[rptDate],[SiteID],[Bettype],[LeagueID],[CurrencyID],[Status],[IsLive],[BetCount],[MemberCount]
	,[Turnover],[WinLoss],[WinLossA],[WinLossM],[WinLossS],[CommissionP],[CommissionA],[CommissionM],[CommissionS]
	,[WinLossVirtual],[CommissionSVirtual],[BuyBackAmount],[CustomerCategory],[TicketPayout],[ExtraAmount],[TicketType]
FROM dbo.rpt_Betting_BA WITH (NOLOCK)
WHERE rptDate = @WinlostDate
-- End Insert new data
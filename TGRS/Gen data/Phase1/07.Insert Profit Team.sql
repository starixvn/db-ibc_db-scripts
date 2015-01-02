USE [bodb_TGRS]
GO

SET NOCOUNT ON

DELETE [dbo].[SummaryByTeam_Monthly] WHERE  [EventDate]='2013-01-01'

INSERT INTO [dbo].[SummaryByTeam_Monthly]
([EventDate]
      ,[TeamId]
      ,[Stake]
      ,[WinLost]
      ,[Comm]
      ,[BetCount]
      ,[MatchCount]
 )

SELECT [EventDate]
      ,[TeamId]
      ,[Stake]
      ,Winloss [WinLost]
      ,0 [Comm]
      ,ROUND([BetCount],0) [BetCount]
      ,ROUND(Match,0) [MatchCount]
FROM (
	SELECT 'Team A' TeamName,18008.5 Match ,4716605450.09 Stake,40405352 BetCount ,24305595.24 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Team B' TeamName,16091.5 Match ,5322523157.68 Stake,40281522 BetCount ,18469595.9 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Team C' TeamName,16087.75 Match ,3863774618.96 Stake,38426238 BetCount ,24871899.75 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Team D' TeamName,17531 Match ,3689229156.96 Stake,42499606 BetCount ,31654040.05 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Team E' TeamName,17090 Match ,4116116636.69 Stake,33469217 BetCount ,24701763.76 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Team F' TeamName,13014.5 Match ,3864629138.26 Stake,28984788 BetCount ,14112149.91 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Team G' TeamName,14909.5 Match ,4197004484.88 Stake,31762070 BetCount ,20432409.91 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Team H' TeamName,14506 Match ,4486386210.54 Stake,32882905 BetCount ,16762405.74 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Team I' TeamName,17870 Match ,2946525932.68 Stake,30662193 BetCount ,18463695.44 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT '1X2' TeamName,30505 Match ,449402032.2 Stake,8747901 BetCount ,4838041.89000001 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'BH' TeamName,1518 Match ,86865134.02 Stake,1279524 BetCount ,602221.519999999 Winloss,'2013-01-01' EventDate
	UNION ALL SELECT 'Others' TeamName,8037 Match ,3298817390.74 Stake,25493202 BetCount ,14910112.63 Winloss,'2013-01-01' EventDate

) tblA
INNER JOIN dbo.Team WITH(NOLOCK)
	ON Team.TeamName = tblA.TeamName


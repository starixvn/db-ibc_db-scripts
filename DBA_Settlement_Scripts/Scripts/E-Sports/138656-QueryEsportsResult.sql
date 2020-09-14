
--Created by : 20200914@Louisa
-- Description: 138656 - Query E-Sports result (Settled score, Trader, Provider, Outside Source)

IF OBJECT_ID('tempdb..#ResultsLatest') IS NOT NULL
DROP TABLE #ResultsLatest

DECLARE	@MatchId INT = 70000371
DECLARE @Selection INT = 0
		---0 : all
		---1: FinalResult ( settled Score)
		---100: Trader
		---101: Provider
		---1001: Screenshot
		---1002: Outside Source


	CREATE TABLE #ResultsLatest ( 
		 SourceId	SMALLINT
		,ResourceId VARCHAR(20)
		,HomeValue  VARCHAR(50)
		,AwayValue  VARCHAR(50)
		,CreateDate DATETIME
	)

	--- get latest result
	;WITH cteLatestId
	AS(
		SELECT	ROW_NUMBER() OVER (PARTITION BY p.SourceId, p.ResourceId ORDER BY p.CreateDate DESC) AS rn
				,p.SourceId
				,ResourceId
				,p.ProviderExternalId
				,p.HomeValue
				,p.AwayValue
				,p.CreateDate
		FROM	dbo.ProviderExternalResultDetailES p WITH(NOLOCK)
		WHERE	p.MatchId = @MatchId
	)
	INSERT INTO #ResultsLatest	(	SourceId ,ResourceId	,HomeValue 	,AwayValue 	,CreateDate)
	SELECT l.SourceId, l.ResourceId, l.HomeValue, l.AwayValue, CreateDate   FROM cteLatestId l WHERE l.rn =1
	
	IF (@Selection = 1 OR @Selection = 0) ---- FINALRESULT ( SETTLED SCORE)
	BEGIN
		SELECT 'Settled score'
		SELECT * FROM ResultDetailES res WITH(NOLOCK) WHERE res.MatchID  = 70000371
	END

	IF (@Selection = 100 OR @Selection = 0) ----TRADER SCORE
	BEGIN
		SELECT 'TRADER SCORE'
		SELECT * FROM #ResultsLatest r  WITH(NOLOCK) WHERE r.SourceId = 100
	END

	IF (@Selection = 101 OR @Selection = 0) ---PROVIDER SCORE ----Web sẽ lấy ra top 2 Provider có OrderNo nhỏ nhất và phải có result
	BEGIN
		SELECT 'PROVIDER SCORE'
		SELECT pi.SourceID,pi.SourceName, r.ResourceId, r.HomeValue, r.AwayValue, r.CreateDate, r.CreateDate, pgm.OrderNo 
		FROM #ResultsLatest r 
		INNER JOIN ProviderInfo pi WITH(NOLOCK)
			ON pi.SourceId  = r.SourceId
		INNER JOIN ProviderGameTypeMapping pgm WITH(NOLOCK)
				ON pi.SourceId  = pgm.SourceId
		WHERE  pi.SourceId <>  100 
			AND r.SourceId < 1001
			AND pi.isActive =1
			AND pgm.isActive =1
		ORDER BY pgm.OrderNo
	END

	IF (@Selection = 1001 OR @Selection = 0)--SCREENSHOT --- Nếu chưa có 1001 Info, Lần đầu tiên Load lên là dummy value, sau khi nhập score và save cho 1001 mới mapping và insert result xuống DB 
	BEGIN
		SELECT 'SCREENSHOT'
		SELECT pi.SourceID,pi.SourceName, r.ResourceId, r.HomeValue, r.AwayValue, r.CreateDate, r.CreateDate, pgm.OrderNo 
		FROM #ResultsLatest r 
		INNER JOIN ProviderInfo pi WITH(NOLOCK)
			ON pi.SourceId  = r.SourceId
		INNER JOIN ProviderGameTypeMapping pgm WITH(NOLOCK)
			ON pi.SourceId  = pgm.SourceId
		WHERE  pi.SourceId = 1001
			AND pi.isActive =1
			AND pgm.isActive =1
	END

	IF (@Selection = 1002 OR @Selection = 0) ----OUTSIDE SOURCE: GameType phải được map với Provider, và map với League
	BEGIN
		DECLARE @LeagueId INT
		DECLARE @GameType TINYINT
		SELECT @LeagueId = m.LeagueId FROM dbo.Match m WITH(NOLOCK) WHERE m.MatchId   = @MatchId
		SELECT @GameType = l.OverTimeSession FROM dbo.League l WITH(NOLOCK) WHERE l.leagueid = @LeagueId
		
		SELECT 'OUTSIDE SOURCE'
		SELECT pi.SourceID,pi.SourceName, r.ResourceId, r.HomeValue, r.AwayValue, r.CreateDate, r.CreateDate, plmo.OrderNo 
		FROM #ResultsLatest r  
		INNER JOIN ProviderInfo pi
			ON pi.SourceId  = r.SourceId
		INNER JOIN ProviderGameTypeMapping pgm WITH(NOLOCK)
			ON pi.SourceId  = pgm.SourceId
		INNER JOIN ProviderLeagueMappingOutsideSource  plmo WITH(NOLOCK)
			ON plmo.PGId =  pgm.PGId AND plmo.LeagueId  = @LeagueId
		WHERE  GameType = @GameType
			AND pi.isActive =1
			AND pgm.isActive =1
	END


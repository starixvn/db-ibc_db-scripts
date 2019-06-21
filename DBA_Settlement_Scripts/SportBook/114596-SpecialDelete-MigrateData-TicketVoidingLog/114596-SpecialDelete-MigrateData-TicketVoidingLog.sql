USE bodb_CustomerLog
GO

/*
	Created: 20190621@Kathy
	DB: DBLOG/bodb_CustomerLog
	Task: Change logactionId & format for old data [Redmine:#114596]
*/
SET NOCOUNT ON

DECLARE @Id INT


CREATE TABLE #tmpResult (
	Id INT IDENTITY(1,1)
	,LogId INT
	,LogActionId INT
	,RequestId INT
	,LogData VARCHAR(MAX)
	,CreatedDate DATETIME
	,UserId INT
	,IP VARCHAR(50)
	,SessionId INT
	,MatchId INT

	,Rank INT
	,TransId BIGINT
)

SET @Id = 0

INSERT INTO #tmpResult (LogId, LogActionId, RequestId, LogData, CreatedDate, UserId, IP, SessionId, MatchId, Rank)
SELECT LogId
	,90502
	,RequestId
	,'' AS LogData 
	,CreatedDate
	,UserId
	,IP
	,CAST(CHECKSUM(getdate()) + LogId AS INT) AS SessionId
	,CAST(f.val AS BIGINT) as matchid
	,f.rank
FROM dbo.TicketVoiding_Log l WITH(NOLOCK)
	CROSS APPLY (
		select SUBSTRING(LogData, CHARINDEX('MatchIds:',LogData) + LEN('MatchIds:'), LEN(logdata)) as matches		
	) m
	CROSS APPLY (
		select f.val, f.rank
		from dbo.strSplit(m.matches,',') f
	)f
WHERE	LogActionId = 90501
		AND LogData LIKE '%MatchIds:%'

INSERT INTO #tmpResult (LogId, LogActionId, RequestId, LogData, CreatedDate, UserId, IP, SessionId, MatchId, Rank)
SELECT LogId
	,90502
	,RequestId
	,'' AS LogData 
	,CreatedDate
	,UserId
	,IP	
	,CAST(CHECKSUM(getdate()) + LogId AS INT) AS SessionId
	,CAST(f.MatchId AS INT) as matchid	
	,ROW_NUMBER() OVER (PARTITION BY LogId ORDER BY f.MatchId) AS Rank
FROM dbo.TicketVoiding_Log WITH(NOLOCK)
	CROSS APPLY (
		select CAST(SUBSTRING(LogData, CHARINDEX('Matches:',LogData) + LEN('MatchIds:'), LEN(logdata)) AS xml) as matches
	) m
	CROSS APPLY (
		select DISTINCT t.c.value('@MatchId', 'INT') as MatchId
		from matches.nodes('Matches/Match') t(c)
	)f
WHERE	LogActionId = 90501
		AND LogData LIKE '%Matches%'

INSERT INTO #tmpResult (LogId, LogActionId, RequestId, LogData, CreatedDate, UserId, IP, SessionId, MatchId, Rank, TransId)
SELECT LogId
	,CASE 
		WHEN s.StatusId = 0 THEN 90500 
		WHEN s.StatusId = 1 THEN 90501
		ELSE 0 
	END AS LogActionId
	,RequestId
	,s.LogData
	,CreatedDate
	,UserId
	,IP	
	,CAST(CHECKSUM(getdate()) + LogId AS INT) AS SessionId
	,0 AS MatchId
	,1 AS Rank
	,f.TransId
FROM dbo.TicketVoiding_Log l WITH(NOLOCK)
	CROSS APPLY (
		SELECT SUBSTRING(LogData, CHARINDEX('Status:',LogData) + LEN('Status:') + 1, 1) AS StatusId
				,REPLACE(SUBSTRING(LogData, CHARINDEX('TransIds:', LogData) + LEN('TransIds:') + 1, LEN(LogData)), CHAR(10), '') AS LogData
	) s
	CROSS APPLY (
		SELECT TOP 1 f.val AS TransId
		FROM	dbo.f_StringSplit(s.LogData, ',') f
	) f
WHERE	l.LogActionid = 90500
		AND l.LogData LIKE '%Status%'

UPDATE r 
	SET MatchId = b.matchid
FROM	#tmpResult r
	CROSS APPLY (
		SELECT	matchid
		FROM	bodb02.dbo.bettrans WITH(NOLOCK)
		WHERE	transid = r.TransId
		UNION ALL 
		SELECT	matchid
		FROM	bodb02.dbo.bettrans14 WITH(NOLOCK)
		WHERE	transid = r.TransId
	) b

WHILE (1 = 1)
BEGIN
	UPDATE t
		SET logactionId = r.LogActionId
			,LogData = r.Logdata
			,SessionId = r.SessionId
			,MatchId = r.MatchId
	FROM	dbo.TicketVoiding_Log t
		INNER JOIN #tmpResult r
			ON t.LogId = r.LogId
	WHERE	r.Rank = 1
			AND r.Id BETWEEN @Id + 1 AND @Id + 1000

	IF @@ROWCOUNT < 1000
		BREAK

	SET @Id = @Id + 1000
END
	
INSERT INTO dbo.Ticketvoiding_Log (LogActionId, RequestId, LogData, CreatedDate, UserId, IP, SessionId, MatchId)
SELECT	LogActionId, RequestId, LogData, CreatedDate, UserId, IP, SessionId, MatchId
FROM	#tmpResult
WHERE	Rank > 1

DROP TABLE #tmpResult

SET NOCOUNT OFF

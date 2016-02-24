/*
	Created: 20160224@Kathy
	DB: DBTXN/bodb02
	Task: Manually undo match in case of NetPosition service failed
	
 */
DECLARE @MatchId	INT = xyz
		,@bettype	SMALLINT = 501

EXEC Dot_Member_NetPosition_UnSettlement 
	@Matchid = @MatchId
	,@bettype = @bettype

EXEC Dot_Member_NetPosition_GetQueue

DECLARE @NPQueueId BIGINT 

SELECT TOP 1 @NPQueueId = NPQueueID
FROM	dbo.NetPositionQueue WITH (NOLOCK)
WHERE	NeedPending = 0
		AND MatchID = @MatchId
		AND Bettype = @bettype
		AND ActionTypeID = 2
ORDER BY Matchid
		,Bettype
		,ActionTypeID

EXEC Dot_Member_NetPosition_GetSchedule 
	@NPQueueID = @NPQueueId
	,@Matchid = @MatchId
	,@bettype = @bettype
	,@MinTransid = 0
	,@MaxTransid = 0
	,@ActionTypeID = 2

SELECT	DISTINCT Custid
INTO	#CreditMember
FROM	dbo.NetPositionTrans WITH (NOLOCK)
WHERE	SyncStatus = 0
		AND MatchID = @MatchId
		AND Bettype = @bettype

-- execute for each member 
DECLARE @CustId INT

WHILE (EXISTS (SELECT TOP 1 1 FROM #CreditMember))
BEGIN
	SELECT	TOP 1 @CustId = CustId
	FROM	#CreditMember

	EXEC Dot_Member_NetPosition_Calculation 
		@Custid = @CustId
		,@Matchid = @MatchId
		,@bettype = @bettype
		,@ActionTypeID = 2

	DELETE
	FROM	#CreditMember
	WHERE	CustId = @CustId
END

DROP TABLE #CreditMember

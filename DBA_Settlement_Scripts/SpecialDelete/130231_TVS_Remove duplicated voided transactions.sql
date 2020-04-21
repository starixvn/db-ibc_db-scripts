/*
	Created: 20200409@Max
	Task: [TVS] Remove duplicated voided transactions - [Redmine:#130231]
	DB: DBTXN/bodb02
*/
USE bodb02
GO
BEGIN
	DECLARE @dup_transaction TABLE (ID INT)

	SELECT t.TransId INTO #tmp
	FROM dbo.TicketVoiding_VoidedTransaction t WITH (NOLOCK)
	WHERE t.IssueTypeID = 11
	GROUP BY t.TransId
	HAVING COUNT(1) > 1

	INSERT INTO @dup_transaction (ID)
	SELECT t.Id
	FROM dbo.TicketVoiding_VoidedTransaction t WITH (NOLOCK)
		INNER JOIN #tmp t1 ON t1.TransId = t.TransId
		OUTER APPLY (
					SELECT ReasonId
					FROM dbo.TicketVoiding_VoidingHistory WITH (NOLOCK)
					WHERE ReasonId = t.ReasonId
			)tv
	WHERE tv.ReasonId IS NULL


	WHILE (0=0)
	BEGIN
		DELETE TOP (2000) t
		FROM dbo.TicketVoiding_VoidedTransaction t  WITH (ROWLOCK, UPDLOCK)
			INNER JOIN @dup_transaction d ON d.ID = t.Id
	
		IF @@ROWCOUNT = 0 BREAK	

	END

	DROP TABLE #tmp
END


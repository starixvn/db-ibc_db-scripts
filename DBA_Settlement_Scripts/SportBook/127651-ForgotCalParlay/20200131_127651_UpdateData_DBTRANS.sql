/*
	Created: Helen
	Date: 20200131
	Task: Move tickets new match for cricket
	DB: DBTXN/BODB02 

	Revisions: 
			- 20191230@Helen: Initialize - Move Event - [Redmine:127651]
			
	Notes: 
		- @MatchID: current matchid 
		- @NewMatchID: new matchid
		
*/

USE bodb02
GO
DECLARE @MatchID		INT,
		@NewMatchID		INT,
		@NewOddsid		INT,
		-- for update stake
		@MatchID_ClearStake INT,
		@Refno_StakeUpd BIGINT
		
SET @MatchID_ClearStake = 34352128
SET @Refno_StakeUpd = 101570782876

SET @NewMatchID = XXX
SET @NewOddsid = XXX

---- Update new matchid and oddsid
UPDATE	b
	SET	matchid		= @NewMatchID
		, oddsid = @NewOddsid  
FROM	bettransm b  WITH (ROWLOCK)
WHERE	b.matchid = @MatchID 

-- Reset stake = 0 for matchid 34367878
UPDATE	b
	SET	stake = 0  
FROM	bettransm b  WITH (ROWLOCK)
WHERE	b.refno = @Refno_StakeUpd AND b.matchid = @MatchID_ClearStake

-- Update new stake for new matchid
UPDATE	b
	SET	stake = 1058 
FROM	bettransm b  WITH (ROWLOCK)
WHERE	b.refno = @Refno_StakeUpd AND b.matchid = @NewMatchID
		
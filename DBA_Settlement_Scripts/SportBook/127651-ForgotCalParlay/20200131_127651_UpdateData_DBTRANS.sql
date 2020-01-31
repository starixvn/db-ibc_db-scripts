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
		
SET @MatchID_ClearStake = 34367878
SET @Refno_StakeUpd = 101570782876

SET @NewMatchID = XXX
SET @NewOddsid = XXX

---- Update new matchid and oddsid
UPDATE	b
	SET	matchid		= @NewMatchID
		, oddsid = @NewOddsid  
FROM	bettransm b  WITH (ROWLOCK)
WHERE	b.matchid = @MatchID 

--- fix stake for 8 refno 
CREATE TABLE #RefnoList (refno BIGINT, matchid INT)
CREATE TABLE #Refno_Stake (refno BIGINT, stake MONEY)

INSERT INTO #RefnoList (refno, matchid)
VALUES 
(101570422667,34356428),
(101570438742,34359125),
(101570466698,34362667),
(101570567456,34365813),
(101570569410,34365813),
(101570697656,34360818),
(101570706295,34361897),
(101570782876,34367878)

INSERT INTO #Refno_Stake (refno,stake)
SELECT b.refno, stake
from bettransm14 b WITH (NOLOCK)
	INNER JOIN #RefnoList T on b.matchid = t.matchid AND b.refno = t.refno

------ update stake ---------
UPDATE b
	SET stake = s.stake
FROM bettransm b WITH (ROWLOCK)
	INNER JOIN #Refno_Stake s ON b.refno = s.refno 
WHERE b.matchid = @NewMatchID

UPDATE b
	SET stake = 0
FROM bettransm14 b WITH (ROWLOCK)
	INNER JOIN #RefnoList s ON b.refno = s.refno AND b.matchid = s.matchid

GO	

	

	
/*
	Created: Helen
	Date: 20200131
	Task: Move tickets new match for cricket
	DB: DBTXN/BODB02 and all replicated server of pub name 'DBTrans_Bet'

	Revisions: 
			- 20200131@Helen: Initialize - Move Event - [Redmine:127651]
			
	Notes: 
		- @MatchID: current matchid 
		- @NewMatchID: new matchid
		
*/

USE bodb02
GO
DECLARE @MatchID		INT,
		@NewMatchID		INT

SET @MatchID = 34352128
SET @NewMatchID = --XXX

UPDATE p
	SET matchid = @NewMatchID
FROM BetParlayDetail P WITH (ROWLOCK)
WHERE matchid = @MatchID

GO
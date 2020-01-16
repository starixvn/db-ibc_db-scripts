/*<info serverAlias="DBPRO-bodb02" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[vnDBA_SET_Suspend1H_ResetGoalRecord]
(
	@MatchID   INT
	,@creator  INT = 10278938 -- starixIT
	,@ErrCode			INT				= 0		OUTPUT
	,@ErrMsg			VARCHAR(1000)	= ''	OUTPUT
	
)
/*
	Created: 20200114@Helen
	Task: Need to reset goalrecord to empty since Suspender confirm HT for suspended match in 1H
	DB: DBPRO/bodb02
	
	Revisions:		
		- 20200115@Helen: Unable to Refund all due to Goal Record is ';' - [127136]
	
	Notes: Used to reset Goalrecord to empty only	
*/
AS
BEGIN
	DECLARE @sporttype INT = 1
		, @childmatchtype SMALLINT = 0
		, @IsSettled BIT = 0

	SELECT @sporttype = sporttype
		, @childmatchtype = ChildMatchType
	FROM dbo.match WITH (NOLOCK)
	WHERE matchid = @matchID

	SET @IsSettled  = (SELECT TOP (1) 1 
						FROM ResultDetail WITH (NOLOCK) 
						WHERE MatchID = @MatchID
							AND SettlementStatusID > 0
							AND (ResourceID IN ('00','01','08','09','14F','14L','127F','127L'
												,'488','489','490' -- corner
												)
								OR ResourceID LIKE '486%' -- conner
								OR ResourceID LIKE '487%') -- conner
							 
						)
	IF @sporttype <> 1 OR @IsSettled = 1
	BEGIN
		SELECT	@ErrCode = 100
				,@ErrMsg = 'Only support for soccer and match has been not settled yet.'

		RETURN
	END
				
	UPDATE dbo.match WITH(ROWLOCK,UPDLOCK)
		SET  
			 hthomescore	= NULL
			,htawayscore	= NULL 
			,betstatus		= ''
			,GoalRecord		= ''
			,changetime		= GETDATE()
			,settleTime = GETDATE()
	WHERE matchid = @MatchID
			
	
	UPDATE ResultDetail WITH (UPDLOCK,ROWLOCK)
		SET     HomeValue           = CASE WHEN ResourceID IN ('08','09') THEN '' ELSE NULL END 
				,AwayValue          = NULL
				,ResultStatusID     = 0     -- Initial 
				,LastModifyBy       = @Creator 
				,LastModifyDate     = GETDATE() 
	FROM    dbo.ResultDetail r
	WHERE   r.MatchID = @MatchID 
			AND SettlementStatusID = 0	
			AND (ResourceID IN ('00','01','08','09','14F','14L','127F','127L'
								,'488','489','490' -- corner
								)
				OR ResourceID LIKE '486%' -- conner
				OR ResourceID LIKE '487%') -- conner
				
	
END
/*<info serverAlias="DBPRO-bodb02" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[vnDBA_SET_Suspend1H_RemoveSemicolon]
(
	@MatchID	INT
	,@creator	INT = 10278938 -- starixIT
	,@ErrCode	INT				= 0		OUTPUT
	,@ErrMsg	VARCHAR(1000)	= ''	OUTPUT
	
)
/*
	Created: 20200114@Helen
	Task: Need to RemoveSemicolon since Suspender confirmed HT for suspended match in 1H
	DB: DBPRO/bodb02
	
	Revisions:		
		- 20200115@Helen: Unable to Refund all due to Goal Record is ';' - [127136]
	
	Notes: Used to remove RemoveSemicolon for Goalrecord	
*/
AS
BEGIN
	DECLARE @sporttype INT = 1
		, @childmatchtype SMALLINT = 0
		, @hthomescore_GR SMALLINT = 0
		, @htawayscore_GR SMALLINT = 0
		, @hthomescore_tmp SMALLINT = 0
		, @htawayscore_tmp SMALLINT = 0
		, @validSemicolon VARCHAR(1)=''

	SELECT @sporttype = sporttype
		, @childmatchtype = ChildMatchType
		, @hthomescore_GR = LEN(GoalRecord) - LEN(REPLACE(GoalRecord, 'H', ''))
		, @htawayscore_GR = LEN(GoalRecord) - LEN(REPLACE(GoalRecord, 'A', ''))
		, @hthomescore_tmp = hthomescore
		, @htawayscore_tmp = htawayscore
		, @validSemicolon = RIGHT(GoalRecord,1)
	FROM dbo.match WITH (NOLOCK)
	WHERE matchid = @matchID
	
	------ starting of validation -----------
	IF @sporttype <> 1 
	BEGIN
		SELECT	@ErrCode = 100
				,@ErrMsg = 'Only support for soccer.'

		RETURN
	END
	
	IF @validSemicolon <> ';'
	BEGIN 
		SELECT	@ErrCode = 100
				,@ErrMsg = 'Only support for match suspended in 1H only'

		RETURN
	END
	
	IF @hthomescore_GR <> @hthomescore_tmp OR @htawayscore_GR <> @htawayscore_tmp
	BEGIN
		SELECT	@ErrCode = 100
				,@ErrMsg = 'Unconsistency Goalrecord and score in table match'

		RETURN
	END
	------ end of validation -----------
	
	UPDATE dbo.match WITH(ROWLOCK,UPDLOCK)
		SET  
			 GoalRecord		= REPLACE(GoalRecord,';','')
			,changetime		= GETDATE()
	WHERE matchid = @MatchID

	UPDATE ResultDetail WITH (UPDLOCK,ROWLOCK)
		SET     HomeValue           = REPLACE (HomeValue,';','')
				,LastModifyBy       = @Creator 
				,LastModifyDate     = GETDATE() 
	FROM    dbo.ResultDetail r
	WHERE   r.MatchID = @MatchID 
			AND r.ResourceID IN ('08')
END
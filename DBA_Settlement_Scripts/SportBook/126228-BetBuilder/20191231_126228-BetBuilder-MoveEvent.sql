/*
	Created: Helen
	Date: 20191230
	Task: Moving Betbuilder to new match 
	DB: DBTXN/BODB02 
	
*/
USE bodb02
GO

DECLARE 
	@MatchID		INT
	, @NewMatchID	INT
	, @AdminId		INT
	, @ErrCode		INT = 0
	, @ErrMsg		NVARCHAR(100)='' 
	, @IP varchar(15) = ''
	
SET @IP = '125.227.140.97'
SET @AdminId = 10278938

SET @MatchID = XXX -- old match
SET @NewMatchID = XXX -- NEW matchid

EXEC dbo.NAP_Admin_Settlement_BetBuilder_MoveEvent @MatchID = @MatchID, @NewMatchID = @NewMatchID, @AdminId = @AdminId,@IP = @IP,@ErrCode= @ErrCode OUT, @ErrMsg = @ErrMsg OUT
SELECT @ErrCode, @ErrMsg
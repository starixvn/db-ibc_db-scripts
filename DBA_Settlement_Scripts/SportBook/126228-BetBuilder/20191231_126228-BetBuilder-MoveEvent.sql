/*
	Created: Helen
	Date: 20191230
	Task: Moving Betbuilder to new match 
	DB: DBTXN/BODB02 
	
	Assumptions:
		- @MatchID & @NewMatchID existed in table VendorStatus
		- There is at least one BB ticket in match for curent matchID
*/
USE bodb02
GO

DECLARE @MatchID		INT
	, @NewMatchID	INT
	, @AdminId		INT
	, @IP varchar(15) = ''
	, @IsExistsBBTicket BIT = 0
	, @IsValidMatchid	BIT = 0
	, @ErrCode		INT = 0
	, @ErrMsg		NVARCHAR(100)='' 
	
	
SET @IP = '125.227.140.97'
SET @AdminId = 10278938

SET @MatchID = XXX -- current matchid
SET @NewMatchID = XXX -- NEW matchid

SET @IsExistsBBTicket = (SELECT TOP (1) 1
						FROM dbo.bettrans WITH (NOLOCK)
						WHERE matchid = @MatchID AND bettype = 38)
			
SET @IsValidMatchid	= (SELECT COUNT(DISTINCT matchid) 
						FROM DBPRO.bodb02.dbo.VendorStatus WITH (NOLOCK) 
						WHERE matchid IN (@MatchID,@NewMatchID) AND vendorid = 34
						)		

IF @IsValidMatchid = 2 AND @IsExistsBBTicket = 1	
BEGIN
	EXEC dbo.NAP_Admin_Settlement_BetBuilder_MoveEvent @MatchID = @MatchID, @NewMatchID = @NewMatchID, @AdminId = @AdminId,@IP = @IP,@ErrCode= @ErrCode OUT, @ErrMsg = @ErrMsg OUT
END
ELSE
BEGIN
	SET	@ErrMsg = 'Wrong Matchid or not exists betbuilder tickets.'
END	
SELECT @ErrCode, @ErrMsg
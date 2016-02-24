/*
	Created: 20160224@Kathy
	DB: DBTXN/bodb02
	Task: Manually calculate match in case of NetPosition service failed
	
 */

DECLARE @matchID		INT
	,@serviceCommand	VARCHAR(1000) = ''
	,@errCode			INT = 0
	,@errMsg			VARCHAR(200) = ''
	,@fth				INT = 0
	,@fta				INT = 0
	,@adminID			INT
	,@starttime			DATETIME

SELECT @matchID = xyz
	,@fth = xyz
	,@fta = xyz
	,@adminId = 8 -- SA

-- Clear NPCredit, NPDebit
EXEC Dot_Member_NetPosition_Settlement 
	@Matchid = @matchID
	,@bettype = 501

-- BEGIN Calculate match
EXEC NAP_Admin_Settlement_1_Push @AdminId = @adminID
	,@Matchid = @matchID
	,@HalfTimeHome = 0
	,@HalfTimeAway = 0
	,@FullTimeHome = @fth
	,@FullTimeAway = @fta
	,@Action = 'CAL'
	,@IP = ''
	,@BetStatus = N''
	,@ErrCode = @errCode OUTPUT
	,@ErrMsg = @errMsg OUTPUT
	,@ServiceCommand = @serviceCommand OUTPUT

SELECT @errCode 'errCode'
	,@errMsg 'errMsg'

SELECT @starttime = GETDATE()

EXEC NAP_Admin_Settlement_50 @StartTime = @starttime
	,@Action = 'CAL'
	,@EndTime = @starttime
	,@Reason = ''
	,@ServiceType = 1 -- Cricket
	,@ServiceCommand = @serviceCommand
	,@MatchId = @matchID
	,@ServiceStatus = 1 -- 

-- END Calculate match

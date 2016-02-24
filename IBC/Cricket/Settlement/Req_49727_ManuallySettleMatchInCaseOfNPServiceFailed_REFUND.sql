/*
	Created: 20160224@Kathy
	DB: DBTXN/bodb02
	Task: Manually refund match in case of NetPosition service failed
	
 */
DECLARE @matchID		INT
	,@serviceCommand	VARCHAR(1000) = ''
	,@errCode			INT = 0
	,@errMsg			VARCHAR(200) = ''
	,@adminID			INT
	,@starttime			DATETIME

SELECT @matchID = xyz
	,@adminId = 8 -- SA

-- clear NPCredit, NPDebit
EXEC Dot_Member_NetPosition_Settlement 
	@Matchid = @matchID
	,@bettype = 501

--BEGIN Refund match
EXEC NAP_Admin_Settlement_Refund_All_Push @AdminId = @adminID
	,@Matchid = @matchID
	,@IP = ''
	,@ServiceCommand = @serviceCommand OUTPUT
	,@ErrMsg = @errMsg OUTPUT
	,@ErrCode = @errCode OUTPUT

SELECT @errcode 'errcode'
	,@errmsg 'errmsg'

SELECT @starttime = GETDATE()

EXEC NAP_Admin_Settlement_50 @StartTime = @starttime
	,@Action = 'REFUND'
	,@EndTime = @starttime
	,@Reason = ''
	,@ServiceType = 1
	,@ServiceCommand = @serviceCommand
	,@MatchId = @matchid
	,@ServiceStatus = 1

-- END Refund match

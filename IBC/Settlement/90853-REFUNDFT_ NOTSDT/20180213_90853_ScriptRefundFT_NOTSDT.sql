/*
	Create: 20180213@Helen
	Task: https://nexdev.net/issues/90853
	DB: DBTXN/bodb02
*/
USE bodb02
GO
--Step 1.1: Insert result into Intg_OddsFeed_SettlementAction to log Settlement Action --
DECLARE @p6 INT
SET @p6=0
DECLARE @p7 VARCHAR(300)
SET @p7=NULL
EXEC NAP_Set_SettlementActionIns @MatchId=24073483,@LeagueId=49218
	,@ActionType=13,@OtherInfo='',@IsAutoPayout=0,@ErrCode=@p6 output,@ErrMsg=@p7 output
SELECT @p6, @p7

-- Step 1.2: Refund FT Action --
DECLARE @p4 int
SET @p4=0
DECLARE @p22 NVARCHAR(200)
SET @p22=N''
DECLARE @p23 NVARCHAR(max)
SET @p23=NULL
EXEC NAP_Admin_Settlement_RefundFT_Push 
	@MatchId=24073483,@AdminId=8,@IP='10.18.200.119',@ErrCode=@p4 OUTPUT
	,@GoalSequence='HHHAA'
	,@ResourceResult='<Results>
						<Resource Id="14F" HomeValue="" SettlementStatusId="3" ResultStatusId="5" />
						<Resource Id="14L" HomeValue="" SettlementStatusId="3" ResultStatusId="5" />
						<Resource Id="08" HomeValue="" SettlementStatusId="3" ResultStatusId="5" />
					</Results>',@ErrMsg=@p22 OUTPUT,@ServiceCommand=@p23 OUTPUT
	, @BetStatus=N'1FL:1-0;'
	,@FullTimeHome=0,@FullTimeAway=0,@fthCorners=0,@ftaCorners=0
	,@IsExcludeBetdaq=0,@IsSettleAbandonedMatch=0,@IsExcludeBetfair=0,@IsSettleAbandonedMatchBetFair=0,@IsSettleAbandonedMatchIBC=0
	,@isExistTotalCorner=0,@isExistHTFCorner=0,@isExistHTLCorner=0,@isExistFTFCorner=0,@isExistFTLCorner=0
	
SELECT @p4, @p22, @p23



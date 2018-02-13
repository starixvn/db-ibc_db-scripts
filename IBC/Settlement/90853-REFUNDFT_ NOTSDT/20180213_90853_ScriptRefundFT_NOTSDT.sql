/*
	Create: 20180213@Helen
	Task: https://nexdev.net/issues/90853
	DB: DBTXN/bodb02
*/
USE bodb02
GO
--Step 1.1: Insert result into Intg_OddsFeed_SettlementAction to log Settlement Action --
DECLARE @p10 INT
SET @p10=0
DECLARE @p11 varchar(300)
SET @p11=NULL
EXEC NAP_Set_SettlementActionIns 
	@MatchId=24073483
	,@LeagueId=49218
	,@HTHomeScore=3
	,@HTAwayScore=2
	,@FTHomeScore=3
	,@FTAwayScore=3
	,@OtherInfo='<Results><Resource Id="08" Value="HHHAAA"/></Results>'
	,@ActionType=15
	,@IsAutoPayout=0,@ErrCode=@p10 output,@ErrMsg=@p11 output
SELECT @p10, @p11
-- Step 1.2: Refund FT Action --
DECLARE @p4 INT
SET @p4=0
DECLARE @p22 NVARCHAR(200)
SET @p22=N''
DECLARE @p23 NVARCHAR(max)
SET @p23=NULL
EXEC NAP_Admin_Settlement_RefundFT_Push 
	@MatchId=24073483
	,@AdminId=8
	,@IP='10.18.200.119'
	,@IsExcludeBetdaq=0
	,@IsSettleAbandonedMatch=0
	,@IsExcludeBetfair=0
	,@IsSettleAbandonedMatchBetFair=0
	,@IsSettleAbandonedMatchIBC=0
	,@FullTimeHome=3,@FullTimeAway=3,@fthCorners=0,@ftaCorners=0
	,@BetStatus=N'1FL:1-2;FL:1-0;'
	,@GoalSequence='HHHAA;a'
	,@isExistTotalCorner=1,@isExistHTFCorner=1,@isExistHTLCorner=0
	,@isExistFTFCorner=1,@isExistFTLCorner=0
	,@ResourceResult='<Results>
						<Resource Id="14F" HomeValue="H" SettlementStatusId="4" ResultStatusId="5" />
						<Resource Id="14L" HomeValue="" SettlementStatusId="6" ResultStatusId="5" />
						<Resource Id="08" HomeValue="HHHAA;A" SettlementStatusId="6" ResultStatusId="5" />
					</Results>'
	,@ErrCode=@p4 OUTPUT
	,@ErrMsg=@p22 OUTPUT,@ServiceCommand=@p23 OUTPUT

SELECT @p4, @p22, @p23

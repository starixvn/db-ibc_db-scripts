/*
	Create: 20180213@Helen
	Task: https://nexdev.net/issues/90853
	DB: DBTXN/bodb02
*/
USE bodb02
GO
----------------------------------- Refund FT Action -------------------------
DECLARE @p4 int
SET @p4=0
DECLARE @p22 NVARCHAR(200)
SET @p22=N''
DECLARE @p23 NVARCHAR(max)
SET @p23=NULL
EXEC NAP_Admin_Settlement_RefundFT_Push @MatchId=24073483,@AdminId=8,@IP='10.18.200.119'
	,@GoalSequence='HHHAA;'
	,@ResourceResult='<Results>
						<Resource Id="14F" HomeValue="" SettlementStatusId="3" ResultStatusId="5" />
						<Resource Id="14L" HomeValue="" SettlementStatusId="3" ResultStatusId="5" />
						<Resource Id="08" HomeValue="" SettlementStatusId="3" ResultStatusId="5" />
					</Results>'
	, @BetStatus=N'1FL:1-2;'
	-- Default Value
	,@FullTimeHome=0,@FullTimeAway=0,@fthCorners=0,@ftaCorners=0
	,@IsExcludeBetdaq=0,@IsSettleAbandonedMatch=0,@IsExcludeBetfair=0,@IsSettleAbandonedMatchBetFair=0,@IsSettleAbandonedMatchIBC=0
	,@isExistTotalCorner=0,@isExistHTFCorner=0,@isExistHTLCorner=0,@isExistFTFCorner=0,@isExistFTLCorner=0
	,@ErrCode=@p4 OUTPUT,@ErrMsg=@p22 OUTPUT,@ServiceCommand=@p23 OUTPUT
	
SELECT @p4, @p22, @p23

GO

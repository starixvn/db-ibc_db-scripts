/*
	Created: 20180301@Helen
	Task: https://nexdev.net/issues/90154
	DB: DBTXN/bodb02
*/
USE bodb02
GO
-------------------------------- REFUND -------------------------------
DECLARE @p4 int
SET @p4=0
DECLARE @p22 NVARCHAR(200)
SET @p22=N''
DECLARE @p23 NVARCHAR(max)
SET @p23=NULL
EXEC NAP_Admin_Settlement_VS_BetRadar_Push_xpre @AdminId = 8
	,@MatchId			= 80001037
	,@Action			= 'REFUND'
	,@IP				= '10.18.200.119'
	,@IsAuto			= 1
	,@ErrCode			= @p22 OUT
	,@ErrMsg			= @p23 OUT
SELECT @p4, @p22, @p23

GO

-------------------------------- CAL -------------------------------
DECLARE @p4 int
SET @p4=0
DECLARE @p22 NVARCHAR(200)
SET @p22=N''
DECLARE @p23 NVARCHAR(max)
SET @p23=NULL
EXEC NAP_Admin_Settlement_VS_BetRadar_Push_xpre @AdminId	= 8
	,@MatchId			= 80001037
	,@Fth				= NULL -- (optional, can use for testing VS2, this value is not valid in VS2, force for Soccer (190,191,192) only)
	,@Fta				= NULL -- (optional, can use for testing VS2, this value is not valid in VS2, force for Soccer (190,191,192) only)
	,@Hth				= NULL -- (optional, can use for testing VS2, this value is not valid in VS2, force for Soccer (190,191,192) only)
	,@Hta				= NULL -- (optional, can use for testing VS2, this value is not valid in VS2, force for Soccer (190,191,192) only)
	,@Action			= 'CAL'
	,@IP				= '10.18.200.119'
	,@IsAuto			= 1
	-- VS2 Basketball, will base on this resource result only
	,@ResourceResult	= '<Results>
								<Resource ResourceId="01" Custom1="110" Custom2="120" />
								<Resource ResourceId="00" Custom1="145" Custom2="135" />
								<Resource ResourceId="280920" Custom1="N" Custom2="" />
								<Resource ResourceId="280940" Custom1="A" Custom2="" />
								<Resource ResourceId="280960" Custom1="H" Custom2="" />
							</Results>'
	,@ErrCode			= @p22 OUT
	,@ErrMsg			= @p23 OUT
SELECT @p4, @p22, @p23

/*<info serverAlias="DBTXN-bodb02"></info>*/
/*
	Create: 20200701@Sol
	DB : DBTXN-bodb02
	Task: Script to add new columns for Extra PT 2 [redmine: #136320]
*/

USE [bodb02]

GO

ALTER TRIGGER [dbo].[sum_winloss_tmp_delete] 
   ON  [dbo].[sum_winloss_tmp]
   AFTER DELETE
AS 
 /*
    Created: Unknown
    Task : Trigger delete sum_winloss_tmp to insert data into sum_winloss
    DB: DBTXN/bodb02 
	Revisions:
		- 20160225@Sophia: Add column TurnoverNoDraw [Redmine: #51427]
		- 20200708@Sol: Add columns ExtraComm, ExtraWinloss - [Redmine: #136320]
*/

BEGIN

	 -- SET NOCOUNT ON added to prevent extra result sets from
	 -- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for trigger here
	INSERT INTO dbo.sum_winloss 
	(
		[winlostdate], [username], [custid], [roleid], [recommend], [mrecommend], [srecommend],
		[turnover], [winlost], [awinlost], [mwinlost], [swinlost],
		[playercomm], [comm], [acomm], [scomm],
		[BetCount], [grosscomm],
		[sporttype], [bettype], [netTurnover], [TunroverNoDraw], [ExtraWinloss], [ExtraComm]
	)
	SELECT
		[winlostdate], [username], [custid], [roleid], [recommend], [mrecommend], [srecommend],
		[turnover], [winlost], [awinlost], [mwinlost], [swinlost],
		[playercomm], [comm], [acomm], [scomm],
		[BetCount], [grosscomm],
		[sporttype], [bettype], [netTurnover], [TunroverNoDraw], [ExtraWinloss], [ExtraComm]
	FROM deleted

END
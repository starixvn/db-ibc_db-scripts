/*<info serverAlias="DBSUM-bodb_Summary"></info>*/
/*
	Create: 20240208@Sophia
	Task: copy data of reset winning by Run Manual Routine task [Redmine: #200940] 
	DB: DBSUM-bodb_Summary
*/ 
 
USE bodb_Summary;
GO
	SET NOCOUNT ON

	Declare @min_winlostdate smalldatetime,
	  @max_winlostdate smalldatetime

	SELECT
	 @min_winlostdate = '20240129',
	 @max_winlostdate = '20240201'
	 
	DELETE FROM dbo.sum_winloss_old WITH(NOLOCK)
	WHERE winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
		 AND CUSTID IN (109833810,109833839,109833878,1109833898,
								13924584,88557576,98754632) 
								
 
	INSERT INTO sum_winloss_old ([winlostdate],[username],[custid],[roleid],[recommend],[mrecommend],[srecommend],
	 [turnover],[winlost],[awinlost],[mwinlost],[swinlost],[playercomm],[comm],[acomm],[scomm]
	 ,[BetCount],[grosscomm],[sporttype],[bettype],[netTurnover],[TunroverNoDraw], [ExtraWinloss], [ExtraComm], [leagueGroupID], [ticketType])
	SELECT
	 [winlostdate],[username],[custid],[roleid],[recommend],[mrecommend],[srecommend],
	 [turnover],[winlost],[awinlost],[mwinlost],[swinlost],[playercomm],[comm],[acomm],[scomm]
	 ,[BetCount],[grosscomm],[sporttype],[bettype],[netTurnover],[TunroverNoDraw], [ExtraWinloss], [ExtraComm], [leagueGroupID], [ticketType]
	FROM bodb02.dbo.sum_winloss WITH(NOLOCK)
	WHERE winlostdate BETWEEN @min_winlostdate AND @max_winlostdate
		 AND CUSTID IN (109833810,109833839,109833878,109833898,
								13924584,88557576,98754632) 
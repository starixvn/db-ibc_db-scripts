/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
Create: 20230725@Lewis
Task: ReGen Data of Sum_Winloss_Old - SabaTennis [RedmineID: #190459]
DB: DBSUM-bodb_Summary

Description:
	1. RUN Script 1 to get data bk --> INSERT into sum_winloss_old_tmp (DBACC-bodb02)
	2. RUN Script 2 to reGen for sum_winloss_old (DBSUM-bodb_Summary)
*/

BEGIN
	CREATE TABLE #tmpSum_winloss
	(
		winlostdate			SMALLDATETIME
		,username			NVARCHAR(50)
		,custid				INT
		,roleid				INT
		,recommend			INT
		,mrecommend			INT
		,srecommend			INT
		,turnover			MONEY
		,winlost			MONEY
		,awinlost			MONEY
		,mwinlost			MONEY
		,swinlost			MONEY
		,playercomm			MONEY
		,comm				MONEY
		,acomm				MONEY
		,scomm				MONEY
		,BetCount			INT
		,grosscomm			MONEY
		,sporttype			SMALLINT
		,bettype			SMALLINT
		,netTurnover		MONEY
		,TurnoverNoDraw		MONEY
		,ExtraWinloss		MONEY NULL
		,ExtraComm			MONEY NULL
		,leagueGroupID		SMALLINT
		,ticketType			TINYINT
	)
	INSERT INTO #tmpSum_winloss
	(
		winlostdate
		,username
		,custid
		,roleid
		,recommend
		,mrecommend
		,srecommend
		,turnover
		,winlost
		,awinlost
		,mwinlost
		,swinlost
		,playercomm
		,comm
		,acomm
		,scomm
		,BetCount
		,grosscomm
		,sporttype
		,bettype
		,netTurnover
		,TurnoverNoDraw
		,ExtraWinloss
		,ExtraComm
		,leagueGroupID
		,ticketType
	)
	SELECT
		winlostdate
		,username
		,custid
		,roleid
		,recommend
		,mrecommend
		,srecommend
		,turnover
		,winlost
		,awinlost
		,mwinlost
		,swinlost
		,playercomm
		,comm
		,acomm
		,scomm
		,BetCount
		,grosscomm
		,sporttype
		,bettype
		,netTurnover
		,TunroverNoDraw
		,ExtraWinloss
		,ExtraComm
		,leagueGroupID
		,ticketType
	FROM DBARC.bodb_Archive.dbo.sum_winloss_old_tmp WITH (NOLOCK) 

	--regen--

	MERGE dbo.sum_winloss_old AS TARGET
	USING #tmpSum_winloss AS SOURCE
		ON		TARGET.winlostdate	= SOURCE.winlostdate
			AND	TARGET.custid		= SOURCE.custid
			AND TARGET.sporttype	= SOURCE.sporttype
			AND TARGET.bettype		= SOURCE.bettype
			AND TARGET.leagueGroupID = SOURCE.leagueGroupID
			AND TARGET.ticketType	= SOURCE.ticketType
	WHEN MATCHED THEN 
	UPDATE
		SET	TARGET.username			= SOURCE.username
			,TARGET.roleid			= SOURCE.roleid
			,TARGET.recommend		= SOURCE.recommend
			,TARGET.mrecommend		= SOURCE.mrecommend
			,TARGET.srecommend		= SOURCE.srecommend
			,TARGET.turnover		= SOURCE.turnover
			,TARGET.winlost			= SOURCE.winlost
			,TARGET.awinlost		= SOURCE.awinlost
			,TARGET.mwinlost		= SOURCE.mwinlost
			,TARGET.swinlost		= SOURCE.swinlost
			,TARGET.playercomm		= SOURCE.playercomm
			,TARGET.comm			= SOURCE.comm
			,TARGET.acomm			= SOURCE.acomm
			,TARGET.scomm			= SOURCE.scomm
			,TARGET.BetCount		= SOURCE.BetCount
			,TARGET.grosscomm		= SOURCE.grosscomm
			,TARGET.netTurnover		= SOURCE.netTurnover
			,TARGET.TunroverNoDraw	= SOURCE.TurnoverNoDraw -- TurnoverNoDraw
			,TARGET.ExtraWinloss	= SOURCE.ExtraWinloss
			,TARGET.ExtraComm		= SOURCE.ExtraComm
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT (
			winlostdate
			,username
			,custid
			,roleid
			,recommend
			,mrecommend
			,srecommend
			,turnover
			,winlost
			,awinlost
			,mwinlost
			,swinlost
			,playercomm
			,comm
			,acomm
			,scomm
			,BetCount
			,grosscomm
			,sporttype
			,bettype
			,netTurnover
			,TunroverNoDraw -- TurnoverNoDraw
			,ExtraWinloss
			,ExtraComm
			,leagueGroupID
			,ticketType
			)
	VALUES (
			SOURCE.winlostdate
			,SOURCE.username
			,SOURCE.custid
			,SOURCE.roleid
			,SOURCE.recommend
			,SOURCE.mrecommend
			,SOURCE.srecommend
			,SOURCE.turnover
			,SOURCE.winlost
			,SOURCE.awinlost
			,SOURCE.mwinlost
			,SOURCE.swinlost
			,SOURCE.playercomm
			,SOURCE.comm
			,SOURCE.acomm
			,SOURCE.scomm
			,SOURCE.BetCount
			,SOURCE.grosscomm
			,SOURCE.sporttype
			,SOURCE.bettype
			,SOURCE.netTurnover
			,SOURCE.TurnoverNoDraw
			,SOURCE.ExtraWinloss
			,SOURCE.ExtraComm
			,SOURCE.leagueGroupID
			,SOURCE.ticketType
			);

	DROP TABLE #tmpSum_winloss
END
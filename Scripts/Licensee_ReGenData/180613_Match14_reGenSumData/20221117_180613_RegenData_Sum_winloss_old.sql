 /*<info serverAlias="DBSUM-bodb_Summary"></info>*/
USE bodb_Summary

GO

/*
	Create : 20221117@Sophia
	Task : Copy data Sum_Winloss_old [Redmine: #180613] 
	DB: DBSUM.bodb_Summary
*/

--- Step 1 : delete 
WHILE 1 = 1
BEGIN 
  DELETE TOP (10000) FROM sum_winloss_old WITH (ROWLOCK) WHERE winlostdate IN ('20221108','20221109')

  IF @@ROWCOUNT = 0 
	BREAK
END

------Step 2: copy

INSERT INTO sum_winloss_old  (
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
		,ticketType )
SELECT winlostdate
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
FROM bodb02.dbo.Sum_Winloss WITH (NOLOCK) WHERE winlostdate = '20221108' 

GO

INSERT INTO sum_winloss_old  (
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
		,ticketType )
SELECT winlostdate
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
FROM bodb02.dbo.Sum_Winloss WITH (NOLOCK) WHERE winlostdate = '20221109' 
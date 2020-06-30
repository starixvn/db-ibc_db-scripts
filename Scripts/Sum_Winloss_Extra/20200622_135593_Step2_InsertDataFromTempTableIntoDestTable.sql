/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
	Created: 20200618@Malcolm
	Task: the script to create data from 2020-05-01 [Redmine: #135593]
	DB: DBSUM.bodb_Summary
*/

USE bodb_Summary
GO

INSERT INTO dbo.Sum_Winloss_Extra
(
	    WinlostDate,
		CustId,
		ProductId,
		Bettype,
		RoleID,
		Recommend,
		MRecommend,
		SRecommend,
		BetCount,
		Turnover,
		NetTurnover,
		TurnoverNoDraw,
		WinLoss,
		AgWinLoss,		
		MAgWinLoss,
		SAgWinLoss,
		ExtraWinloss,
		PlayerComm,
		AgComm,
		MAgComm,
		SAgComm,
		ExtraComm,
		GrossComm
)
SELECT	WinlostDate,
		CustId,
		ProductId,
		Bettype,
		RoleID,
		Recommend,
		MRecommend,
		SRecommend,
		BetCount,
		Turnover,
		NetTurnover,
		TurnoverNoDraw,
		WinLoss,
		AgWinLoss,		
		MAgWinLoss,
		SAgWinLoss,
		ExtraWinloss,
		PlayerComm,
		AgComm,
		MAgComm,
		SAgComm,
		ExtraComm,
		GrossComm
FROM OPENQUERY(DBARC, '
   SELECT	WinlostDate,
			CustId,
			ProductId,
			Bettype,
			RoleID,
			Recommend,
			MRecommend,
			SRecommend,
			BetCount,
			Turnover,
			NetTurnover,
			TurnoverNoDraw,
			WinLoss,
			AgWinLoss,		
			MAgWinLoss,
			SAgWinLoss,
			ExtraWinloss,
			PlayerComm,
			AgComm,
			MAgComm,
			SAgComm,
			ExtraComm,
			GrossComm
   FROM Archive.dbo.Sum_Winloss_Extra_Tmp')



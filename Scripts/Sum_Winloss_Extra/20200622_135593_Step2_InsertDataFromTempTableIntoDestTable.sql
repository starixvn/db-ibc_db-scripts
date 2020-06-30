/*<info serverAlias="DBSUM-bodb_Summary"></info>*/

/*
	Created: 20200618@Malcolm
	Task: the script to create data from 2020-05-01 [Redmine: #135593]
	DB: DBSUM.bodb_Summary
*/

USE bodb_Summary
GO

DECLARE @MinDate SMALLDATETIME, @MaxDate SMALLDATETIME

SELECT @MinDate = MIN(WinlostDate),@MaxDate = MAX(WinlostDate)
FROM DBARC.bodb_Archive.dbo.Sum_Winloss_Extra_Tmp

WHILE @MinDate <= @MaxDate
BEGIN
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
   FROM DBARC.bodb_Archive.dbo.Sum_Winloss_Extra_Tmp
   WHERE WinlostDate = @MinDate

   SET @MinDate = DATEADD(DAY,1,@MinDate)	
END


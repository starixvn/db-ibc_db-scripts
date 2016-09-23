/*
	Created by: Winnie
	Date: 2016-09-21
	Task: PRMS: Top Winners/ Winloss report: data of won tickets are not shown on report
	Regen data rmSumWinloss
*/
USE bodb_RMS
GO
		DECLARE @FromDate DATETIME
		DECLARE @ToDate DATETIME

		SELECT @FromDate= xx--MIN(winlostdate) FROM rmSumWinloss(NOLOCK)
		SELECT @ToDate=  xx--MAX(winlostdate) FROM rmSumWinloss(NOLOCK)
	  
		DELETE FROM rmSumWinloss WHERE winlostdate between @FromDate AND @ToDate
		INSERT INTO rmSumWinloss
           ([winlostdate]
           ,[custid]
           ,[sporttype]
           ,[statusid]
           ,[combo]
           ,[username]
           ,[currency]
           ,[stake]
           ,[winlost]
           ,[company_stake]
           ,[company_winlost]
           ,[actualrate]
           ,[odds]
           ,[betcount]
           ,[recommend]
           ,[parlaytype])
         SELECT [winlostdate]
           ,custid
           ,[sporttype]
           ,[statusid]
           ,[combo]
           ,[username]
           ,currency
           ,[stake]
           ,[winlost]
           ,[company_stake]
           ,[company_winlost]
           ,[actualrate]
           ,[odds]
           ,[betcount]
           ,recommend
           ,[parlaytype]
           FROM [TMPrmSumWinloss_Old_Fixdata] 
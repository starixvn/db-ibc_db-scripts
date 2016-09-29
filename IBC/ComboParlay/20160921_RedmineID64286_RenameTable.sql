/*
	Created by: Winnie
	Date: 2016-09-29
	Task: PRMS: fix data conflict refno with racing
	Regen data rmSumWinloss
*/
USE bodb_RMS
GO
		DECLARE @FromDate DATETIME
		DECLARE @ToDate DATETIME

		SELECT @FromDate= '2016-09-21'
		SELECT @ToDate=  '2016-09-25'
	  
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
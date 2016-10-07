/*
	Created by: Winnie
	Date: 2016-10-07
	Task: PRMS: fix data conflict refno with racing RedmineID:64996
	Regen data rmSumWinloss_OLD
*/
USE bodb_RMS
GO
		DECLARE @FromDate DATETIME
		DECLARE @ToDate DATETIME

		SELECT @FromDate= xx
	--07/27/16
	--08/06/16
	--08/07/16
	--08/16/16
	--08/17/16
	--08/18/16
	--08/27/16
	--08/28/16
	--09/09/16
	--09/11/16
	--09/12/16
	--09/21/16
	--09/22/16
	--09/23/16
	--09/24/16
	--09/25/16
		SELECT @ToDate=  xx
	  
		DELETE FROM rmSumWinloss_OLD WHERE winlostdate between @FromDate AND @ToDate
		INSERT INTO rmSumWinloss_OLD
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
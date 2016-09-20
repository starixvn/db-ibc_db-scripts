/*
	Created by: Winnie
	Date: 2016-09-20
	Task: PRMS: Top Winners/ Winloss report: data of won tickets are not shown on report
	Regen data 0718
*/
USE bodb_RMS
GO

	  
		DELETE FROM rmSumWinloss_Old WHERE winlostdate='2016-07-18'
		INSERT INTO rmSumWinloss_Old
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
           FROM [TMPrmSumWinloss_Old_0718] 
        
	
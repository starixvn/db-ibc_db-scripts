/*
	Created by: Winnie
	Date: 2016-09-19
	Task: PRMS: Top Winners/ Winloss report: data of won tickets are not shown on report
	Regen data 9-Sep
*/
USE bodb_RMS
GO

	  
		DELETE FROM rmSumWinloss_Old WHERE winlostdate='2016-09-05'
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
           FROM [TMPrmSumWinloss_Old_Sep8] 
        
	
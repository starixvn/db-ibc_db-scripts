/*
	Created by: Winnie
	Date: 2016-09-21
	Task: PRMS: Top Winners/ Winloss report: data of won tickets are not shown on report
	Regen data rmSumWinloss
*/
USE bodb_RMS
GO
		EXEC sp_rename 'rmSumWinloss', 'rmSumWinloss_bk';  
		GO
	
		EXEC sp_rename 'TMPrmSumWinloss_Old_Fixdata', 'rmSumWinloss';  
		
		CREATE CLUSTERED INDEX [CIX_rmSumWinloss] ON [dbo].[rmSumWinloss] 
		(
			[custid] ASC,
			[winlostdate] ASC,
			[sporttype] ASC,
			[statusid] ASC,
			[combo] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [rmSumWinloss]
		GO
		
		CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[rmSumWinloss] 
		(
			[recommend] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		GO
	
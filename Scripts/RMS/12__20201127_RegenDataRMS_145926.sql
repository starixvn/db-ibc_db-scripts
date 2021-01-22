/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
/*
	Created: 20210122@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Create clustered index table structure 
*/

CREATE UNIQUE CLUSTERED INDEX [CIX_bettransParlay] ON [dbo].[rmBettrans_uat]
(
	[transid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmTable]
GO


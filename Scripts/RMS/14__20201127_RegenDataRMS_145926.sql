/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
/*
	Created: 20201102@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Alter table structure 
*/
BEGIN

---------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
use bodb_RMS

DROP INDEX [CIX_winlostdate_bettype_statusID] ON [dbo].[rmBettrans_Old_UAT]
CREATE CLUSTERED INDEX  [CIX_rmBettrans_Old] ON [dbo].[rmBettrans_Old_UAT]
(
	[winlostdate] ASC,
	[bettype] ASC,
	[statusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP INDEX [IX_Winlostdate] ON [dbo].[rmSumWinloss_UAT]
CREATE NONCLUSTERED INDEX [IX_Winlostdate] ON [dbo].[rmSumWinloss_UAT]
(
	[winlostdate] ASC
)
INCLUDE([currency],[stake],[winlost],[company_stake],[company_winlost],[actualrate],[betcount],[parlaytype],[combo],[sporttype],[statusid],[custid],[username],[scomm],[Extra_comm],[Extra_stake],[Extra_winlost],[srecommend],[mrecommend],[recommend],[awinlost],[mwinlost],[swinlost],[actual_stake],[playercomm],[comm],[acomm]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmSumWinloss]
GO

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

DROP INDEX [IX_Winlostdate] ON [dbo].[rmSumWinloss_Old_UAT]
CREATE NONCLUSTERED INDEX [IX_Winlostdate] ON [dbo].[rmSumWinloss_Old_UAT]
(
	[winlostdate] ASC
)
INCLUDE([currency],[stake],[winlost],[company_stake],[company_winlost],[actualrate],[betcount],[parlaytype],[combo],[sporttype],[statusid],[custid],[username],[scomm],[Extra_comm],[Extra_stake],[Extra_winlost],[srecommend],[mrecommend],[recommend],[awinlost],[mwinlost],[swinlost],[actual_stake],[playercomm],[comm],[acomm]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmSumWinlossOld]
GO


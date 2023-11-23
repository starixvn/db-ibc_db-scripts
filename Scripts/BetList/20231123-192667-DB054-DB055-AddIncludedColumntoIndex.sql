/*<info serverAlias="DBBOF-bodb02" isFunction="0" isNested=""></info>*/
/*
	Created: 20231123@Kos
	DB: DBBOF.bodb02
	Task: Add included columns to index [Redmine: #192667]
*/

CREATE NONCLUSTERED INDEX [IX_betrunning_custid] ON [dbo].[bettrans]
(
	[custid] ASC,
	[bettype] ASC
)
INCLUDE([actual_stake],[adiscount],[apositiontaking],[betcheck],[betid],[betteam],[checktime],[comstatus],[discount],[hdp1],[hdp2],[ip],[liveawayscore],[livehomescore],[liveindicator],[matchid],[modds],[mpositiontaking],[odds],[oddsid],[oddsspread],[oddstype],[refno],[sdiscount],[SecAcceptFlag],[spositiontaking],[stake],[status],[statusID],[transdate],[transid],[transdesc],[ExtraInfo],[DeviceType]) 
WHERE ([statusID] IN ((0), (1)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = ON) ON [bettrans_index1]
GO

USE [bodb02]
GO

CREATE NONCLUSTERED INDEX [IX_monitor_recommend] ON [dbo].[bettrans]
(
	[recommend] ASC,
	[transid] DESC
)
INCLUDE([odds],[stake],[livehomescore],[liveawayscore],[liveindicator],[betteam],[custid],[actual_stake],[Username],[matchid],[refno],[transdate],[oddsid],[betid],[hdp1],[hdp2],[status],[ip],[oddstype],[betcheck],[transdesc],[oddsspread],[SecAcceptFlag],[checktime],[bettype],[betdaqid],[ExtraInfo],[WalletType],[RefCode],[betfrom],[currency],[modds],[DeviceType]) 
WHERE ([statusID] IN ((0), (1)))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = ON) ON [bettrans_index1]
GO



/*<info serverAlias="DBAGE-bodb02"></info>*/

/*
	Created by: Danny
	Date: 20210106
	DB: DBAGE/bodb02
	Task: ReCreate Index Include More Cols  [#redmindID: 146524]
*/


CREATE NONCLUSTERED INDEX [IX_srecommend] ON [dbo].[bettrans]
(
[srecommend] ASC,
[winlostdate] ASC
)
INCLUDE([transid],[refno],[statusID],[ruben],[currency],[winlost],[actual_stake],[playercomm],[awinlost],[comm],[mwinlost],[recommend],[acomm],[swinlost],[scomm],[mrecommend],[liveawayscore],[spositiontaking],[stake],[tpositiontaking],[oddsspread],[modds],[liveindicator],[actualrate],[apositiontaking],[mpositiontaking],[betid],[epositiontaking]) WITH (DROP_EXISTING = ON, ONLINE = OFF) ON [Bettrans_index1]
GO
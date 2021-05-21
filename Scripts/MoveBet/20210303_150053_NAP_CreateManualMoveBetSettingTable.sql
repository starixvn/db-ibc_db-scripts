/*<info serverAlias="DBTXN-bodb02" isFunction="0" isNested=""></info>*/

/*
	Created: 20210303@Danny
	DB: DBTXN-bodb02
	Task: NAP - Create manual MoveBet setting table
*/

USE bodb02 ;  
-- DROP TABLE [dbo].[Acc_ManualMovebetConfig]
CREATE TABLE [dbo].[Acc_ManualMovebetConfig](
	[MBDate] [smalldatetime] ,
	[IsBackDay1] [bit] NULL,
	[IsBackDay2] [bit] NULL,
	[IsBackDay3] [bit] NULL,
	[IsBackDay4] [bit] NULL,
	[IsBackDay5] [bit] NULL,
	[IsBackDay6] [bit] NULL,
	[IsBackDay7] [bit] NULL,
	 CONSTRAINT [PK_Acc_ManualMovebetConfig] PRIMARY KEY CLUSTERED 
	 (
		[MBDate] ASC
	)
)

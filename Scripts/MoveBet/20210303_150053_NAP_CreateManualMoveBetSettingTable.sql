/*<info serverAlias="DBTXN-bodb02" isFunction="0" isNested=""></info>*/

/*
	Created: 20210303@Danny
	DB: DBTXN-bodb02
	Task: NAP - Create manual MoveBet setting table
*/

USE bodb02 ;  

CREATE TABLE [dbo].[Acc_ManualMovebetConfig](
	[MBDate] [smalldatetime] PRIMARY KEY,
	[Isbackday1] [bit] NULL,
	[Isbackday2] [bit] NULL,
	[Isbackday3] [bit] NULL,
	[Isbackday4] [bit] NULL,
	[Isbackday5] [bit] NULL,
	[Isbackday6] [bit] NULL,
	[Isbackday7] [bit] NULL,
)



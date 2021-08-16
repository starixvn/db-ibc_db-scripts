/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
USE bodb_RMS

CREATE TABLE [dbo].[rmUserTrackingLog](
	[transid] [bigint] NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[transdate] [datetime] NOT NULL,
	[UserID] [int] NULL
)

CREATE UNIQUE CLUSTERED INDEX [CIX_rmUserTracking] ON [dbo].[rmUserTrackingLog]
(
	[transid] ASC
)

CREATE NONCLUSTERED INDEX [IX_usernameTracking] ON [dbo].[rmUserTrackingLog]
(
	[UserID] ASC
)INCLUDE([username],[transid])




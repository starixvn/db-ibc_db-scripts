/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
USE bodb_RMS

--CREATE TABLE [dbo].[rmUserTrackingLog](
--	[transid] [bigint] NOT NULL PRIMARY KEY,
--	[username] [nvarchar](50) NOT NULL,
--	[transdate] [datetime] NOT NULL,
--	[UserID] [int] NULL
--)


--CREATE NONCLUSTERED INDEX [IX_usernameTracking] ON [dbo].[rmUserTrackingLog]
--(
--	[UserID] ASC
--)INCLUDE([username],[transid])

-- Remove data test
TRUNCATE TABLE dbo.rmUserTrackingLog


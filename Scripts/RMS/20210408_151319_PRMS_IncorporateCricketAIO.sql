/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

USE bodb_RMS

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE [dbo].rmBettransm_bk
CREATE TABLE [dbo].rmBettransm_bk(
	[transid] [bigint] NOT NULL,
	[odds] [smallmoney] NULL,
	[stake] [money] NOT NULL,
	[statusID] [TINYINT] NULL,
	[refno] [bigint] NOT NULL,
	[winlostdate] [smalldatetime] NULL,
	[matchid] [int] NULL,
	[matchdate] [smalldatetime] NULL
	
	)
GO

CREATE CLUSTERED INDEX [IX_bettransm] ON [dbo].rmBettransm_bk
(
	[refno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


CREATE NONCLUSTERED INDEX [IX_winlostdate] ON [dbo].rmBettransm_bk
(
	[winlostdate] ASC
) INCLUDE ([refno], [odds], [stake], [statusID], [matchid], [transid], [matchdate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO



--DROP TABLE [dbo].[rmMatch_bk]
CREATE TABLE [dbo].[rmMatch_bk](
	[matchid] [int] NOT NULL,
	[leagueid] [int] NOT NULL,
	[eventdate] [datetime] NULL,
	[ParentID] [int] NULL,
	[ChildMatchType] [tinyint] NULL,
	[sporttype] [tinyint] NULL,
	[GlobalShowTime] [smalldatetime] NULL,
	[eventstatus] VARCHAR(50) NULL

 CONSTRAINT [PK_match_bk] PRIMARY KEY CLUSTERED 
(
	[matchid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
) 
GO

CREATE NONCLUSTERED INDEX [IX_eventdate] ON [dbo].[rmMatch_bk]
(
	[eventdate] ASC
)INCLUDE ([matchid],[leagueid],[ParentID],[ChildMatchType],[sporttype],[GlobalShowTime],[eventstatus] )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

------------------------------------------------------------------
-- INSERT DATA into rmBettransm_bk
BEGIN
	DECLARE @FromDate SMALLDATETIME, @ToDate SMALLDATETIME
	DECLARE @winlostdate SMALLDATETIME

	DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
	INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
	EXEC bodb02.dbo.Age_SelBalanceUpDay

	SELECT @ToDate = DATEADD(DAY, -1, BalanceUpDay), @FromDate = DATEADD(DAY, -31, BalanceUpDay) FROM @MBBU
	SELECT @winlostdate = @FromDate

	WHILE  @winlostdate <= @ToDate
	BEGIN
		EXEC dbo.Task_RMS_MBU_CopyData_rmBettransm_bk @winlostdate
		SELECT @winlostdate = DATEADD(DAY, 1, @winlostdate)
	END

END


grant select on rmMatch_bk to bodbRMSNet
grant select on rmBettransm_bk to bodbRMSNet


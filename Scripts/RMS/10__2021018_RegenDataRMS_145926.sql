/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
/*
	Created: 2021018@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Copy data from DB Archived
*/

SET NOCOUNT ON

DECLARE @fdate smalldatetime = '2020-05-20'
DECLARE @tdate smalldatetime = '2020-12-20'
DECLARE @__fdate smalldatetime
DECLARE @__tdate smalldatetime

BEGIN
	CREATE TABLE #rmSumWinloss_old(
				[winlostdate] [smalldatetime] NOT NULL,
				[custid] [int] NOT NULL,
				[sporttype] [smallint] NULL,
				[statusid] [tinyint] NOT NULL,
				[combo] [tinyint] NOT NULL,
				[username] [varchar](30) NOT NULL,
				[currency] [tinyint] NULL,
				[stake] [money] NULL,
				[winlost] [money] NULL,
				[company_stake] [money] NULL,
				[company_winlost] [money] NULL,
				[actualrate] [float] NULL,
				[odds] [smallmoney] NULL,
				[betcount] [int] NULL,
				[recommend] [int] NULL,
				[parlaytype] [tinyint] NULL,
				[scomm] [money] NULL,
				[Extra_comm] [money] NULL,
				[Extra_stake] [money] NULL,
				[Extra_winlost] [money] NULL,
				[mrecommend] [int] NULL,
				[srecommend] [int] NULL,
				[awinlost] [money] NULL,
				[mwinlost] [money] NULL,
				[swinlost] [money] NULL,
				[actual_stake] [money] NULL,
				[playercomm] [money] NULL,
				[comm] [money] NULL,
				[acomm] [money] NULL
			)
	
	select @__fdate = @fdate, @__tdate = @tdate

	WHILE  @__fdate <= @__tdate
	BEGIN
		truncate table #rmSumWinloss_old

		INSERT INTO #rmSumWinloss_old
		(
			winlostdate,custid,sporttype,statusID,combo,username,currency,stake,winlost
			,company_stake,company_winlost,actualrate,odds,betcount,recommend,parlaytype
			,scomm,Extra_comm,Extra_stake,Extra_winlost,
			mrecommend,srecommend,awinlost,mwinlost,swinlost,actual_stake,playercomm,comm,acomm
		)
		SELECT winlostdate,custid,sporttype,statusID,combo,username,currency,stake,winlost
			,company_stake,company_winlost,actualrate,odds,betcount,recommend,parlaytype
			,scomm,Extra_comm,Extra_stake,Extra_winlost,
			mrecommend,srecommend,awinlost,mwinlost,swinlost,actual_stake,playercomm,comm,acomm
		FROM DBARC.bodb_Archive.dbo.rmSumWinloss_old WHERE winlostdate = @__fdate

		MERGE dbo.rmSumWinloss_old_uat AS TARGET
		USING #rmSumWinloss_old AS SOURCE
			ON		TARGET.WinlostDate	= SOURCE.WinlostDate
				AND TARGET.CustId		= SOURCE.CustId
				AND TARGET.sporttype	= SOURCE.sporttype
				AND TARGET.statusID		= SOURCE.statusID
				AND TARGET.combo		= SOURCE.combo
				AND TARGET.username		= SOURCE.username
				AND TARGET.currency		= SOURCE.currency
				AND TARGET.actualrate	= SOURCE.actualrate
				AND TARGET.recommend	= SOURCE.recommend
				AND TARGET.ParlayType	= SOURCE.ParlayType
				
				
		WHEN MATCHED THEN
			UPDATE SET 
				TARGET.mrecommend		= SOURCE.mrecommend,
				TARGET.srecommend		= SOURCE.srecommend,
				TARGET.stake			= SOURCE.stake,
				TARGET.winlost			= SOURCE.winlost,
				TARGET.company_stake	= SOURCE.company_stake,
				TARGET.company_winlost	= SOURCE.company_winlost,
				TARGET.odds				= SOURCE.odds,
				TARGET.betcount			= SOURCE.betcount,
				TARGET.scomm			= SOURCE.scomm,
				TARGET.Extra_comm		= SOURCE.Extra_comm,
				TARGET.Extra_stake		= SOURCE.Extra_stake,
				TARGET.Extra_winlost	= SOURCE.Extra_winlost,
				TARGET.awinlost			= SOURCE.awinlost,
				TARGET.mwinlost			= SOURCE.mwinlost,
				TARGET.swinlost			= SOURCE.swinlost,
				TARGET.actual_stake		= SOURCE.actual_stake,
				TARGET.playercomm		= SOURCE.playercomm,
				TARGET.comm				= SOURCE.comm,
				TARGET.acomm			= SOURCE.acomm

			WHEN NOT MATCHED BY TARGET THEN
				INSERT
				(
					winlostdate,
					custid,
					sporttype,
					statusID,
					combo,
					username,
					currency,
					stake,
					winlost,
					company_stake,
					company_winlost,
					actualrate,
					odds,
					betcount,
					recommend,
					parlaytype,
					scomm,
					Extra_comm,
					Extra_stake,
					Extra_winlost,
					mrecommend,
					srecommend,
					awinlost,
					mwinlost,
					swinlost,
					actual_stake,
					playercomm,
					comm,
					acomm
				)
				VALUES
				(
					SOURCE.winlostdate,
					SOURCE.custid,
					SOURCE.sporttype,
					SOURCE.statusID,
					SOURCE.combo,
					SOURCE.username,
					SOURCE.currency,
					SOURCE.stake,
					SOURCE.winlost,
					SOURCE.company_stake,
					SOURCE.company_winlost,
					SOURCE.actualrate,
					SOURCE.odds,
					SOURCE.betcount,
					SOURCE.recommend,
					SOURCE.parlaytype,
					SOURCE.scomm,
					SOURCE.Extra_comm,
					SOURCE.Extra_stake,
					SOURCE.Extra_winlost,
					SOURCE.mrecommend,
					SOURCE.srecommend,
					SOURCE.awinlost,
					SOURCE.mwinlost,
					SOURCE.swinlost,
					SOURCE.actual_stake,
					SOURCE.playercomm,
					SOURCE.comm,
					SOURCE.acomm
				) ;
		SELECT @__fdate = DATEADD(DAY,1, @__fdate)
	END
	DROP TABLE #rmSumWinloss_old


	DECLARE @fdate_Original smalldatetime = '2018-01-01'
	DECLARE @tdate_Original smalldatetime = '2020-05-19'
	DECLARE @__fdate_ori smalldatetime
	DECLARE @__tdate_ori smalldatetime

	select @__fdate_ori = @fdate_Original, @__tdate_ori = @tdate_Original

	WHILE  @__fdate_ori <= @__tdate_ori
	BEGIN
		INSERT INTO dbo.rmSumWinloss_old_uat 
		(
				winlostdate,custid,sporttype,statusID,combo,username,currency,stake,winlost
				,company_stake,company_winlost,actualrate,odds,betcount,recommend,parlaytype
				,scomm,Extra_comm,Extra_stake,Extra_winlost
		)
		SELECT winlostdate,custid,sporttype,statusID,combo,username,currency,stake,winlost
				,company_stake,company_winlost,actualrate,odds,betcount,recommend,parlaytype
				,scomm,Extra_comm,Extra_stake,Extra_winlost
		FROM dbo.rmSumWinloss_old WITH(NOLOCK)
		WHERE winlostdate = @__fdate_ori

		SELECT @__fdate_ori = DATEADD(DAY,1, @__fdate_ori)
	END


END


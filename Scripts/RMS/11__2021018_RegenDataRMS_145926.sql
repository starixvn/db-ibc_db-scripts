/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
/*
	Created: 2021018@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Copy data from DB Archived
*/

SET NOCOUNT ON

DECLARE @fdate smalldatetime = '2020-12-17'
DECLARE @tdate smalldatetime = '2020-12-20'
DECLARE @__fdate smalldatetime
DECLARE @__tdate smalldatetime

BEGIN
	
	
	select @__fdate = @fdate, @__tdate = @tdate

	WHILE  @__fdate <= @__tdate
	BEGIN

		DELETE t 
		FROM  dbo.rmSumWinloss_old_uat t WITH(ROWLOCK)
		WHERE winlostdate = @__fdate

		INSERT INTO dbo.rmSumWinloss_old_uat
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
		

		SELECT @__fdate = DATEADD(DAY,1, @__fdate)
	END
	
END


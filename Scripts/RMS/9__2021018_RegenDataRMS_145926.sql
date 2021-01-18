/*<info serverAlias="DBARC-bodb_Archive" isFunction="0" isNested=""></info>*/
/*
	Created: 2021018@Danny
	DB: DBARC.bodb_Archive
	Task: PRMS - Insert data into staging table
*/

SET NOCOUNT ON

DECLARE @fdate smalldatetime = '2020-03-01'
DECLARE @tdate smalldatetime = '2020-12-20'
DECLARE @__fdate smalldatetime
DECLARE @__tdate smalldatetime

BEGIN
	select @__fdate = @fdate, @__tdate = @tdate
	WHILE  @__fdate <= @__tdate
	BEGIN
		exec RMS_ARC_rmSumwinloss_OLD_Ins @winlostdate = @__fdate
		SELECT @__fdate = DATEADD(DAY,1, @__fdate)
	END
END


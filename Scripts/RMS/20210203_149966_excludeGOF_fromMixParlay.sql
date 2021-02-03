/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/

/*
	Created: 20210203@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Exclude GOF from mix parlay
*/

USE bodb_RMS ;  

SET NOCOUNT ON

	DECLARE @fdate smalldatetime = '2021-01-26'
	DECLARE @tdate smalldatetime

	SELECT @tdate = MAX(winlostdate) FROM rmSumWinloss WITH(NOLOCK)

	DECLARE @__fdate smalldatetime
	DECLARE @__tdate smalldatetime


	select @__fdate = @fdate, @__tdate = @tdate

	WHILE  @__fdate <= @__tdate
	BEGIN
		EXEC dbo.Task_RMS_MBU_CheckSumData_rmSumWinloss @__fdate
		SELECT @__fdate = DATEADD(DAY,1, @__fdate)
	END



GO  




/*<info serverAlias="DBTXN-bodb02" executers="" viewers="" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[ExecRep_12]
(
	@TransIdList VARCHAR(MAX) = ''
)
AS
/*
 	Creator: 20210323@Patrick
	Task: ExecRep_12
	DB: DBTXN/bodb02
	Revisions:
		- 20210323@Patrick: Initial [Redmine: #149927]  
		- 20211231@Sol: copy data to transfer and transferInfo - [Redmine: #162264]
 */

BEGIN
	SET NOCOUNT ON

	IF OBJECT_ID(N'dbo.bettrans', N'U') IS NULL
	BEGIN
		RETURN
	END

	CREATE TABLE #TransIdList(TransId BIGINT PRIMARY KEY)
	
	---get list transid from string to temp table
	INSERT INTO #TransIdList(TransId)
	SELECT f.val
	FROM dbo.f_SplitString(@TransIdList, ',') f
	OPTION (MAXRECURSION 0)

	---delete data in bettrans
	DELETE FROM dbo.bettrans WHERE transid IN (SELECT TransId FROM #TransIdList)

	---drop table temp
	DROP TABLE #TransIdList
END


/*<info serverAlias="DBTXN-bodb02" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE dbo.Transfer_ExecRep_02
(
	@TransIdList VARCHAR(MAX) = ''
)
AS
/*
    Created by: 20211227@Kathy
    Task: transfer SP 
    DB: DBTXN/BODB02 

	Revisions:
		- 20211231@Sol: delete data from bettrans - [Redmine: #162264]
*/

BEGIN
	SET NOCOUNT ON

	CREATE TABLE #TransIdList(TransId BIGINT)
	
	---get list transid from string to temp table
	INSERT INTO #TransIdList(TransId)
	SELECT f.val
	FROM bodb02.dbo.f_SplitString(@TransIdList, ',') f
	OPTION (MAXRECURSION 0)

	DELETE FROM bodb02.dbo.bettrans WHERE transid IN (SELECT TransId FROM #TransIdList)
	
	---drop table temp
	DROP TABLE #TransIdList

END
GO
/*
	Created: 20170803@Winnie
	Task: Modify Virtual Rate data following new requirements RedmineID: #81115
	DB: DBCUST/CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
	CREATE TABLE #supers (custid int)

	INSERT INTO #supers(custid)
	SELECT ci.custid
	FROM dbo.customer ci WITH (NOLOCK) 
	 INNER JOIN dbo.Dep_CustSuper cs WITH (NOLOCK) ON ci.custid = cs.custid
	WHERE ci.roleid = 4  

	DECLARE @bitmap200 BINARY(64) = 0xDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDC

	SELECT DISTINCT cs.custid
	INTO #temp
	FROM dbo.CustVirtualSetting cs WITH (NOLOCK) 
		INNER JOIN DBLOG.bodb_CustomerLog.dbo.UserLog_VirtualRateSettings ci WITH (NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #supers s ON ci.srecommend = s.custid
	WHERE bitmapVirtual = @bitmap200
	 AND seqNo = 1

	UPDATE cvs
		SET cvs.bitmapVirtual=0x46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
	FROM	[dbo].[CustVirtualSetting] cvs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #temp t ON cvs.custid=t.custid
	
	DROP TABLE #temp
	DROP TABLE #supers
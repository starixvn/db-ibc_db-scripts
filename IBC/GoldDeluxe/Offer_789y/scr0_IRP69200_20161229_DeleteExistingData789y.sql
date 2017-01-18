/*
	Created: Johnson
	Date: 2016-12-29
	Task: remove existing GD data for 789y
	DB: DBCUST/CUSTDB
*/


 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
 
  ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbcust only
	
	IF NOT ( dbo.f_CheckRepTable('Customer') = 1 
		AND dbo.f_CheckRepTable('CustInfo') = 1 )
		RETURN
	
	SELECT custid
	INTO #supers
	FROM Customer WITH(NOLOCK)
	WHERE site = '789y'
		AND roleid = 4
		
	IF ( dbo.f_CheckRepTable('CustOverrideGame') = 1 
		AND dbo.f_CheckRepTable('CustSettingGame') = 1
		)
	BEGIN			
		DELETE cs
		FROM custSettingGame cs WITH(UPDLOCK,ROWLOCK)	
			INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE cs.sporttype = 255
			AND cs.bettype = 1701
			AND ci.srecommend IN (SELECT custid FROM #supers)
		
		DELETE cs
		FROM custOverrideGame cs WITH(UPDLOCK,ROWLOCK)			
			INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE cs.sporttype = 255
			AND cs.bettype = 1701
			AND ci.srecommend IN (SELECT custid FROM #supers)
	END
	
	IF (  dbo.f_CheckRepTable('custGameType') = 1 )
	BEGIN
		DELETE cs
		FROM CustGameType cs WITH(UPDLOCK,ROWLOCK)	
			INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE cs.GameTypeID IN (1701,1702)			
			AND ci.srecommend IN (SELECT custid FROM #supers)
	END
	
	IF NOT(  dbo.f_CheckRepTable('custWinLimit') = 1 ) 
		RETURN
	
	DELETE cw
	FROM custWinLimit cw WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cw.custid = ci.custid
	WHERE cw.sporttype = 255
		AND cw.bettype = 1701
		AND ci.srecommend IN (SELECT custid FROM #supers)
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------

EXEC dbo.[Acc_CustSetting3rd_19] 
		@target = 'REPLICATED'
		
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
EXEC dbo.[Acc_CustSetting3rd_19]
		@target = 'DBCUST'
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
  
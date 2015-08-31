   /*
	Created: Johnson
	Date: 2015-05-11
	Task: Delete existing Gold Deluxe settings for UUS's customers
	DB: DBTXN/CustDB
 */
 
 
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
 
  ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbcust only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 		
	   )
	  RETURN

	IF (dbo.f_CheckRepTable('CustOverrideGame') = 1 
		AND dbo.f_CheckRepTable('CustSettingGame') = 1 
		)
	BEGIN			
		DELETE cs
		FROM custSettingGame cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN custinfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ci.srecommend = @srecommend 
			AND ci.custid <= @maxcustid
			AND cs.sporttype = 255
			AND cs.bettype = 1701
		
			DELETE cs
		FROM custOverrideGame cs WITH(UPDLOCK,ROWLOCK)
			INNER JOIN custinfo ci WITH(NOLOCK) ON cg.custid = ci.custid
		WHERE ci.srecommend = @srecommend 
			AND ci.custid <= @maxcustid
			AND cs.sporttype = 255
			AND cs.bettype = 1701
	END
	
	IF NOT(dbo.f_CheckRepTable('custWinLimit') = 1 )
		RETURN
	
	DELETE cw
	FROM custWinLimit cw WITH(UPDLOCK,ROWLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cw.custid = ci.custid
	WHERE ci.srecommend = @srecommend 
		AND ci.custid <= @maxcustid
		AND cw.sporttype = 255
		AND cw.bettype = 1701
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 
	AND currency = 20 
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------

CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 
	AND currency = 20 
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
  
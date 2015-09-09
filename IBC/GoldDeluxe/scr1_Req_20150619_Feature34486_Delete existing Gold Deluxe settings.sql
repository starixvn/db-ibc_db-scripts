   /*
	Created: Johnson
	Date: 2015-05-11
	Task: Delete existing Gold Deluxe settings for UUS's customers
	DB: DBTXN/CustDB
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
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo')) <> 1
		RETURN

	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('CustOverrideGame','CustSettingGame')) =2	
	BEGIN			
		DELETE cs
		FROM custSettingGame cs WITH(UPDLOCK,ROWLOCK)			
		WHERE cs.sporttype = 255
			AND cs.bettype = 1701
		
		DELETE cs
		FROM custOverrideGame cs WITH(UPDLOCK,ROWLOCK)			
		WHERE cs.sporttype = 255
			AND cs.bettype = 1701
	END
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('custWinLimit')) <> 1
		RETURN
	
	DELETE cw
	FROM custWinLimit cw WITH(UPDLOCK,ROWLOCK)
	WHERE cw.sporttype = 255
		AND cw.bettype = 1701
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
  
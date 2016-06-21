	
	
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbcust only
	
	IF dbo.f_CheckRepTable('CustSetting') = 0 RETURN
			
	CREATE TABLE #SportTypeBetType (SportType SMALLINT, Bettype SMALLINT)
	INSERT INTO #SportTypeBetType
	VALUES(2,10)
		,(3,10)
		,(5,10)
		,(8,10)
		,(10,10)
		,(11,10)
		,(99,10)

	DELETE T
	FROM Dep_CustSetting T	
		INNER JOIN #SportTypeBetType T1 ON T.sporttype = T1.SportType AND T.bettype = T1.Bettype
	DROP TABLE #SportTypeBetType
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
EXEC dbo.[Acc_CustSetting3rd_19] @target = 'REPLICATED'


-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
EXEC dbo.[Acc_CustSetting3rd_19] @target = 'DBCUST'

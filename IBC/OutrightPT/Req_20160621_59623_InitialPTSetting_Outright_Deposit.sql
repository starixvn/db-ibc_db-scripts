

/*
	Created: Helen
	Task: Initial PT setting on Outright of these 7 sports: Copied from Sport - HDP PT - [Redimine:59438]
	DB: DBCUST/CustDB
	Date: 20160621
*/ 

ALTER PROCEDURE [dbo].[Acc_CustSetting_19]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('Dep_custsetting') = 0 RETURN

	CREATE TABLE #DownlineListTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)
	
	CREATE TABLE #SportTypeBetType (SportType SMALLINT, Bettype SMALLINT)
	INSERT INTO #SportTypeBetType
	VALUES(2,10)
		,(3,10)
		,(5,10)
		,(8,10)
		,(10,10)
		,(11,10)
		,(99,10)
	
	INSERT INTO #DownlineListTemp (CustID)
	SELECT custid
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND Enabled = 1 AND custid <= @maxcustid
	
	INSERT INTO Dep_custsetting (custid, sporttype,Bettype
							,apositiontaking
							,mpositiontaking
							,spositiontaking )
	
	SELECT t.custid, bt.sporttype,bt.Bettype
			,apositiontaking
			,mpositiontaking
			,spositiontaking
	FROM #DownlineListTemp t
		INNER JOIN Dep_custsetting cs (NOLOCK) ON t.CustID = cs.custid
		CROSS JOIN #SportTypeBetType bt 
	WHERE cs.sporttype = 1 AND cs.bettype = 10
	
	DROP TABLE #DownlineListTemp
	DROP TABLE #SportTypeBetType
	
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT custid,currency
FROM  Dep_CustSuper WITH(NOLOCK) 
WHERE custid <= @max_custid 
 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_CustSetting_19 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT custid,currency
FROM  Dep_CustSuper WITH(NOLOCK) 
WHERE custid <= @max_custid

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_CustSetting_19 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END


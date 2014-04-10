  /*
	Created: Jerry Tran
	Date: 2014-04-10
	Task: Offer Virtual Cycling and Virtual Speedway for all licensees (UUS only)
	DB: DBTXN/CustDB
 */


-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

	DECLARE @bettype1201 int, @sporttype180 int
	
	SELECT @bettype1201 = 1201, @sporttype180 =180
	
	
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo') AND type = 'U'
		) <> 1 RETURN 
	 					
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch183 = maxpermatch180,
	    maxpermatch185 = maxpermatch180
	WHERE srecommend = @srecommend 
		
		
						
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('Dep_CustSetting3rd') AND type = 'U'
		) <> 1 RETURN	

   -- create temp table containing all accounts belong to super
	CREATE TABLE #tblCust (custid int, sporttype int, bettype int)
	
	INSERT INTO #tblCust (custid, sporttype,bettype)
		SELECT custid, sporttype, bettype
		FROM custinfo with (nolock)
		CROSS JOIN (
					SELECT 183 as sporttype, 1231 as bettype 
					UNION ALL
					SELECT 185 as sporttype, 1231 as bettype 
				) t
	    WHERE srecommend = @srecommend

	UPDATE newVS WITH(UPDLOCK,ROWLOCK)
	SET     newVS.spositiontaking = VS.spositiontaking
			, newVS.mpositiontaking = VS.mpositiontaking
			, newVS.apositiontaking = VS.apositiontaking
			, newVS.sdiscount = VS.sdiscount
			, newVS.adiscount = VS.adiscount
			, newVS.discount = VS.discount
			, newVS.playerdiscount = VS.playerdiscount
			, newVS.minbet = VS.minbet
			, newVS.maxbet = VS.maxbet
	FROM Dep_CustSetting3rd newVS 
	INNER JOIN  Dep_CustSetting3rd  VS with (nolock) 
		ON newVS.custid = VS.custid and VS.sporttype = @sporttype180  and VS.bettype = @bettype1201
	INNER JOIN #tblCust t 
		ON newVS.custid = t.custid and newVS.sporttype = t.sporttype and newVS.bettype = t.bettype
	where   newVS.spositiontaking <> VS.spositiontaking
			or newVS.mpositiontaking <> VS.mpositiontaking
			or newVS.apositiontaking <> VS.apositiontaking
			or newVS.sdiscount <> VS.sdiscount
			or newVS.adiscount <> VS.adiscount
			or newVS.discount <> VS.discount
			or newVS.playerdiscount <> VS.playerdiscount
			or newVS.minbet <> VS.minbet
			or newVS.maxbet <> VS.maxbet

    -- Remove account that having Virtual Cycling, Virtual Speedway setting 
	 DELETE t 
	 FROM #tblCust t 
	 INNER JOIN Dep_CustSetting3rd cs on t.custid = cs.custid and t.sporttype = cs.sporttype and t.bettype = cs.bettype 
	 
	 	
	INSERT INTO [dbo].[Dep_CustSetting3rd]
			   ([custid]
			   ,[bettype]
			   ,[sporttype]
			   ,[islive]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[minbet]
			   ,[maxbet])
	SELECT cs.custid
		   ,t.bettype as [bettype]
		   ,t.sporttype as [sporttype]
		   ,[islive]
		   ,[apositiontaking]
		   ,[mpositiontaking]
		   ,[spositiontaking]
		   ,[playerdiscount]
		   ,[discount]
		   ,[adiscount]
		   ,[sdiscount]
		   ,[minbet]
		   ,[maxbet]
	FROM Dep_CustSetting3rd cs with(NOLOCK)
	INNER JOIN #tblCust t on cs.custid = t.custid and cs.sporttype = @sporttype180 and cs.bettype = @bettype1201
	
	DROP TABLE #tblCust
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------




-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------

CREATE TABLE #Supers (custid INT PRIMARY KEY, isfinished bit default(0))
Declare @srecommend int 

INSERT INTO #Supers(custid)
SELECT custid 
FROM Dep_CustSuper with(NOLOCK) where currency = 20

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend		
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
------------------------------------------------------



-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #Supers (custid INT PRIMARY KEY, isfinished bit default(0))
Declare @srecommend int 

INSERT INTO #Supers(custid)
SELECT custid 
FROM Dep_CustSuper with(NOLOCK) where currency = 20


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend		
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------


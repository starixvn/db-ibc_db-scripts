/*
	Created: Winnie
	Date: 2016-11-18
	Task: Insert VR settings for Cricket UUS
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------

ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]	
	@target VARCHAR(30),@srecommend INT,@max_custid INT
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
			AND dbo.f_CheckRepTable('CustVirtualSetting') = 1
			AND dbo.f_CheckRepTable('ProfileVirtualSetting') = 1
			)
		RETURN
	
	DECLARE @profile_1x2_Live			INT,
		@profile_1x2_NonLive		INT,
		@profile_MoneyLine_Live		INT,
		@profile_MoneyLine_NonLive	INT
			
	CREATE TABLE #tempCustVirtualSetting(
	[custid] [int] NOT NULL,
	[seqNo] [tinyint] NOT NULL,
	[bitmapVirtual] [binary](64) NOT NULL)		
	
	SELECT @profile_1x2_Live=129,@profile_1x2_NonLive=130
	
	SELECT @profile_MoneyLine_Live= ProfileID 
	FROM ProfileVirtualSetting WITH(NOLOCK) WHERE sporttype=27 AND bettype=20 and islive=1
	
	SELECT @profile_MoneyLine_NonLive= ProfileID 
	FROM ProfileVirtualSetting WITH(NOLOCK) WHERE sporttype=27 AND bettype=20 and islive=0
	
	INSERT INTO CustVirtualSetting([custid],[seqNo],[bitmapVirtual])
	SELECT cvs.custid,3,
	CONVERT(binary(64), STUFF(
	CONVERT(binary(64), STUFF(0x64646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464, 1+((@profile_1x2_Live-1)%64), 1, SUBSTRING(bitmapVirtual,   1+((@profile_MoneyLine_Live-1)%64), 1)))
	,1+((@profile_1x2_NonLive-1)%64), 1,SUBSTRING(bitmapVirtual,   1+((@profile_MoneyLine_NonLive-1)%64), 1)))
		
	FROM        CustVirtualSetting    AS cvs WITH (NOLOCK) 
	INNER JOIN	dbo.custInfo AS ci WITH(NOLOCK) ON	ci.custid = cvs.custid   
    WHERE cvs.seqNo=2 AND ci.custid<=@max_custid AND ci.srecommend = @srecommend
	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------

CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @max_custid INT, @srecommend INT
SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM customer WITH(NOLOCK)
WHERE roleid = 4 AND currency=20 AND custid <= @max_custid

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend			
			,@target = 'REPLICATED',@max_custid=@max_custid
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @max_custid INT, @srecommend INT
SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM customer WITH(NOLOCK)
WHERE roleid = 4 AND currency=20 AND custid <= @max_custid AND @max_custid=@max_custid

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend			
			,@target = 'DBCUST'
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------


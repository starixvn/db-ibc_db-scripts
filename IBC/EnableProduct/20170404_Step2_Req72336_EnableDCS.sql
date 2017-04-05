

/*
	Created: Winnie	
	Task: Enable and UnHide Macau + AllBet + FW + NG2 for SMA
	DB: DBCUST/CustDB
	Date: 20170405
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
	,@StrDisabledAndHide VARCHAR(MAX)	
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
		RETURN		
		
	UPDATE cs
	SET									
		 bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (cs.bitmapIsDisabled, @StrDisabledAndHide))	
		 ,bitmapIsHidden =  (select bitmap from dbo.f_GenerateProductStatus_multiple (cs.bitmapIsHidden, @StrDisabledAndHide))
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
	WHERE cs.CustID<=@maxcustid AND ci.srecommend = @srecommend AND ci.roleid IN(2,3,4)			
			

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

CREATE TABLE #bitmapOrder (bitmapOrder INT,Disable BIT default(0))
DECLARE  @srecommend INT,@max_custid INT
SELECT @max_custid = xxx

DECLARE @xmlStrDisabledAndHide XML
DECLARE @StrDisabledAndHide VARCHAR(MAX)

INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(4)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(5)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(6)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(7)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(8)


SET @xmlStrDisabledAndHide = (
				SELECT (
						SELECT bitmapOrder	AS '@b'
							, Disable	AS '@s'
						FROM #bitmapOrder
						FOR XML PATH('r')
							, TYPE
						)
				FOR XML PATH('root')
					, TYPE
				)						
SELECT @StrDisabledAndHide=CONVERT(VARCHAR(MAX),@xmlStrDisabledAndHide)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
)
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			,@StrDisabledAndHide=@StrDisabledAndHide		
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

CREATE TABLE #bitmapOrder (bitmapOrder INT,Disable BIT default(0))
DECLARE  @srecommend INT,@max_custid INT
SELECT @max_custid = xxx
DECLARE @xmlStrDisabledAndHide XML
DECLARE @StrDisabledAndHide VARCHAR(MAX)

INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(4)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(5)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(6)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(7)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(8)

SET @xmlStrDisabledAndHide = (
				SELECT (
						SELECT bitmapOrder	AS '@b'
							, Disable	AS '@s'
						FROM #bitmapOrder
						FOR XML PATH('r')
							, TYPE
						)
				FOR XML PATH('root')
					, TYPE
				)										
			
SELECT @StrDisabledAndHide=CONVERT(VARCHAR(MAX),@xmlStrDisabledAndHide)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
)
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			,@StrDisabledAndHide=@StrDisabledAndHide	
						
	waitfor delay '00:00:0.280'
END


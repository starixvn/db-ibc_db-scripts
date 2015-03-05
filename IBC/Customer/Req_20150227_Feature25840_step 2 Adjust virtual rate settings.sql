 /*
	Created: Johnson
	Date: 2015-02-27
	Task: Virtual Rate - Separate setting into sport types and bet types
	DB: DBTXN/CustDB
	
	Steps: RUN AT UM
		- correct virtual rate settings 
		- copy settings for newly created customers
*/

--step 1: correct virtual rate settings for customers have been updated settings while copying virtual rate settings
DECLARE @max_custid INT
SELECT @max_custid = xxx

SELECT custid, ci.VirtualMultiplier
INTO #tmpCust
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN CustVirtualRate cv WITH(NOLOCK) ON ci.custid = cv.custid AND cv.sporttype = 1 AND cv.bettype = 1
WHERE ci.custid <= @max_custid 
	AND ci.custid <> 1176092 --member01 : testing account
	AND ci.recommend <> 14228863 --STAFFTWPG
	AND ci.VirtualMultiplier <> cv.VirtualMultiplier
	
GO

UPDATE cv
SET cv.VirtualMultiplier = t.VirtualMultiplier
FROM [CustVirtualRate] cv WITH(UPDLOCK,ROWLOCK)
	INNER JOIN #tmpCust t ON cv.custid = t.custid
GO


--step 2: copy settings for newly created customers
DECLARE @max_custid INT
SELECT @max_custid = xxx

INSERT INTO [dbo].[CustVirtualRate]
			   ([custid]
			   ,[sporttype]
			   ,[bettype]
			   ,[isLive]
			   ,[virtualMultiplier])		
SELECT custid,
	t.sporttype,
	t.bettype,
	b.isLive,
	ci.virtualMultiplier
FROM CustInfo ci WITH(NOLOCK)
	CROSS APPLY 
	(
	SELECT 1 as sporttype, 1 as bettype
	UNION 
	SELECT 1 as sporttype, 2 as bettype
	UNION 
	SELECT 1 as sporttype, 3 as bettype
	UNION 
	SELECT 1 as sporttype, 7 as bettype
	UNION 
	SELECT 1 as sporttype, 8 as bettype
	UNION 
	SELECT 1 as sporttype, 12 as bettype			
	UNION 
	SELECT 99 as sporttype, 1 as bettype
	UNION 
	SELECT 99 as sporttype, 2 as bettype
	UNION 
	SELECT 99 as sporttype, 3 as bettype
	UNION 
	SELECT 99 as sporttype, 7 as bettype
	UNION 
	SELECT 99 as sporttype, 8 as bettype
	UNION 
	SELECT 99 as sporttype, 12 as bettype 
	UNION 
	SELECT 99 as sporttype, 20 as bettype 
	UNION 
	SELECT 99 as sporttype, 21 as bettype 
	UNION 
	SELECT 99 as sporttype, 154 as bettype 
	UNION 
	SELECT 99 as sporttype, 1301 as bettype 
	UNION 
	SELECT 99 as sporttype, 1311 as bettype 
	UNION 
	SELECT 99 as sporttype, 1324 as bettype 
	) t
	CROSS APPLY (
	SELECT 0 as isLive
	UNION 
	SELECT 1 as isLive
	)b
WHERE ci.custid > @max_custid		 	
GO


		

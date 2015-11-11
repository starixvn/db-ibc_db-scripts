/*
	Created: Elodie
	Date: 2015-10-19
	Task: adjust Muay Thai settings after copying for 12BET
	DB: DBCUST/CustDB
	Runtime: UM
*/ 
--STEP 1: copy settings for newly created deposit customers
CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site = '12Bet')	
	AND currency IN (2,3,4,6,9,12,13,15,16,17,22,33,34,35,36,40,43,44,45,47,51,61,62,64,65,66,68)
GO

DECLARE @maxcustid INT 
SELECT @maxcustid = xx --lastest custid

INSERT INTO [dbo].[Dep_CustSetting]
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
SELECT cs.[custid]
		,[bettype]
        ,44
        ,[islive]
        ,[apositiontaking]
        ,[mpositiontaking]
        ,[spositiontaking]
        ,[playerdiscount]
        ,[discount]
        ,[adiscount]
        ,[sdiscount]
        ,CASE	WHEN currency = 2 THEN 5  -- MYR
				WHEN currency IN (15,22,33,34,47) THEN 15  --IDR
				WHEN currency = 61 THEN 75  --INR
				WHEN currency IN (44,45,62) THEN 1000  --KRW
				WHEN currency IN (13,66) THEN 10  --CNY
				WHEN currency IN (4,43) THEN 50  --THB
				WHEN currency = 51 THEN 30  --VND
				WHEN currency IN (9,6,12) THEN 1 --AUD,EUR,GBP
			ELSE minbet END
        ,CASE	WHEN currency = 2 THEN 2000  --RM
				WHEN currency IN (15,22,33,34,47) THEN 5000  --IDR
				WHEN currency = 61 THEN 25000  --INR
				WHEN currency IN (44,45,62) THEN 500000  --KRW
				WHEN currency IN (13,66) THEN 3000  --CNY
				WHEN currency IN (4,43) THEN 20000  --THB
				WHEN currency = 51 THEN 10000  --VND
				WHEN currency IN (9,6,12) THEN 100 --AUD,EUR,GBP
				ELSE maxbet END
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND currency IN (2,4,6,9,12,13,15,22,33,34,43,44,45,47,51,61,62,66)
		AND ci.custid > @maxcustid
		AND sporttype = 99 and bettype = 3	
	
INSERT INTO [dbo].[Dep_CustSetting]
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
SELECT cs.[custid]
		,[bettype]
        ,44
        ,[islive]
        ,[apositiontaking]
        ,[mpositiontaking]
        ,[spositiontaking]
        ,0 AS playerdiscount
		,0 AS discount
        ,0 AS adiscount
        ,0 AS sdiscount
        ,minbet
		,maxbet
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND currency IN (3,16,17,35,36,40,64,65,68) --USD
		AND roleid IN (4,3)
		AND ci.custid > @maxcustid
		AND sporttype = 99 and bettype = 3	 	

INSERT INTO [dbo].[Dep_CustSetting]
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
SELECT cs.[custid]
		,[bettype]
        ,44
        ,[islive]
        ,[apositiontaking]
        ,[mpositiontaking]
        ,[spositiontaking]
        ,[playerdiscount]
        ,[discount]
        ,[adiscount]
        ,[sdiscount]
        ,1
		,500
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND currency IN (3,16,17,35,36,40,64,65,68) --USD
		AND roleid IN (2,1)
		AND ci.custid > @maxcustid
		AND sporttype = 99 and bettype = 3	
		AND recommend IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05	

INSERT INTO [dbo].[Dep_CustSetting]
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
SELECT cs.[custid]
		,[bettype]
        ,44
        ,[islive]
        ,[apositiontaking]
        ,[mpositiontaking]
        ,[spositiontaking]
        ,[playerdiscount]
        ,[discount]
        ,[adiscount]
        ,[sdiscount]
        ,1
		,100
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND currency IN (3,16,17,35,36,40,64,65,68) --USD
		AND roleid IN (2,1)
		AND ci.custid > @maxcustid
		AND sporttype = 99 and bettype = 3	
		AND recommend NOT IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05	

--STEP 2: Adjust settings for super, master 12Bet

--adjust [Dep_CustSetting]
UPDATE cs1
SET	cs1.[minbet] = cs2.[minbet]
	,cs1.[maxbet] = cs2.[maxbet]	
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN [Dep_CustSetting] cs1 WITH(UPDLOCK,ROWLOCK) ON cs1.custid = ci.custid AND cs1.sporttype  = 44 AND cs1.bettype = 3
	INNER JOIN [Dep_CustSetting] cs2 WITH(NOLOCK) ON cs2.custid = ci.custid AND cs2.sporttype = 99 AND cs2.bettype = 3
WHERE ci.srecommend IN (SELECT custid FROM #supers)	
	AND currency IN (3,16,17,35,36,40,64,65,68) --USD
	AND roleid IN (4,3)
	AND ci.custid > @maxcustid
	AND ( cs1.[minbet] <> cs2.[minbet]
		   OR cs1.[maxbet] <> cs2.[maxbet])

UPDATE cs1
SET	cs1.[apositiontaking] = cs2.[apositiontaking]
	,cs1.[mpositiontaking] = cs2.[mpositiontaking]
	,cs1.[spositiontaking] = cs2.[spositiontaking]
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN [Dep_CustSetting] cs1 WITH(UPDLOCK,ROWLOCK) ON cs1.custid = ci.custid AND cs1.sporttype  = 44 AND cs1.bettype = 3
	INNER JOIN [Dep_CustSetting] cs2 WITH(NOLOCK) ON cs2.custid = ci.custid AND cs2.sporttype = 99 AND cs2.bettype = 3
WHERE ci.srecommend IN (SELECT custid FROM #supers)	
	AND ci.custid > @maxcustid
	AND ( cs1.[apositiontaking] = cs2.[apositiontaking]
		   OR cs1.[mpositiontaking] = cs2.[mpositiontaking]
		   OR cs1.[spositiontaking] = cs2.[spositiontaking])
GO		 
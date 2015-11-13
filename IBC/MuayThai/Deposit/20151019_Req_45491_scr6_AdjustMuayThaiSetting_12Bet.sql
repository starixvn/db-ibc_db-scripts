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

--Copy setting from Other Sports for super, master
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
        ,minbet
		,maxbet
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND sporttype = 99 and bettype = 3
		AND ci.custid > @maxcustid	 
		AND roleid IN (4,3)
		
--Insert setting with specific value for agent, member except 12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05		
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
				WHEN @currency IN (3,16,17,35,36,40,64,65,68) THEN 1  --USD
			ELSE minbet END
        ,CASE	WHEN currency = 2 THEN 2000  --RM
				WHEN currency IN (15,22,33,34,47) THEN 5000  --IDR
				WHEN currency = 61 THEN 25000  --INR
				WHEN currency IN (44,45,62) THEN 500000  --KRW
				WHEN currency IN (13,66) THEN 3000  --CNY
				WHEN currency IN (4,43) THEN 20000  --THB
				WHEN currency = 51 THEN 10000  --VND
				WHEN currency IN (9,6,12) THEN 100 --AUD,EUR,GBP
				WHEN @currency IN (3,16,17,35,36,40,64,65,68) THEN 100  --USD
				ELSE maxbet END
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND sporttype = 99 and bettype = 3
		AND roleid IN (2,1)
		AND ci.custid > @maxcustid
		AND ci.recommend NOT IN (18839496,18839497,13880633,13880635,10393717,10842822) 

--Insert setting with specific value for 12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
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
		AND sporttype = 99 and bettype = 3			
		AND roleid IN (2,1)
		AND ci.custid > @maxcustid
		AND currency IN (3,16,17,35,36,40,64,65,68) --USD
		AND recommend IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05	

--STEP 2: Adjust settings for super, master 12Bet

--adjust [Dep_CustSetting]
UPDATE cs1
SET	cs1.[apositiontaking] = cs2.[apositiontaking]
	,cs1.[mpositiontaking] = cs2.[mpositiontaking]
	,cs1.[spositiontaking] = cs2.[spositiontaking]
	,cs1.[playerdiscount] = cs2.[playerdiscount]	
	,cs1.[discount] = cs2.[discount]	
	,cs1.[adiscount] = cs2.[adiscount]	
	,cs1.[sdiscount] = cs2.[sdiscount]	
	,cs1.[minbet] = cs2.[minbet]
	,cs1.[maxbet] = cs2.[maxbet]
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN [Dep_CustSetting] cs1 WITH(UPDLOCK,ROWLOCK) ON cs1.custid = ci.custid AND cs1.sporttype  = 44 AND cs1.bettype = 3
	INNER JOIN [Dep_CustSetting] cs2 WITH(NOLOCK) ON cs2.custid = ci.custid AND cs2.sporttype = 99 AND cs2.bettype = 3
WHERE ci.srecommend IN (SELECT custid FROM #supers)	
	AND roleid IN (4,3)
	AND ( cs1.[apositiontaking] <> cs2.[apositiontaking]
			OR cs1.[mpositiontaking] <> cs2.[mpositiontaking]
			OR cs1.[spositiontaking] <> cs2.[spositiontaking]
			OR cs1.[playerdiscount] <> cs2.[playerdiscount]	
			OR cs1.[discount] <> cs2.[discount]	
			OR cs1.[adiscount] <> cs2.[adiscount]	
			OR cs1.[sdiscount] <> cs2.[sdiscount]
			OR cs1.[minbet] <> cs2.[minbet]
			OR cs1.[maxbet] <> cs2.[maxbet])

--adjust [CustInfo]
UPDATE ci
SET	ci.MaxPerMatch44 = ci.maxpermatch99
FROM custinfo ci WITH(NOLOCK)
WHERE ci.srecommend IN (SELECT custid FROM #supers)	
	AND roleid IN (4,3)	
	AND ci.MaxPerMatch44 <> ci.maxpermatch99

--STEP 3: Adjust settings for agent, member 12Bet
UPDATE cs1
SET	cs1.[apositiontaking] = cs2.[apositiontaking]
	,cs1.[mpositiontaking] = cs2.[mpositiontaking]
	,cs1.[spositiontaking] = cs2.[spositiontaking]
	,cs1.[playerdiscount] = cs2.[playerdiscount]	
	,cs1.[discount] = cs2.[discount]	
	,cs1.[adiscount] = cs2.[adiscount]	
	,cs1.[sdiscount] = cs2.[sdiscount]	
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN [Dep_CustSetting] cs1 WITH(UPDLOCK,ROWLOCK) ON cs1.custid = ci.custid AND cs1.sporttype  = 44 AND cs1.bettype = 3
	INNER JOIN [Dep_CustSetting] cs2 WITH(NOLOCK) ON cs2.custid = ci.custid AND cs2.sporttype = 99 AND cs2.bettype = 3
WHERE ci.srecommend IN (SELECT custid FROM #supers)	
	AND roleid IN (2,1)
	AND ( cs1.[apositiontaking] <> cs2.[apositiontaking]
			OR cs1.[mpositiontaking] <> cs2.[mpositiontaking]
			OR cs1.[spositiontaking] <> cs2.[spositiontaking]
			OR cs1.[playerdiscount] <> cs2.[playerdiscount]	
			OR cs1.[discount] <> cs2.[discount]	
			OR cs1.[adiscount] <> cs2.[adiscount]	
			OR cs1.[sdiscount] <> cs2.[sdiscount])


GO		 
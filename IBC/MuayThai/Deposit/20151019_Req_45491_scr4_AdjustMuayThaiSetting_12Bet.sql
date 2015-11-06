/*
	Created: Elodie
	Date: 2015-10-19
	Task: adjust Muay Thai settings after copying for deposit customers
	DB: DBCUST/CustDB
	Runtime: UM
*/ 
--STEP 1: copy settings for newly created deposit customers
CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site <> '12Bet')	
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
        ,[minbet]
        ,[maxbet]
FROM [Dep_CustSetting] cs WITH(NOLOCK)
	INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
WHERE ci.srecommend IN (SELECT custid FROM #supers)
		AND ci.custid > @maxcustid
		AND sporttype = 99 and bettype = 3	 		
GO		 

--STEP 2: Adjust settings for deposit customers

--adjust [Dep_CustSetting]
UPDATE cs1
SET	cs1.[minbet] = cs2.[minbet]
	,cs1.[maxbet] = cs2.[maxbet]
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN [Dep_CustSetting] cs1 WITH(UPDLOCK,ROWLOCK) ON cs1.custid = ci.custid AND cs1.sporttype  = 44 AND cs1.bettype = 3
	INNER JOIN [Dep_CustSetting] cs2 WITH(NOLOCK) ON cs2.custid = ci.custid AND cs2.sporttype = 99 AND cs2.bettype = 3
WHERE ci.srecommend IN (SELECT custid FROM #supers)		
	AND ( cs1.[minbet] <> cs2.[minbet]
		   OR cs1.[maxbet] <> cs2.[maxbet])	
GO
--------------------------------------------------------------------
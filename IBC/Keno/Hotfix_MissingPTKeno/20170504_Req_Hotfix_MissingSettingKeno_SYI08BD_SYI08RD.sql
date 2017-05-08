/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/

CREATE TABLE #List2 (CustID INT PRIMARY KEY,RoleID INT, isfinished bit default(0))
INSERT INTO #List2 (CustID,roleID)
VALUES (15668318,2),
	(20550129,2)

-----------Step 1: 1. Insert setting as Master request (a2=0.7, n2=0.5 )
INSERT INTO [dbo].[CustSettingGame]
(
    [custid]
  , [bettype]
  , [sporttype]
  , [apositiontaking]
  , [mpositiontaking]
  , [spositiontaking]
  , [playerdiscount]
  , [discount]
  , [adiscount]
  , [sdiscount]
  , [autopositiontaking]
  , [isautopositiontaking]
  , [autompositiontaking]
  , [isautompositiontaking]
)
SELECT L2.custid
	 , ps.Bettype
	 , 202
	 , 0.7 --apos
	 , 0 --mpos
	 , 0 --spos
     , 0 --pdis
	 , 0 --dis
	 , 0 --adis
	 , 0 --sdis
	 , 0 --autopos
     , 0 --isautopos
	 , 0 --autompos
	 , 0 --isautompos
FROM #List2 L2 
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK)
WHERE ps.Sporttype = 202 AND ps.IsDep = 0 
	AND NOT EXISTS (SELECT 1 FROM CustSettingGame CSG WITH (NOLOCK) WHERE CSG.CustID = L2.custid AND CSG.Sporttype = 202 AND CSG.Bettype = PS.Bettype)   
	
--CustOverrideGame
INSERT INTO [dbo].[CustOverrideGame]
(
    [custid]
  , [bettype]
  , [sporttype]
  , [minpositiontaking]
)
SELECT l2.custid
	 , ps.Bettype
	 , 202
	 , 0.5 --minpos
FROM #List2 L2  
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK) 
WHERE ps.Sporttype = 202 AND ps.IsDep = 0  
	AND NOT EXISTS (SELECT 1 FROM CustOverrideGame COG WITH (NOLOCK) WHERE COG.CustID = L2.custid AND COG.Sporttype = 202 AND COG.Bettype = PS.Bettype)   
	

/* -- Disable Keno for member

UPDATE CGT
	SET IsDisabled = 1
FROM CustGameType CGT WITH (ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CGT.CustID = CI.custid
	INNER JOIN #List2 l2 ON CI.mrecommend = L2.CustID AND L2.RoleID = 3
WHERE CGT.GameTypeID IN (1,3,4,5,8,11,13,14)	

*/

/* -- Disable Keno for member
UPDATE CGT
	SET IsDisabled = 1
FROM CustGameType CGT WITH (ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CGT.CustID = CI.custid
	INNER JOIN #List2 l2 ON CI.recommend = L2.CustID AND L2.RoleID = 2
WHERE CGT.GameTypeID IN (1,3,4,5,8,11,13,14)	
*/

-- 2. Adjust PT for members under these agents

-- Agent correct members
DECLARE @recommend INT
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #List2
	SET isfinished = 1
		,@recommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1501

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1503

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1504

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1505

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1507

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1508

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1509

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1511

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
	
	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @recommend, @roleid = 2, @mode = 'Keno', @Sporttype = 202, @BetType = 1514
	
	--EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1515
	
	--EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1516
	
END	

/*
-- Master correct members -----
DECLARE @mrecommend INT

CREATE TABLE #MasterList (CustID INT, isfinished bit default(0))

INSERT INTO #MasterList (CustID)
SELECT CI.mrecommend
FROM #List2 L 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L.CustID = CI.custid
WHERE L.RoleID = 2

UNION 

SELECT L.CustID
FROM #List2 L 
WHERE L.RoleID = 3

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #MasterList
	SET isfinished = 1
		,@mrecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1501

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1503

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1504

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1505

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1507

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1508

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1509

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1511

	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
	
	EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1514
	
	--EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1515
	
	--EXEC dbo.Acc_CustSetting3rd_07 @mrecommend = @mrecommend, @roleid = 3, @mode = 'Keno', @Sporttype = 202, @BetType = 1516
	
END	

--------------------SUPER
DECLARE @srecommend INT

CREATE TABLE #SuperList (CustID INT, isfinished bit default(0))

INSERT INTO #SuperList (CustID)

SELECT CI.srecommend
FROM #List2 L 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L.CustID = CI.custid
WHERE L.RoleID = 2

UNION 

SELECT CI.srecommend
FROM #List2 L 
	INNER JOIN custInfo CI WITH (NOLOCK) ON L.CustID = CI.custid
WHERE L.RoleID = 3

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #SuperList
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1501

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1503

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1504

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1505

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1507

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1508

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1509

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1511

	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
	
	EXEC dbo.Acc_CustSetting3rd_07 @srecommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1514
	
	--EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1515
	
	--EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1516
	
END	
*/
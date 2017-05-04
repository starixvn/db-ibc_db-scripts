/*
	Created: 20170504@Helen
	Task: Keno - Missing PT setting for some accounts - [Redmine: 76020]

*/

CREATE TABLE #List2 (CustID INT PRIMARY KEY,RoleID INT)
INSERT INTO #List2 (CustID,roleID)
VALUES 
(15673568,3),
(15712814,2),
(15863545,2),
(25431906,2),
(24794345,2),
(25015139,2),
(16328595,2),
(16518702,2),
(15671442,3),
(15669655,2),
(15670718,3),
(15953857,2),
(15669625,2),
(15672158,2),
(15668318,2),
(20550129,2),
(15673960,2),
(15670055,2),
(15671024,2),
(15735528,2),
(15669572,3),
(25263729,2),
(25265974,2),
(25267663,2),
(25322548,2),
(25450700,2),
(25450708,2),
(15670788,3),
(15669891,2),
(15674028,2),
(15671149,3),
(19743526,2),
(19743586,2),
(19743726,2),
(19743775,2),
(19743825,2),
(15671014,3),
(16061880,2),
(15672253,3),
(25741280,2),
(25131857,2),
(17372015,2),
(18639617,2),
(19357194,2),
(15671109,2)
-----------Step 1: Master insert PT=0, adjust member m1=0, correct PT member
-----------Step 1.1: Master insert PT=0
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
	 , 0 --apos
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
	 , 0 --minpos
FROM #List2 L2  
	CROSS JOIN ProductGlobalSetting ps WITH(NOLOCK) 
WHERE ps.Sporttype = 202 AND ps.IsDep = 0  
	AND NOT EXISTS (SELECT 1 FROM CustOverrideGame COG WITH (NOLOCK) WHERE COG.CustID = L2.custid AND COG.Sporttype = 202 AND COG.Bettype = PS.Bettype)   
	
-----------Step 1.2: adjust member m1=0
UPDATE CSG
	SET mpositiontaking = 0
FROM CustSettingGame CSG WITH (ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CSG.CustID = CI.custid AND CI.roleid = 1
	INNER JOIN #List2 L2 ON CI.mrecommend = L2.CustID AND L2.RoleID = 3
WHERE CSG.Sporttype = 202	

UPDATE CSG
	SET apositiontaking = 0
FROM CustSettingGame CSG WITH (ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CSG.CustID = CI.custid AND CI.roleid = 1
	INNER JOIN #List2 L2 ON CI.recommend = L2.CustID AND L2.RoleID = 2
WHERE CSG.Sporttype = 202	

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
	
	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1501

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1503

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1504

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1505

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1507

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1508

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1509

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1511

	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1513
	
	EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1514
	
	--EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1515
	
	--EXEC dbo.Acc_CustSetting3rd_07 @recommend = @srecommend, @roleid = 4, @mode = 'Keno', @Sporttype = 202, @BetType = 1516
	
END	

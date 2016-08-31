/*
	Created by: Helen
	Created Date: 20160830
	Task: Change maxbet of Macau Games - https://nexdev.net/issues/63285
	
	DB: DBCUST/CUSTDB
	SELECT * FROM GAMEGROUP (NOLOCK)
*/
--------------------- CREDIT -----------------------------------
-- LEVEL 1: GameGroupID = 1 -- LEVEL 2, current value / 5
UPDATE D
	SET MaxStake = D.MaxStake / 5
	, MaxLabel=(SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
			FROM (SELECT CONVERT(VARCHAR, CAST(REPLACE(LTRIM(RTRIM(SUBSTRING (CONVERT(VARCHAR(100),D.MaxStake / 5),CHARINDEX('-',CONVERT(VARCHAR(100),D.MaxStake / 5)) + 1,LEN(CONVERT(VARCHAR(100),D.MaxStake / 5))))),',','') AS MONEY), 1)) s(t))
FROM StakeLevelGroupDetail d
	INNER JOIN StakeLevel SK WITH (NOLOCK) ON d.StakeLevelID = sk.StakeLevelID and sk.GameGroupID = 1
WHERE SK.GameTypeID = 4001 AND d.GameTypeID NOT IN (4004,4022)
-- Level 2:GameGroupID = 2 -- LEVEL 3, currenct value / 5
UPDATE D
	SET MaxStake =  D.MaxStake / 5
	, MaxLabel=(SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
			FROM (SELECT CONVERT(VARCHAR, CAST(REPLACE(LTRIM(RTRIM(SUBSTRING (CONVERT(VARCHAR(100),D.MaxStake / 5),CHARINDEX('-',CONVERT(VARCHAR(100),D.MaxStake / 5)) + 1,LEN(CONVERT(VARCHAR(100),D.MaxStake / 5))))),',','') AS MONEY), 1)) s(t))
FROM StakeLevelGroupDetail d
	INNER JOIN StakeLevel SK WITH (NOLOCK) ON d.StakeLevelID = sk.StakeLevelID and sk.GameGroupID = 2
WHERE SK.GameTypeID = 4001 AND d.GameTypeID NOT IN (4004,4022)

-------------------- DEPOSIT -------------------------------- 
-- Level 2: GameGroupID = 4 -- LEVEL 2, current value / 2.5
/*
UPDATE D
	SET MaxStake = D.MaxStake / 2.5
	, MaxLabel=(SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
			FROM (SELECT CONVERT(VARCHAR, CAST(REPLACE(LTRIM(RTRIM(SUBSTRING (CONVERT(VARCHAR(100),D.MaxStake / 2.5),CHARINDEX('-',CONVERT(VARCHAR(100),D.MaxStake / 2.5)) + 1,LEN(CONVERT(VARCHAR(100),D.MaxStake / 2.5))))),',','') AS MONEY), 1)) s(t))
FROM Dep_StakeLevelGroupDetail d
	INNER JOIN Dep_StakeLevel SK WITH (NOLOCK) ON d.StakeLevelID = sk.StakeLevelID and sk.GameGroupID = 4
WHERE SK.GameTypeID = 4001	
-- Level 3: GameGroupID = 5 -- LEVEL 3, current value / 5
UPDATE D
	SET MaxStake = D.MaxStake / 5
	, MaxLabel=(SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
			FROM (SELECT CONVERT(VARCHAR, CAST(REPLACE(LTRIM(RTRIM(SUBSTRING (CONVERT(VARCHAR(100),D.MaxStake / 5),CHARINDEX('-',CONVERT(VARCHAR(100),D.MaxStake / 5)) + 1,LEN(CONVERT(VARCHAR(100),D.MaxStake / 5))))),',','') AS MONEY), 1)) s(t))
FROM Dep_StakeLevelGroupDetail d
	INNER JOIN Dep_StakeLevel SK WITH (NOLOCK) ON d.StakeLevelID = sk.StakeLevelID and sk.GameGroupID = 5
WHERE SK.GameTypeID = 4001
*/


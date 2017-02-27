/*
	Created by: Elodie
	Created Date: 20170224
	Task: Change maxbet of Macau Games - https://nexdev.net/issues/71646
	DB: DBCUST/CUSTDB

	SELECT * FROM GAMEGROUP (NOLOCK)
*/
CREATE TABLE #NewStake (ExchangeID INT, MaxStake_Level1 DECIMAL(9,8), MaxStake_Level2 DECIMAL(9,8))
INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 200, 400
FROM exchange WITH (NOLOCK)
WHERE code IN ('AUD','BND','CAD','CHF','EUR','GBP','MMK','NZD','SGD','USD')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 2000, 4000
FROM exchange WITH (NOLOCK)
WHERE code IN ('CNY','DKK','HKD','NOK','SEK')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 5000000, 10000000
FROM exchange WITH (NOLOCK)
WHERE code IN ('CZK')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 4000, 8000
FROM exchange WITH (NOLOCK)
WHERE code IN ('IDR')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 20000, 40000
FROM exchange WITH (NOLOCK)
WHERE code IN ('INR','RUB')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 30000, 60000
FROM exchange WITH (NOLOCK)
WHERE code IN ('JPY')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 1000, 2000
FROM exchange WITH (NOLOCK)
WHERE code IN ('KHR','MYR','PLN','RON')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 300000, 600000
FROM exchange WITH (NOLOCK)
WHERE code IN ('KRW')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 4000000, 8000000
FROM exchange WITH (NOLOCK)
WHERE code IN ('MXN','ZAR')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 10000, 20000
FROM exchange WITH (NOLOCK)
WHERE code IN ('PHP','THB','TWD')

INSERT INTO #NewStake (ExchangeID, MaxStake_Level1, MaxStake_Level2)
SELECT exchangeid, 5000, 10000
FROM exchange WITH (NOLOCK)
WHERE code IN ('VND')
--------------------- CREDIT -----------------------------------
-- LEVEL 1: GameGroupID = 1
UPDATE D
SET MaxStake = s.MaxStake_Level1
FROM StakeLevelGroupDetail d
	INNER JOIN StakeLevel SK WITH (NOLOCK) ON d.StakeLevelID = sk.StakeLevelID and sk.GameGroupID = 1
	INNER JOIN #NewStake s ON s.ExchangeID = SK.ExchangeId
WHERE SK.GameTypeID = 4001 AND d.GameTypeID = 4004

UPDATE D
SET MaxLabel=(SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
			FROM (SELECT CONVERT(VARCHAR, CAST(REPLACE(LTRIM(RTRIM(SUBSTRING (CONVERT(VARCHAR(100),D.MaxStake),CHARINDEX('-',CONVERT(VARCHAR(100),D.MaxStake)) + 1,LEN(CONVERT(VARCHAR(100),D.MaxStake))))),',','') AS MONEY), 1)) s(t))
FROM StakeLevelGroupDetail d
	INNER JOIN StakeLevel SK WITH (NOLOCK) ON d.StakeLevelID = sk.StakeLevelID and sk.GameGroupID = 1
WHERE SK.GameTypeID = 4001 AND d.GameTypeID = 4004

-- Level 2:GameGroupID = 2
UPDATE D
SET MaxStake = s.MaxStake_Level2
FROM StakeLevelGroupDetail d
	INNER JOIN StakeLevel SK WITH (NOLOCK) ON d.StakeLevelID = sk.StakeLevelID and sk.GameGroupID = 2
	INNER JOIN #NewStake s ON s.ExchangeID = SK.ExchangeId
WHERE SK.GameTypeID = 4001 AND d.GameTypeID = 4004

UPDATE D
SET MaxLabel=(SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
			FROM (SELECT CONVERT(VARCHAR, CAST(REPLACE(LTRIM(RTRIM(SUBSTRING (CONVERT(VARCHAR(100),D.MaxStake),CHARINDEX('-',CONVERT(VARCHAR(100),D.MaxStake)) + 1,LEN(CONVERT(VARCHAR(100),D.MaxStake))))),',','') AS MONEY), 1)) s(t))
FROM StakeLevelGroupDetail d
	INNER JOIN StakeLevel SK WITH (NOLOCK) ON d.StakeLevelID = sk.StakeLevelID and sk.GameGroupID = 2
WHERE SK.GameTypeID = 4001 AND d.GameTypeID = 4004




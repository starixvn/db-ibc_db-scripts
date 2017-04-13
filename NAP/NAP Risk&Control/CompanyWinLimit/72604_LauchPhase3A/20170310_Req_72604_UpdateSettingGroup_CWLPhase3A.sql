/*
	Created: 20170324@Helen
	Task: CWL - phase 3a
	DB: DBCUST/CUSTDB
*/
USE CustDB

GO

CREATE TABLE #ChangeGroupSetting (ID INT IDENTITY (1,1), GroupID INT,ChangeName VARCHAR(200), LEVEL1 MONEY,LEVEL2 MONEY,LEVEL3 MONEY)

INSERT INTO #ChangeGroupSetting (GroupID,ChangeName,LEVEL1,LEVEL2,LEVEL3)
VALUES
(5,'Gold Deluxe',100000,300000,500000),
(6,'Microgaming - Live Casino',100000,300000,500000),
(7,'Microgaming - RNG Casino',10000,30000,100000),
(8,'Allbet Casino VIP',200000,500000,800000),
(9,'Allbet Casino',100000,300000,500000),
(10,'Macau Games',10000,30000,100000),
(11,'Fishing World',10000,30000,100000)

-- UPDATE NAME
UPDATE G
	SET GroupName = CGS.ChangeName
FROM Winlimit_Group G WITH (UPDLOCK,ROWLOCK)
	INNER JOIN #ChangeGroupSetting CGS ON G.groupID = CGS.GroupID
-- UPDATE VALUE FOR EACH LEVEL WIN LIMIT

UPDATE G
	SET MaxWinLimit_RM = CGS.LEVEL1
FROM WinLimit_ProductSettingDetail G WITH (UPDLOCK,ROWLOCK)
	INNER JOIN #ChangeGroupSetting CGS ON G.groupID = CGS.GroupID
WHERE G.LevelID = 1	

UPDATE G
	SET MaxWinLimit_RM = CGS.LEVEL2
FROM WinLimit_ProductSettingDetail G WITH (UPDLOCK,ROWLOCK)
	INNER JOIN #ChangeGroupSetting CGS ON G.groupID = CGS.GroupID
WHERE G.LevelID = 2	

UPDATE G
	SET MaxWinLimit_RM = CGS.LEVEL3
FROM WinLimit_ProductSettingDetail G WITH (UPDLOCK,ROWLOCK)
	INNER JOIN #ChangeGroupSetting CGS ON G.groupID = CGS.GroupID
WHERE G.LevelID = 3	

-- UPDATE MaxWinlimitAmount

DECLARE @Fromdate DATE= GETDATE(), @Todate DATE= GETDATE()  

DECLARE @from_ID INT = 1, @to_ID INT, @GroupID INT

SET @to_ID = (SELECT MAX(ID) FROM #ChangeGroupSetting)

WHILE @from_ID <=@to_ID
BEGIN
	SET @GroupID = (SELECT GroupID FROM #ChangeGroupSetting WHERE ID = @from_ID)
	
	UPDATE PSD
		SET MaxWinLimit = CASE WHEN psd.ExchangeID = 20 THEN MaxWinLimit_RM ELSE ROUND(MaxWinLimit_RM / FEX.MYR,2) END
	FROM WinLimit_ProductSettingDetail PSD WITH (ROWLOCK,UPDLOCK)
		INNER JOIN #ChangeGroupSetting CGS ON PSD.groupID = CGS.GroupID
		INNER JOIN Lrf_f_GetExchangeDaily(@Fromdate, @Todate) fEx  ON fEx.ExchangeId = psd.ExchangeID
	WHERE PSD.GroupID = @GroupID
	
	SET @from_ID = @from_ID + 1
	
	waitfor delay '00:00:0.280'	
END

DROP TABLE #ChangeGroupSetting	
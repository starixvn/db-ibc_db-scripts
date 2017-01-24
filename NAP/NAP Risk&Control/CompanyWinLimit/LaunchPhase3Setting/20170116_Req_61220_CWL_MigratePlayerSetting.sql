/*
	Created: 20170120@Helen
	Task: Migrate data - https://nexdev.net/issues/61220
	DB: DBCUST/CUSTDB
*/

---------- Step 0: PREPARATION ------------------------------
-- Truncate data phase 2
IF NOT EXISTS (SELECT 1 FROM PRO_WinLimit_CustGameSetting WITH (NOLOCK)) 
	RETURN
	
TRUNCATE TABLE WinLimit_CustGameSetting
--- Create temporarily tables
CREATE TABLE #WinLimit_CustGameSetting_Result([CustID] [int],[ProductID] [tinyint],[GroupID] [smallint],[LevelID] [tinyint],[MaxWinLimit] [money],[MaxWinLimit_RM] [money])
DECLARE @Fromdate DATE= GETDATE(), @Todate DATE= GETDATE()  
---------- End of Step 0: PREPARATION --------------------------

---------- STEP 1: PLAYER SETTING MIGRATE -----------------------
INSERT INTO #WinLimit_CustGameSetting_Result (CustID,ProductID,GroupID,LevelID,MaxWinLimit,MaxWinLimit_RM)
SELECT  DISTINCT t.CustID, t.productid,t2.GroupID,t.levelID,t.MaxWinLimit
		,CASE WHEN ci.currency = 20 THEN t.MaxWinLimit ELSE  ROUND(FEX.MYR * t.MaxWinLimit,2) END AS TotalWinAmt_RM
FROM PRO_WinLimit_CustGameSetting T(NOLOCK)
	INNER JOIN custInfo ci WITH (NOLOCK) ON t.custid = ci.custid 
	LEFT JOIN Lrf_f_GetExchangeDaily(@Fromdate, @Todate) fEx  ON fEx.ExchangeId = ci.currency
	CROSS APPLY (SELECT DISTINCT GroupID
				 FROM dbo.Winlimit_GameGroupSetting gg WITH (NOLOCK)
				 WHERE gg.ProductID = t.ProductID ) AS T2
ORDER BY t.CustID, t.ProductID,t2.GroupID,t.LevelID

-- Insert Data
INSERT INTO WinLimit_CustGameSetting (CustID,ProductID,GroupID,LevelID,MaxWinLimit,MaxWinLimit_RM)
SELECT CustID,ProductID,GroupID,LevelID,MaxWinLimit,MaxWinLimit_RM
FROM #WinLimit_CustGameSetting_Result

---------------- CHECKING DATA -------------------
SELECT 'PLAYER SETTING MIGRATE CHECKING '
DECLARE @PlayerSettingCnt INT = 0
SET  @PlayerSettingCnt = (SELECT COUNT(1) 
						  FROM PRO_WinLimit_CustGameSetting T1 WITH (NOLOCK)
							INNER JOIN custInfo CI WITH (NOLOCK) ON T1.CustID = CI.custid 
						  WHERE NOT EXISTS (SELECT 1 FROM #WinLimit_CustGameSetting_Result T2 WHERE T1.CustID = T2.CustID AND T1.ProductID=T2.ProductID )
						  )
IF @PlayerSettingCnt = 0 
	SELECT 'All is OK'
ELSE 
BEGIN
	SELECT 'Can not migrate these settings,  please check the list below !!!'
	SELECT T1.*
	FROM PRO_WinLimit_CustGameSetting T1 WITH (NOLOCK)
		INNER JOIN custInfo CI WITH (NOLOCK) ON T1.CustID = CI.custid 
	WHERE NOT EXISTS (SELECT 1 FROM #WinLimit_CustGameSetting_Result T2 WHERE T1.CustID = T2.CustID AND T1.ProductID=T2.ProductID )
END	
---------- END OF STEP 1: PLAYER SETTING MIGRATE -----------------------
--SELECT * FROM WinLimit_CustGameSetting WITH (NOLOCK)

/*
DROP TABLE #WinLimit_CustGameSetting_Result
*/
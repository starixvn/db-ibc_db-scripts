/*
	Created: 20170120@Helen
	Task: Migrate data - https://nexdev.net/issues/61220
	DB: DBCUST/CUSTDB
*/

---------- Step 0: PREPARATION ------------------------------
-- Truncate data phase 2
IF NOT EXISTS (SELECT 1 FROM PRO_WinLimit_CustGameMonitoring WITH (NOLOCK))
	RETURN
	
TRUNCATE TABLE WinLimit_CustGameMonitoring
--- Create temporarily tables
CREATE TABLE #WinLimit_CustGameMonitoring_Result([CustID] [int],[ProductID] [tinyint],[BettypeID] [smallint],[WinlostDate] [smalldatetime],[LevelID] [tinyint],[MaxWinLimit] [money],[TotalWinAmt] [money],[WinAmt] [money],[ModifiedDate] [datetime],[IsNotified] [bit],[ModifiedBy] [int] ,[CreatedBy] [int] ,[MaxWinLimitSetting] [xml] ,[TotalWinAmt_RM] [money] ) 

---------- End of Step 0: PREPARATION --------------------------
-----------STEP 2: WIN LIMIT MONITOR MIGRATE -----------------------
--- Player setting
INSERT INTO #WinLimit_CustGameMonitoring_Result (CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ModifiedDate, IsNotified, ModifiedBy, CreatedBy, MaxWinLimitSetting, TotalWinAmt_RM)
SELECT  T.CustID,T.ProductID,T.BettypeID,T.WinlostDate,T.LevelID,T.MaxWinLimit,T.TotalWinAmt,T.WinAmt,T.ModifiedDate,T.IsNotified,T.ModifiedBy,T.CreatedBy
		,tmp.MaxWinLimitSetting AS MaxWinLimitSetting
		,CASE WHEN ci.currency = 20 THEN t.TotalWinAmt ELSE ROUND(FEX.MYR * t.TotalWinAmt,2) END AS TotalWinAmt_RM
FROM PRO_WinLimit_CustGameMonitoring T WITH (NOLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON T.CustID = CI.custid AND CI.currency NOT IN (20,72) 
	CROSS APPLY (SELECT MYR FROM Lrf_f_GetExchangeDaily (T.WinlostDate, T.WinlostDate)
				 WHERE ExchangeId = ci.currency ) AS fEx  
	CROSS APPLY (SELECT '<MaxWinLimitSetting' + x.str + '/>' 
					FROM (SELECT ' Level' + CAST(T1.LevelID AS VARCHAR) + '="' + CAST(T1.MaxWinLimit_RM AS VARCHAR) + '"'
						  FROM (SELECT TOP 10 TMP.LevelID,TMP.MaxWinLimit_RM
								FROM
									( 
										SELECT T.LevelID, CASE WHEN ci.currency = 20 THEN t.MaxWinLimit ELSE  ROUND(FEX.MYR * T.MaxWinLimit,2) END  AS MaxWinLimit_RM
										UNION ALL
										SELECT S1.LevelID, CASE WHEN ci.currency = 20 THEN  S1.MaxWinLimit ELSE  ROUND(FEX.MYR *  S1.MaxWinLimit,2) END AS MaxWinLimit_RM
										FROM PRO_WinLimit_CustGameSetting S1 WITH (NOLOCK)
										WHERE T.ProductID = S1.ProductID AND T.BettypeID = S1.BettypeID AND S1.LevelID <> T.LevelID AND S1.CustID = T.CustID
									) TMP	
								ORDER BY TMP.LevelID	
								 								 
						  ) AS T1
						  FOR XML PATH('')
						) x(str)
		) AS tmp (MaxWinLimitSetting)
WHERE EXISTS (SELECT 1 FROM PRO_WinLimit_CustGameSetting S3 WITH (NOLOCK) WHERE S3.CustID = CI.custid AND T.ProductID = S3.ProductID AND S3.BettypeID = T.BettypeID)	
------- currency setting ---------------------------------
INSERT INTO #WinLimit_CustGameMonitoring_Result (CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ModifiedDate, IsNotified, ModifiedBy, CreatedBy, MaxWinLimitSetting, TotalWinAmt_RM)
SELECT  T.CustID,T.ProductID,T.BettypeID,T.WinlostDate,T.LevelID,T.MaxWinLimit,T.TotalWinAmt,T.WinAmt,T.ModifiedDate,T.IsNotified,T.ModifiedBy,T.CreatedBy
		,tmp.MaxWinLimitSetting AS MaxWinLimitSetting
		,CASE WHEN ci.currency = 20 THEN t.TotalWinAmt ELSE  ROUND(FEX.MYR * t.TotalWinAmt,2) END AS TotalWinAmt_RM
FROM PRO_WinLimit_CustGameMonitoring T WITH (NOLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = T.CustID AND CI.currency NOT IN (20,72)
	INNER JOIN Customer C WITH (NOLOCK) ON C.CustID = CI.recommend
	INNER JOIN Site SI WITH (NOLOCK) ON SI.site = C.site
	OUTER APPLY (SELECT MYR FROM Lrf_f_GetExchangeDaily (T.WinlostDate, T.WinlostDate)
				 WHERE ExchangeId = ci.currency ) AS fEx  
	CROSS APPLY (SELECT '<MaxWinLimitSetting' + x.str + '/>' 
					FROM (SELECT ' Level' + CAST(T1.LevelID AS VARCHAR) + '="' + CAST(T1.MaxWinLimit_RM AS VARCHAR) + '"'
						  FROM ( 
								 SELECT TOP 10 TMP.LevelID,TMP.MaxWinLimit_RM
								 FROM (	
										SELECT  T.LevelID, CASE WHEN ci.currency = 20 THEN t.MaxWinLimit ELSE  ROUND(FEX.MYR * T.MaxWinLimit,2) END  AS MaxWinLimit_RM
										UNION ALL
										SELECT S1.LevelID, CASE WHEN ci.currency = 20 THEN  S1.MaxWinLimit ELSE  ROUND(FEX.MYR *  S1.MaxWinLimit,2) END AS MaxWinLimit_RM
										FROM PRO_WinLimit_ProductSettingDetail S1 WITH (NOLOCK)
										WHERE T.ProductID = S1.ProductID AND T.BettypeID = S1.BettypeID AND S1.LevelID <> T.LevelID AND S1.ExchangeID = CI.currency AND SI.siteid = S1.SiteID
								 ) AS Tmp
								 ORDER BY TMP.LevelID
								 
							 ) AS T1
						   		 
						  FOR XML PATH('')
						) x(str)
		) AS tmp (MaxWinLimitSetting)
		
WHERE NOT EXISTS (SELECT 1 FROM PRO_WinLimit_CustGameSetting S3 WITH (NOLOCK) WHERE S3.CustID = CI.custid AND T.ProductID = S3.ProductID AND S3.BettypeID = T.BettypeID)
	
-- Insert Data
INSERT INTO WinLimit_CustGameMonitoring (CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ModifiedDate, IsNotified, ModifiedBy, CreatedBy, MaxWinLimitSetting, TotalWinAmt_RM)	
SELECT CustID, ProductID, BettypeID, WinlostDate, LevelID, MaxWinLimit, TotalWinAmt, WinAmt, ModifiedDate, IsNotified, ModifiedBy, CreatedBy, MaxWinLimitSetting, TotalWinAmt_RM 
FROM #WinLimit_CustGameMonitoring_Result

---------------- CHECKING DATA -------------------
SELECT 'WINLIMIT MONITORING MIGRATE CHECKING '
DECLARE @WinlimitMonitoringCnt INT = 0
SET  @WinlimitMonitoringCnt = (SELECT COUNT(1) 
								FROM PRO_WinLimit_CustGameMonitoring T1 WITH (NOLOCK)
									INNER JOIN custInfo CI WITH (NOLOCK) ON T1.CustID = CI.custid AND CI.currency NOT IN (20,72)
								WHERE NOT EXISTS (SELECT 1 FROM #WinLimit_CustGameMonitoring_Result T2 WHERE T1.CustID = T2.CustID AND T1.ProductID=T2.ProductID )
								)
IF @WinlimitMonitoringCnt = 0 
	SELECT 'All is OK'
ELSE 
BEGIN
	SELECT 'Can not migrate all of WINLIMIT MONITORING,  please check the list below !!!'
	SELECT T1.*
	FROM PRO_WinLimit_CustGameMonitoring T1 WITH (NOLOCK)
		INNER JOIN custInfo CI WITH (NOLOCK) ON T1.CustID = CI.custid AND CI.currency NOT IN (20,72)
	WHERE NOT EXISTS (SELECT 1 FROM #WinLimit_CustGameMonitoring_Result T2 WHERE T1.CustID = T2.CustID AND T1.ProductID=T2.ProductID )
	
END	
-------------END OF STEP 2: WIN LIMIT MONITOR MIGRATE -----------------------
--SELECT * FROM WinLimit_CustGameMonitoring WITH (NOLOCK)
/*
DROP TABLE #WinLimit_CustGameMonitoring_Result

*/
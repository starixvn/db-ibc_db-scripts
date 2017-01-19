SELECT *
INTO #WinLimit_CustGameSetting_tmp
FROM PRO_WinLimit_CustGameSetting WITH (NOLOCK)

--TRUNCATE TABLE WinLimit_CustGameSetting

--INSERT INTO WinLimit_CustGameSetting
SELECT T.custID,t.
FROM #WinLimit_CustGameSetting_tmp t (NOLOCK)
	CROSS APPLY (SELECT GroupID
				 FROM dbo.Winlimit_GameGroupSetting gg WITH (NOLOCK)
				 WHERE gg.ProductID = t.ProductID ) AS T2
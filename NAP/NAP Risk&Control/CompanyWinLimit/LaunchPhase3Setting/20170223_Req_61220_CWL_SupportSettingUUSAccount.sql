/*
	Created: 20170223@Helen
	Task: Support setting for UUS - https://nexdev.net/issues/72112
*/
SELECT  c.custid
INTO #Cust_tmp
FROM Customer C (NOLOCK)
WHERE C.username IN ('twpgmyikhunchiu01',
'twpgmyikhunchiu02',
'twpgmambercheng01',
'twpgmambercheng02',
'twpgmjoeguo01',
'twpgmjoeguo02',
'twpgmleonchen01',
'twpgmleonchen02',
'twpgmann.chou1',
'twpgmann.chou2',
'twpgmrita.chang1',
'twpgmrita.chang2',
'MacaubetUUS01011',
'twpgmjessica.chen',
'twpgmcharliema',
'twpgmagneslee',
'twpgmvincentkuo',
'twpgmangela.chan',
'twpgmthomas.chou',
'twpgmbert.chang',
'AoncashUUS01002'
)

SELECT DISTINCT GGS.ProductID,GGS.GroupID
INTO #Group_Setting
FROM Winlimit_GameGroupSetting GGS (NOLOCK)

-- DELETE IF EXISTS
DELETE t
FROM WinLimit_CustGameSetting T
WHERE T.CustID IN (SELECT CustID FROM #Cust_tmp)

-- INSERT SETTING
INSERT INTO WinLimit_CustGameSetting (CustID, ProductID, GroupID, LevelID, MaxWinLimit, MaxWinLimit_RM)
SELECT C.custid,T.ProductID,T.GroupID,1, 1,1
FROM #Cust_tmp C
	CROSS JOIN (SELECT ProductID,GroupID
			    FROM #Group_Setting) AS T

UNION ALL

SELECT C.custid,T1.ProductID,T1.GroupID,2, 2,2
FROM #Cust_tmp C
		CROSS JOIN (SELECT ProductID,GroupID
			    FROM #Group_Setting) AS T1
UNION ALL

SELECT C.custid,T2.ProductID,T2.GroupID,3, 3,3
FROM #Cust_tmp C
		CROSS JOIN (SELECT ProductID,GroupID
			    FROM #Group_Setting) AS T2					

/*
select count(*) from WinLimit_CustGameSetting where CustID in (select CustID from #Cust_tmp)
DROP TABLE #Group_Setting
DROP TABLE #Cust_tmp			    
*/
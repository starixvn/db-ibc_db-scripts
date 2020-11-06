/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
Create: 20201105@Sophia
Task: ReGen Data of Sum_Winloss_Old - due to data patch update epositiontaking [Redmine: #144902] 
DB: DBARC.bodb_Archive

*/

/*
CREATE TABLE #TransID (TransID BIGINT)


INSERT INTO  #TransID  (TransID)
VALUES
(	109371024526	)


CREATE  TABLE #CustList (WinlostDate SMALLDATETIME, TransID BIGINT, CustID INT)
INSERT INTO #CustList
SELECT winlostDate, TransID, CustID  FROM bodb_archive.dbo.Bettrans_BK WITH (NOLOCK)  WHERE TransID IN (Select TransID FROM #TransID)


SELECT WinlostDate,
STUFF((SELECT ',' + CONVERT(VARCHAR(10),CustID) FROM #Custlist t WHERE t.WinlostDate = n.WinlostDate  FOR XML PATH ('')), 1, 1, '') AS CustIDs
INTO #Query
FROM #Custlist n
GROUP BY WinlostDate


SELECT 'EXEC Task_sum_winloss_Old @WinlostDate = ''' + CONVERT(VARCHAR(10),WinlostDate, 121)+''', @CustIds = '''+ CustIDs + ''''  from #Query

*/
------------------------------EXCUTE SP----------------------------------------------

TRUNCATE TABLE [sum_winloss_old_tmp]

EXEC Task_sum_winloss_Old @WinlostDate = '2020-10-29', @CustIds = '46093945'

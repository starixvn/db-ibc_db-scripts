/*
	Created: 20170808@Helen
	Task: CWL - phase 4 - [Redmine: 81078]
	DB: DBCUST/CUSTDB
	
*/

CREATE TABLE #CustGameMonitoring_tmp (CustID INT,ProductID TINYINT,WinlostDate SMALLDATETIME,GroupID INT,Row_cnt INT)

CREATE TABLE #CustGameMonitoring_Result (CustID INT,ProductID TINYINT,WinlostDate SMALLDATETIME,GroupID INT,BetTypeID SMALLINT, ModifiedDate DATETIME)

-- Get list of duplicated data
INSERT INTO #CustGameMonitoring_tmp (CustID,ProductID,WinlostDate,GroupID,Row_cnt)
SELECT CustID,ProductID,WinlostDate,GroupID,COUNT(1) AS Row_cnt
FROM WinLimit_CustGameMonitoring CGM WITH (NOLOCK)
GROUP BY CustID,ProductID,WinlostDate,GroupID
HAVING COUNT(1) > 1
-- Keep the latest row
INSERT INTO #CustGameMonitoring_Result (CustID ,ProductID ,WinlostDate ,GroupID ,BetTypeID,ModifiedDate )
SELECT Tmp.CustID,Tmp.ProductID,Tmp.WinlostDate,Tmp.GroupID,Tmp.BetTypeID,ModifiedDate
FROM (
		SELECT CGM.CustID,CGM.ProductID,CGM.WinlostDate,CGM.GroupID,CGM.BetTypeID,ModifiedDate
			, ROW_NUMBER() OVER(PARTITION BY CGM.CustID,CGM.ProductID,CGM.WinlostDate,CGM.GroupID ORDER BY ModifiedDate DESC ) AS Row_Index
		FROM WinLimit_CustGameMonitoring CGM WITH (NOLOCK)
			INNER JOIN #CustGameMonitoring_tmp CGM_tmp ON CGM.CustID = CGM_tmp.CustID 
												AND  CGM.ProductID = CGM_tmp.ProductID
												AND CGM.WinlostDate = CGM_tmp.WinlostDate
												AND CGM.GroupID = CGM_tmp.GroupID
	) AS Tmp
WHERE tmp.Row_Index > 1

DELETE CGM
FROM WinLimit_CustGameMonitoring CGM WITH (NOLOCK)
	INNER JOIN  #CustGameMonitoring_Result CGM_tmp ON CGM.CustID = CGM_tmp.CustID 
												AND  CGM.ProductID = CGM_tmp.ProductID
												AND CGM.WinlostDate = CGM_tmp.WinlostDate
												AND CGM.GroupID = CGM_tmp.GroupID
												AND CGM.ModifiedDate = CGM_tmp.ModifiedDate
												AND CGM.BettypeID = CGM_tmp.BetTypeID

DROP TABLE #CustGameMonitoring_Result
DROP TABLE #CustGameMonitoring_tmp
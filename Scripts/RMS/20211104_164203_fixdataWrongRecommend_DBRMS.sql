/*<info serverAlias="DBMRS-bodb_RMS"></info>*/
/*
	Create : 20211104@Danny
	Update wrong data for DBMRS - [Redmine: #164203] 
	DB: DBMRS.bodb_RMS
*/
USE bodb_RMS
-- List users
CREATE TABLE #tmp_users (
	custID INT,
	Old_recommend INT,
	New_recommend INT,
	username NVARCHAR(50)
)

INSERT INTO #tmp_users (custID, Old_recommend, New_recommend, username)
SELECT  custid, 56713984 AS Old_recommend, recommend AS New_recommend, username
FROM	bodb02.dbo.Customer WITH(NOLOCK)
WHERE recommend = 56713996
AND roleid = 1

INSERT INTO #tmp_users (custID, Old_recommend, New_recommend, username)
SELECT  custid, 56948071 AS Old_recommend, recommend AS New_recommend, username
FROM	bodb02.dbo.Customer WITH(NOLOCK)
WHERE recommend = 56948082
AND roleid = 1


--rmBettrans
UPDATE t
SET t.recommend = tmp.New_recommend,
	t.username = tmp.username
FROM dbo.rmBettrans t WITH(ROWLOCK, UPDLOCK)
INNER JOIN #tmp_users tmp ON t.recommend = tmp.Old_recommend AND t.custid = tmp.custID

--rmBettrans_Old
UPDATE t
SET t.recommend = tmp.New_recommend,
	t.username = tmp.username
FROM dbo.rmBettrans_Old t WITH(ROWLOCK, UPDLOCK)
INNER JOIN #tmp_users tmp ON t.recommend = tmp.Old_recommend AND t.custid = tmp.custID
WHERE t.winlostdate >=  '2021-10-27'

--rmSumWinloss
UPDATE	t
SET		t.recommend = tmp.New_recommend,
		t.username = tmp.username
FROM	dbo.rmSumWinloss t WITH(ROWLOCK, UPDLOCK)
INNER JOIN #tmp_users tmp ON t.custid = tmp.custID AND t.recommend = tmp.Old_recommend
WHERE t.winlostdate >=  '2021-10-27'

--rmSumWinloss_Old
UPDATE	t
SET		t.recommend = tmp.New_recommend,
		t.username =  tmp.username
FROM	dbo.rmSumWinloss_Old t WITH(ROWLOCK, UPDLOCK)
INNER JOIN #tmp_users tmp ON t.custid = tmp.custID AND t.recommend = tmp.Old_recommend
WHERE t.winlostdate >=  '2021-10-27'

DROP TABLE #tmp_users
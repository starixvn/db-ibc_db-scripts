 /*<info serverAlias="DBSUM-bodb_Summary"></info>*/
/*
	Create : 20211104@Danny
	Update wrong data for DBSUM - [Redmine: #164203] 
	DB: DBSUM.bodb_Summary
*/

USE bodb_Summary
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

-- List recommend
CREATE TABLE #tmp_recommend (
	Old_recommend INT,
	New_recommend INT,
	username NVARCHAR(50)
)
INSERT INTO #tmp_recommend(Old_recommend, New_recommend, username)
SELECT  56713984 AS Old_recommend, custID AS New_recommend, username
FROM	bodb02.dbo.Customer WITH(NOLOCK)
WHERE   custID = 56713996 AND roleid = 2

INSERT INTO #tmp_recommend(Old_recommend, New_recommend, username)
SELECT  56948071 AS Old_recommend, custID AS New_recommend, username
FROM	bodb02.dbo.Customer WITH(NOLOCK)
WHERE   custID = 56948082 AND roleid = 2




UPDATE t
SET	 t.recommend = tmp.New_recommend,
	 t.username = tmp.username
FROM bodb_Summary.dbo.sum_winloss_old t WITH(ROWLOCK, UPDLOCK)
INNER JOIN #tmp_users tmp ON t.recommend = tmp.Old_recommend AND t.custid = tmp.custID
WHERE t.roleid = 1 AND t.winlostdate >=  '2021-10-27'

UPDATE t
SET	 t.custid    =  tmp.New_recommend,
	 t.recommend =  tmp.New_recommend,
	 t.username  =  tmp.username
FROM bodb_Summary.dbo.sum_winloss_old t WITH(ROWLOCK, UPDLOCK)
INNER JOIN #tmp_recommend tmp ON t.Recommend = tmp.Old_recommend 
WHERE  t.roleid = 2 AND t.winlostdate >=  '2021-10-27'


DROP TABLE #tmp_users
DROP TABLE #tmp_recommend
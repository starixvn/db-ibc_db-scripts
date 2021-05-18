/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
USE bodb_RMS

CREATE TABLE #rmCustomerUpdate (custid INT, level TINYINT)
INSERT INTO #rmCustomerUpdate (custid)
SELECT custid
FROM dbo.rmCustomer WITH(NOLOCK)
WHERE level = 5

--- Update
UPDATE t
SET t.level = 9
FROM dbo.rmCustomer t WITH(ROWLOCK)
INNER JOIN #rmCustomerUpdate u ON t.custid = u.custid
WHERE t.level = 5


DROP TABLE #rmCustomerUpdate




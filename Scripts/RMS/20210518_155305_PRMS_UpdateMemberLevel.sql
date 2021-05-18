/*<info serverAlias="DBRMS-bodb_RMS" isFunction="0" isNested=""></info>*/
USE bodb_RMS

CREATE TABLE rmCustomer_backup (custid INT, level TINYINT)
INSERT INTO rmCustomer_backup (custid, level)
SELECT custid, level
FROM dbo.rmCustomer WITH(NOLOCK)
WHERE level IN (5,9)

--- Update
UPDATE t
SET t.level = 9
FROM dbo.rmCustomer t WITH(ROWLOCK)
WHERE t.level = 5


DROP TABLE rmCustomer_backup




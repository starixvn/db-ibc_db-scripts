/*<info serverAlias="DBCONSISTENCY-bodb02" executers="bodbAdminNet" viewers="" isFunction="0"></info>*/
/*
	Created: 20220915@Sol
	Task: Data consistency - Add new settings
	DB: DBCONSISTENCY-bodb02

	Revisions: 
		- 20220915@Sol: Scale out DBTrans - Detect data consistency SiteDB and CentralDB 
						- Add new settings - [Redmine:#175881]

*/

USE bodb02;

GO 

DECLARE 
		@checkDiffSiteGroupIdKey VARCHAR(50) = 'DiffSGId_LastTransId'
		,@lastTransID BIGINT = 0 --- for the first time run sp, 

SELECT @lastTransID = MAX(t.TransId)
FROM Transfer t WITH (NOLOCK)

---key for difft site group id in main db
BEGIN
	IF NOT EXISTS (
			SELECT 1
			FROM bodb02.dbo.SystemSettings s WITH (NOLOCK)
			WHERE s.VName = @checkDiffSiteGroupIdKey
			)
	BEGIN

		---insert to table setting
		INSERT INTO bodb02.dbo.SystemSettings (VName,VValue)
		VALUES (@checkDiffSiteGroupIdKey,CAST(@lastTransID AS VARCHAR(200)))
		
	END
	ELSE --get value from system setting
	BEGIN
		UPDATE bodb02.dbo.SystemSettings
			SET VValue = CAST(@lastTransID AS VARCHAR(200))
		WHERE VName = @checkDiffSiteGroupIdKey
	END
END

---verify data - should have 1 row with value <> 0
SELECT * 
FROM bodb02.dbo.SystemSettings s WITH(NOLOCK)
WHERE s.VName IN (@checkDiffSiteGroupIdKey)
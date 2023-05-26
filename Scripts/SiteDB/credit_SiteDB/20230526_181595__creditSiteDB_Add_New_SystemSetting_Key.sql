/*<info serverAlias="DBSIC-bodb02"></info>*/

/*
	Created by: Danny
	Date: 2023-05-26
	Task: Update and init system setting
	DB: DBSIC-bodb02 
	
*/
USE bodb02;

GO 

DECLARE 
		@checkCountKey VARCHAR(50) = 'SiteDB_CheckCons_Transfer_Count_LastTransId'
		,@checkDiffSiteGroupIdKey VARCHAR(50) = 'SiteDB_CheckCons_Transfer_DiffSGId_LastTransId'
		,@lastTransID BIGINT = 0 --- for the first time run sp, 

SELECT @lastTransID = MAX(t.TransId)
FROM Transfer t WITH (NOLOCK)

---key for check count/checksum
BEGIN
	IF NOT EXISTS (
			SELECT 1
			FROM bodb02.dbo.SystemSettings s WITH (NOLOCK)
			WHERE s.VName = @checkCountKey
			)
	BEGIN
		---insert to table setting
		INSERT INTO bodb02.dbo.SystemSettings (VName,VValue)
		VALUES (@checkCountKey,CAST(@lastTransID AS VARCHAR(200)))
	END
	ELSE --get value from system setting
	BEGIN
		UPDATE bodb02.dbo.SystemSettings
			SET VValue = CAST(@lastTransID AS VARCHAR(200))
		WHERE VName = @checkCountKey
	END
END

---key for diff site group id in sitedb
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

---verify data - should have 2 rows with value <> 0
SELECT * 
FROM bodb02.dbo.SystemSettings s WITH(NOLOCK)
WHERE s.VName IN (@checkCountKey, @checkDiffSiteGroupIdKey)

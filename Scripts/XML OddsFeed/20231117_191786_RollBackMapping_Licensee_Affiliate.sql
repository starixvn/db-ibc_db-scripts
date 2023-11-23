/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/

/*
	Created: 20231010@Lewis
	DB: DBODDSFEED-bodb_OddsFeed
	Task: ROLLBACK Mapping Licensee - Affiliate [RedmineID: #191786]
	Description:

			- STEP 1:	DELETE --> dbo.system

			- STEP 2:	DELETE --> dbo.AdminUserSystem
								   dbo.OddsSystemProfile
								   dbo.SystemDomain
								   dbo.SystemIP
						UPDATE --> dbo.Partner --> get old systemID for affilate
					   
*/
USE bodb_oddsfeed

DECLARE @SystemName NVARCHAR(50) = 'alog'
		,@SystemId	SMALLINT 
		,@licenseeID SMALLINT = 3

IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.System WITH (NOLOCK) WHERE SystemName = @SystemName)
BEGIN	
	SELECT @SystemName + ' does not exist' AS MSG
	RETURN
END

SELECT @SystemId = SystemID FROM dbo.System WITH (NOLOCK) WHERE SystemName = @SystemName

-- DELETE
DELETE 
FROM dbo.System 
WHERE SystemId = @SystemId

IF EXISTS (SELECT TOP 1 1 FROM AdminUserSystem WITH (NOLOCK) WHERE SystemID = @SystemId )
BEGIN
	DELETE 
	FROM AdminUserSystem 
	WHERE SystemID = @SystemId
END

IF EXISTS (SELECT TOP 1 1 FROM OddsSystemProfile WITH (NOLOCK) WHERE SystemID = @SystemId )
BEGIN
	DELETE 
	FROM OddsSystemProfile  
	WHERE SystemID = @SystemId
END

IF EXISTS (SELECT TOP 1 1 FROM SystemDomain WITH (NOLOCK) WHERE SystemID = @SystemId )
BEGIN
	DELETE
	FROM SystemDomain 
	WHERE SystemID = @SystemId
END

IF EXISTS (SELECT TOP 1 1 FROM SystemIP WITH (NOLOCK) WHERE SystemID = @SystemId )
BEGIN
	DELETE
	FROM SystemIP 
	WHERE SystemID = @SystemId
END

-- UPDATE
IF EXISTS (SELECT TOP 1 1 FROM Partner WITH (NOLOCK) WHERE SystemID = @SystemId )
BEGIN
	UPDATE A WITH (ROWLOCK,UPDLOCK) 
	SET A.SystemID = @licenseeID
	FROM Partner A
	WHERE SystemID = @SystemId
END

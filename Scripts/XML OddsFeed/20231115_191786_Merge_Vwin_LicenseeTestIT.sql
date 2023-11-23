/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
USE bodb_oddsfeed
 
/*
	Created: 20231115@Lewis
	DB: DBODDSFEED-bodb_OddsFeed
	Task: Mapping Licensee - Affiliate [RedmineID: #191786]
	Description:

					Step 1 : get SystemId ==> OthersId - VwinId - LicenseeTestITId

					Step 2 : insert ==> dbo.AdminUserSystem 
										dbo.OddsSystemProfile
										dbo.SystemDomain
										dbo.SystemIP
							 update ==> dbo.Partner 
							 
							 delete 'LicenseeTestIT' + 'Vwin'
*/



-- =======
-- STEP 1
-- =======
DECLARE @SystemName NVARCHAR(50) = N'Others'

IF NOT EXISTS (SELECT SystemId FROM dbo.System WITH (NOLOCK) WHERE SystemName = @SystemName)
BEGIN 
	SELECT 'Licensee '+ @SystemName +' does not exist' 
	RETURN
END

DECLARE @VwinID SMALLINT = (SELECT SystemID FROM dbo.System WITH (NOLOCK) WHERE SystemName = 'Vwin'),
		@LicenseeTestID SMALLINT = (SELECT SystemID FROM dbo.System WITH (NOLOCK) WHERE SystemName = 'LicenseeTestIT'),
		@OthersID SMALLINT = (SELECT SystemId FROM dbo.System WITH (NOLOCK) WHERE SystemName = @SystemName)

-- =======
-- STEP 2
-- =======

IF EXISTS (SELECT TOP 1 1 FROM AdminUserSystem WITH (NOLOCK) WHERE SystemID IN (@VwinID,@LicenseeTestID))
BEGIN
	
	SELECT DISTINCT
		@OthersID AS SystemID,
		UserID,
		1 AS IsActive,
		IsHost
	INTO #AdminUserSystem
	FROM AdminUserSystem
	WHERE SystemID IN (@VwinID,@LicenseeTestID,@OthersID)

	DELETE A
	FROM AdminUserSystem A
	WHERE SystemID = @OthersID

	INSERT INTO AdminUserSystem (SystemID,UserID,IsActive,IsHost)
	SELECT SystemID,UserID,IsActive,IsHost FROM #AdminUserSystem
	
	DELETE A
	FROM AdminUserSystem A
	WHERE SystemID IN (@VwinID,@LicenseeTestID)

	DROP TABLE #AdminUserSystem

END

IF EXISTS (SELECT TOP 1 1 FROM OddsSystemProfile WITH (NOLOCK) WHERE SystemID IN (@VwinID,@LicenseeTestID))
BEGIN
	
	DELETE A
	FROM OddsSystemProfile A
	WHERE SystemID IN (@VwinID,@LicenseeTestID)

END

IF EXISTS (SELECT TOP 1 1 FROM SystemDomain WITH (NOLOCK) WHERE SystemID IN (@VwinID,@LicenseeTestID))
BEGIN
	
	SELECT DISTINCT
		@OthersID as SystemId,
		DomainID
	INTO #SystemDomain
	FROM SystemDomain
	WHERE SystemID IN (@VwinID,@LicenseeTestID,@OthersID)

	DELETE B
	FROM SystemDomain B
	WHERE SystemID = @OthersID

	INSERT INTO SystemDomain (SystemID, DomainID)
	SELECT SystemID, DomainID FROM #SystemDomain

	DELETE B
	FROM SystemDomain B
	WHERE SystemID IN (@VwinID,@LicenseeTestID)

	DROP TABLE #SystemDomain

END


IF EXISTS (SELECT TOP 1 1 FROM SystemIP WITH (NOLOCK) WHERE SystemID IN (@VwinID,@LicenseeTestID))
BEGIN
	
	SELECT DISTINCT
		@OthersID AS SystemID,
		IPFrom,
		IPTo,
		Creator,
		CreatedDate,
		UpdatedBy,
		GETDATE() AS LastUpdate
	INTO #SystemIP
	FROM SystemIP
	WHERE SystemID IN (@VwinID,@LicenseeTestID,@OthersID)

	DELETE C
	FROM SystemIP C
	WHERE SystemID = @OthersID

	INSERT INTO SystemIP (SystemID, IPFrom, IPTo, Creator, CreatedDate, UpdatedBy, LastUpdate)
	SELECT SystemID, IPFrom, IPTo, Creator, CreatedDate, UpdatedBy, LastUpdate FROM #SystemIP
	
	DELETE C
	FROM SystemIP C
	WHERE SystemID IN (@VwinID,@LicenseeTestID)

	DROP TABLE #SystemIP

END


IF EXISTS (SELECT TOP 1 1 FROM Partner WITH (NOLOCK) WHERE SystemID IN (@VwinID,@LicenseeTestID))
BEGIN
	UPDATE A WITH (ROWLOCK, UPDLOCK)
	SET A.SystemID = @OthersID , A.LastUpdate = GETDATE()
	FROM Partner A
	WHERE SystemID IN (@VwinID,@LicenseeTestID)
END

IF EXISTS (SELECT TOP 1 1 FROM System WITH (NOLOCK) WHERE SystemID IN (@VwinID,@LicenseeTestID))
BEGIN
	DELETE A
	FROM dbo.System A
	WHERE SystemID IN (@VwinID,@LicenseeTestID)

	UPDATE A WITH (ROWLOCK,UPDLOCK)
	SET A.IsActive = 1
	FROM System A
	WHERE SystemID = @OthersID
END







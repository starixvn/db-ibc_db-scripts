/*
	Creator:	20160510@Billy
	Task:		Add N/A setting for Product, Sub-Product and Bettype
	DB:			DBCRM/bodb_CRM
*/

--	BEGIN STEP 1:
--		DEPLOY THIS SCRIPT ON DBCRM/bodb_CRM
------------------------------------------------------------

DECLARE	@SettingName		VARCHAR(50)
	,	@SettingValue		NVARCHAR(100)
	,	@IP					VARCHAR(15)
	,	@UserID				INT = 0
	,	@DisplayOrder		INT
	,	@ParentID			INT = 0
	,	@SettingID			INT

CREATE TABLE	#Setting (
					SettingID		INT
				,	Finished		BIT
				)

--	Add N/A. settings
SELECT	@IP = CONVERT(VARCHAR, CONNECTIONPROPERTY('client_net_address'))
	
SELECT	@SettingValue = N'N/A.'

SELECT	@SettingName = 'Product'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = -1, @IP = @IP

SELECT	@SettingName = 'SubProduct'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = -1, @IP = @IP

SELECT	@SettingName = 'BetType'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = -1, @IP = @IP

--	Mapping Product with SubProduct 'N/A.'
INSERT INTO #Setting
	(	SettingID   , Finished)
SELECT	cs.SettingID, 0
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'Product'

SELECT	@SettingID = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'SubProduct'
	AND	cs.SettingValue = N'N/A.'

WHILE	0 = 0
BEGIN
    UPDATE	TOP(1) #Setting
	SET		@ParentID = SettingID
		,	Finished = 1
	WHERE	Finished = 0

	IF	@@ROWCOUNT = 0
		BREAK

	EXECUTE	dbo.Acc_CRM_SettingRelationIns @UserID = @UserID, @SettingID = @SettingID, @ParentID = @ParentID, @DisplayOrder = -1, @IP = @IP
END

TRUNCATE TABLE #Setting

--	Mapping SubProduct with BetType 'N/A.'
INSERT INTO #Setting
	(	SettingID   , Finished)
SELECT	cs.SettingID, Finished = 0
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'SubProduct'

SELECT	@SettingID = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'BetType'
	AND	cs.SettingValue = N'N/A.'

WHILE	0 = 0
BEGIN
    UPDATE	TOP(1) #Setting
	SET		@ParentID = SettingID
		,	Finished = 1
	WHERE	Finished = 0

	IF	@@ROWCOUNT = 0
		BREAK

	EXECUTE	dbo.Acc_CRM_SettingRelationIns @UserID = @UserID, @SettingID = @SettingID, @ParentID = @ParentID, @DisplayOrder = -1, @IP = @IP
END

DROP TABLE #Setting
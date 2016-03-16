/*
	Creator:	20160315@Billy
	Task:		Migrate Data to support Sub-Product field integration
	DB:			DBCRM/bodb_CRM
*/

--	BEGIN STEP 1:
--		DEPLOY THIS SCRIPT ON DBCRM/bodb_CRM
------------------------------------------------------------
DECLARE	@SettingName		VARCHAR(50)
	,	@SettingValue		NVARCHAR(100)
	,	@ParentID			INT

CREATE TABLE	#mapping (
					Product			NVARCHAR(100)
				,	SubProduct		NVARCHAR(100)
				,	ProductID		INT
				,	SubProductID	INT
				)

INSERT INTO #mapping
		(	Product				, SubProduct)
VALUES	(	N'Sportsbook'		, N'Soccer')
	,	(	N'Sportsbook'		, N'Basketball')
	,	(	N'Sportsbook'		, N'Badminton')			-- new
	,	(	N'Sportsbook'		, N'Baseball')
	,	(	N'Sportsbook'		, N'ESports')
	,	(	N'Sportsbook'		, N'Tennis')
	,	(	N'Sportsbook'		, N'American Football')	-- new
	,	(	N'Sportsbook'		, N'Cricket')
	,	(	N'Sportsbook'		, N'Darts')				-- new
	,	(	N'Sportsbook'		, N'Field Hockey')		-- new
	,	(	N'Sportsbook'		, N'Golf')				-- new
	,	(	N'Sportsbook'		, N'Ice Hockey')		-- new
	,	(	N'Sportsbook'		, N'Motorsport')		-- new
	,	(	N'Sportsbook'		, N'Muay Thai')
	,	(	N'Sportsbook'		, N'Rugby')				-- new
	,	(	N'Sportsbook'		, N'Snooker/Pool')		-- new
	,	(	N'Sportsbook'		, N'Volleyball')		-- new
	,	(	N'Sportsbook'		, N'Athletics')			-- new
	,	(	N'Sportsbook'		, N'Boxing/MMA')		-- new
	,	(	N'Sportsbook'		, N'Cycling')			-- new
	,	(	N'Sportsbook'		, N'Diving')			-- new
	,	(	N'Sportsbook'		, N'Entertainment')		-- new
	,	(	N'Sportsbook'		, N'Handball')			-- new
	,	(	N'Sportsbook'		, N'Netball')			-- new
	,	(	N'Sportsbook'		, N'Squash')			-- new
	,	(	N'Sportsbook'		, N'Swimming')			-- new
	,	(	N'Sportsbook'		, N'Water Polo')		-- new
	,	(	N'Sportsbook'		, N'Other Sports')

	,	(	N'Virtual Sports'	, N'Virtual Soccer')	-- new
	,	(	N'Virtual Sports'	, N'Virtual Racing')	-- new
	,	(	N'Virtual Sports'	, N'Virtual Tennis')	-- new
	,	(	N'Virtual Sports'	, N'Virtual Greyhound')	-- new
	,	(	N'Virtual Sports'	, N'Virtual Speedway')	-- new
	,	(	N'Virtual Sports'	, N'Virtual MotorGP')	-- new

	,	(	N'Racing'			, N'Horse Racing')
	,	(	N'Racing'			, N'Greyhound Racing')
	,	(	N'Racing'			, N'Harness Racing')

	,	(	N'Gaming'			, N'Keno')
	,	(	N'Gaming'			, N'Casino')
	,	(	N'Gaming'			, N'Live Casino')
	,	(	N'Gaming'			, N'Number Game')
	,	(	N'Gaming'			, N'Turbo Number Game')
	,	(	N'Gaming'			, N'Gold Deluxe')
	,	(	N'Gaming'			, N'Asian Gaming')

	,	(	N'Sportsbook'		, N'Basket Ball')		-- inactive
	,	(	N'Sportsbook'		, N'Others')			-- inactive
	,	(	N'Sportsbook'		, N'Olympic 2012')		-- inactive
	,	(	N'Sportsbook'		, N'Sportbook')			-- inactive
	,	(	N'Sportsbook'		, N'Superlive')			-- inactive
	,	(	N'Sportsbook'		, N'Bettrade')			-- inactive
	,	(	N'Sportsbook'		, N'Colossus Bet')		-- inactive
	,	(	N'Gaming'			, N'Bingo')				-- inactive
	,	(	N'Gaming'			, N'NA1')				-- inactive
	,	(	N'Gaming'			, N'Bet2')				-- inactive
	,	(	N'Gaming'			, N'Mini Games')		   
	,	(	N'Gaming'			, N'Poker')				-- inactive
	,	(	N'Virtual Sports'	, N'Virtual Sports')

DECLARE	@IP			VARCHAR(15)
SELECT	@IP = CONVERT(VARCHAR, CONNECTIONPROPERTY('client_net_address'))


-- Insert new Product into ParentProduct Setting
SELECT	@SettingName = 'ParentProduct'
	,	@ParentID = 0
	
SELECT	@SettingValue = N'Sportsbook'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Virtual Sports'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Racing'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Gaming'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP


-- Insert new Sub-Product into current Product Setting
SELECT	@SettingName = 'Product'

SELECT	@ParentID = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'ParentProduct'
	AND	cs.SettingValue = N'Sportsbook'

SELECT	@SettingValue = N'Badminton'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'American Football'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Darts'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Field Hockey'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Golf'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Ice Hockey'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Motorsport'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Rugby'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Snooker/Pool'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Volleyball'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Athletics'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Boxing/MMA'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Cycling'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Diving'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Entertainment'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Handball'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Netball'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Squash'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Swimming'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Water Polo'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@ParentID = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'ParentProduct'
	AND	cs.SettingValue = N'Virtual Sports'

SELECT	@SettingValue = N'Virtual Soccer'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Virtual Racing'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Virtual Tennis'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Virtual Greyhound'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Virtual Speedway'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

SELECT	@SettingValue = N'Virtual MotorGP'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = 0, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 0, @IP = @IP

-- Map relationship between ParentProduct and current Product
UPDATE	m
SET		m.ProductID = p.SettingID
	,	m.SubProductID = sp.SettingID
FROM	#mapping AS m
LEFT JOIN	dbo.crmSetting AS p WITH (NOLOCK)
		ON	p.SettingName = 'ParentProduct'
		AND	p.SettingValue = m.Product
LEFT JOIN	dbo.crmSetting AS sp WITH (NOLOCK)
		ON	sp.SettingName = 'Product'
		AND	sp.SettingValue = m.SubProduct

UPDATE	csr
SET		csr.ParentID = m.ProductID
FROM		dbo.crmSettingRelation AS csr WITH (ROWLOCK, UPDLOCK)
INNER JOIN	#mapping AS m
		ON	csr.SettingID = m.SubProductID
WHERE	csr.ParentID = 0

SELECT *
FROM #mapping AS m

DROP TABLE #mapping
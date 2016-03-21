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
				,	isActive		TINYINT
				)

INSERT INTO #mapping
		(	Product				, SubProduct			, isActive	)
VALUES	(	N'Sportsbook'		, N'Soccer'				, 1			)
	,	(	N'Sportsbook'		, N'Basketball'			, 1			)
	,	(	N'Sportsbook'		, N'Badminton'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Baseball'			, 1			)
	,	(	N'Sportsbook'		, N'ESports'			, 1			)
	,	(	N'Sportsbook'		, N'Tennis'				, 1			)
	,	(	N'Sportsbook'		, N'American Football'	, 2			)	-- new
	,	(	N'Sportsbook'		, N'Cricket'			, 1			)
	,	(	N'Sportsbook'		, N'Darts'				, 2			)	-- new
	,	(	N'Sportsbook'		, N'Field Hockey'		, 2			)	-- new
	,	(	N'Sportsbook'		, N'Golf'				, 2			)	-- new
	,	(	N'Sportsbook'		, N'Ice Hockey'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Motorsport'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Muay Thai'			, 1			)
	,	(	N'Sportsbook'		, N'Rugby'				, 2			)	-- new
	,	(	N'Sportsbook'		, N'Snooker/Pool'		, 2			)	-- new
	,	(	N'Sportsbook'		, N'Volleyball'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Athletics'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Boxing/MMA'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Cycling'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Diving'				, 2			)	-- new
	,	(	N'Sportsbook'		, N'Entertainment'		, 2			)	-- new
	,	(	N'Sportsbook'		, N'Handball'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Netball'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Squash'				, 2			)	-- new
	,	(	N'Sportsbook'		, N'Swimming'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Water Polo'			, 2			)	-- new
	,	(	N'Sportsbook'		, N'Other Sports'		, 1			)

	,	(	N'Virtual Sports'	, N'Virtual Soccer'		, 2			)	-- new
	,	(	N'Virtual Sports'	, N'Virtual Racing'		, 2			)	-- new
	,	(	N'Virtual Sports'	, N'Virtual Tennis'		, 2			)	-- new
	,	(	N'Virtual Sports'	, N'Virtual Greyhound'	, 2			)	-- new
	,	(	N'Virtual Sports'	, N'Virtual Speedway'	, 2			)	-- new
	,	(	N'Virtual Sports'	, N'Virtual MotorGP'	, 2			)	-- new

	,	(	N'Racing'			, N'Horse Racing'		, 1			)
	,	(	N'Racing'			, N'Greyhound Racing'	, 1			)
	,	(	N'Racing'			, N'Harness Racing'		, 1			)

	,	(	N'Gaming'			, N'Keno'				, 1			)
	,	(	N'Gaming'			, N'Casino'				, 1			)
	,	(	N'Gaming'			, N'Live Casino'		, 1			)
	,	(	N'Gaming'			, N'Number Game'		, 1			)
	,	(	N'Gaming'			, N'Turbo Number Game'	, 1			)
	,	(	N'Gaming'			, N'Gold Deluxe'		, 1			)
	,	(	N'Gaming'			, N'Asian Gaming'		, 1			)

	,	(	N'Sportsbook'		, N'Basket Ball'		, 0			)	-- inactive
	,	(	N'Sportsbook'		, N'Others'				, 0			)	-- inactive
	,	(	N'Sportsbook'		, N'Olympic 2012'		, 0			)	-- inactive
	,	(	N'Sportsbook'		, N'Sportbook'			, 0			)	-- inactive
	,	(	N'Sportsbook'		, N'Superlive'			, 0			)	-- inactive
	,	(	N'Sportsbook'		, N'Bettrade'			, 0			)	-- inactive
	,	(	N'Sportsbook'		, N'Colossus Bet'		, 0			)	-- inactive
	,	(	N'Gaming'			, N'Bingo'				, 0			)	-- inactive
	,	(	N'Gaming'			, N'NA1'				, 0			)	-- inactive
	,	(	N'Gaming'			, N'Bet2'				, 0			)	-- inactive
	,	(	N'Gaming'			, N'Mini Games'			, 1			)		   
	,	(	N'Gaming'			, N'Poker'				, 0			)	-- inactive
	,	(	N'Virtual Sports'	, N'Virtual Sports'		, 1			)

DECLARE	@IP			VARCHAR(15)
SELECT	@IP = CONVERT(VARCHAR, CONNECTIONPROPERTY('client_net_address'))

DECLARE	@UserID			INT = 0
	,	@DisplayOrder	INT

-- Insert new Product into ParentProduct Setting
SELECT	@SettingName = 'ParentProduct'
	,	@ParentID = 0
	
SELECT	@SettingValue = N'Sportsbook'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 1, @IP = @IP

SELECT	@SettingValue = N'Virtual Sports'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 2, @IP = @IP

SELECT	@SettingValue = N'Racing'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 3, @IP = @IP

SELECT	@SettingValue = N'Gaming'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = 4, @IP = @IP


-- Insert new Sub-Product into current Product Setting
SELECT	@SettingName = 'Product'
	,	@DisplayOrder = MAX(cs.DisplayOrder) + 1
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'Product'
GROUP BY cs.SettingName

SELECT	@ParentID = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'ParentProduct'
	AND	cs.SettingValue = N'Sportsbook'

SELECT	@SettingValue = N'Badminton'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'American Football'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Darts'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Field Hockey'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Golf'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Ice Hockey'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Motorsport'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Rugby'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Snooker/Pool'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Volleyball'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Athletics'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Boxing/MMA'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Cycling'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Diving'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Entertainment'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Handball'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Netball'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Squash'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Swimming'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Water Polo'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@ParentID = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'ParentProduct'
	AND	cs.SettingValue = N'Virtual Sports'

SELECT	@SettingValue = N'Virtual Soccer'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Virtual Racing'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Virtual Tennis'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Virtual Greyhound'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Virtual Speedway'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

SELECT	@SettingValue = N'Virtual MotorGP'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

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

-- Inactive newly added Product
UPDATE	cs
SET		cs.IsActive = 0
FROM		dbo.crmSetting AS cs WITH (ROWLOCK, UPDLOCK)
INNER JOIN	#mapping AS m
		ON	m.SubProductID = cs.SettingID
WHERE	m.isActive = 2

-- Delete 2 unused products
DELETE	csr
FROM		dbo.crmSettingRelation csr
INNER JOIN	dbo.crmSetting AS cs WITH (NOLOCK)
		ON	cs.SettingID = csr.SettingID
WHERE	cs.SettingName = 'Product'
	AND	cs.SettingValue IN ('Accounting', 'test2')

DELETE	dbo.crmSetting
WHERE	SettingName = 'Product'
	AND	SettingValue IN ('Accounting', 'test2')

SELECT *
FROM #mapping AS m

DROP TABLE #mapping
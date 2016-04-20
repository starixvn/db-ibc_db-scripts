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
	,	(	N'Virtual Sports'	, N'Virtual Motorsports', 2			)	-- new

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
	,	@DisplayOrder = ISNULL(MAX(cs.DisplayOrder) + 1, 1)
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

SELECT	@SettingValue = N'Virtual Motorsports'
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


--	BEGIN STEP 2:
--		DEPLOY THIS SCRIPT ON DBCRM/bodb_CRM
------------------------------------------------------------
CREATE TABLE	#bettypeMap (
					SubProduct		NVARCHAR(100)
				,	BetType			NVARCHAR(100)
				,	SubProductID	INT
				,	BetTypeID		INT
				)

INSERT INTO	#bettypeMap
		(	SubProduct            , BetType                          )
VALUES	(	N'Soccer'             , N'Handicap'                      )
	,	(	N'Soccer'             , N'1H Handicap'                   )
	,	(	N'Soccer'             , N'Over/Under'                    )
	,	(	N'Soccer'             , N'1H Over/Under'                 )
	,	(	N'Soccer'             , N'Odd/Even'                      )
	,	(	N'Soccer'             , N'1H Odd/Even'                   )
	,	(	N'Soccer'             , N'Correct Score'                 )
	,	(	N'Soccer'             , N'FT.1X2'                        )
	,	(	N'Soccer'             , N'1H 1X2'                        )
	,	(	N'Soccer'             , N'Both/One/Neither Team To Score')
	,	(	N'Soccer'             , N'Mix Parlay'                    )
	,	(	N'Soccer'             , N'System Parlay'                 )
	,	(	N'Soccer'             , N'Outright'                      )
	,	(	N'Soccer'             , N'Special Bet Types'             )
								  						             
	,	(	N'Basketball'         , N'Handicap'                      )
	,	(	N'Basketball'         , N'1H Handicap'                   )
	,	(	N'Basketball'         , N'Over/Under'                    )
	,	(	N'Basketball'         , N'1H Over/Under'                 )
	,	(	N'Basketball'         , N'Odd/Even'                      )
	,	(	N'Basketball'         , N'1H Odd/Even'                   )
	,	(	N'Basketball'         , N'Mix Parlay'                    )
	,	(	N'Basketball'         , N'System Parlay'                 )
	,	(	N'Basketball'         , N'Outright'                      )
								  						             
	,	(	N'Badminton'          , N'Moneyline'                     )
	,	(	N'Badminton'          , N'Handicap'                      )
	,	(	N'Badminton'          , N'Over/Under'                    )
	,	(	N'Badminton'          , N'Odd/Even'                      )
	,	(	N'Badminton'          , N'Mix Parlay'                    )
	,	(	N'Badminton'          , N'System Parlay'                 )
	,	(	N'Badminton'          , N'Outright'                      )
								  						             
	,	(	N'Baseball'           , N'Moneyline'                     )
	,	(	N'Baseball'           , N'Total Run'                     )
	,	(	N'Baseball'           , N'1H Total Run'                  )
	,	(	N'Baseball'           , N'Runline'                       )
	,	(	N'Baseball'           , N'1H Runline'                    )
								    					             
	,	(	N'ESports'            , N'Moneyline'                     )
	,	(	N'ESports'            , N'Handicap'                      )
								    					             
	,	(	N'Tennis'             , N'Moneyline'                     )
	,	(	N'Tennis'             , N'Handicap'                      )
	,	(	N'Tennis'             , N'Over/Under'                    )
	,	(	N'Tennis'             , N'Odd/Even'                      )
	,	(	N'Tennis'             , N'Mix Parlay'                    )
	,	(	N'Tennis'             , N'System Parlay'                 )
	,	(	N'Tennis'             , N'Outright'                      )
	,	(	N'Tennis'             , N'Set X Winner'                  )		-- new
								    					             
	,	(	N'American Football'  , N'Moneyline'                     )
	,	(	N'American Football'  , N'Handicap'                      )
	,	(	N'American Football'  , N'Over/Under'                    )
	,	(	N'American Football'  , N'Odd/Even'                      )
	,	(	N'American Football'  , N'Mix Parlay'                    )
	,	(	N'American Football'  , N'System Parlay'                 )
	,	(	N'American Football'  , N'Outright'                      )
								    					             
	,	(	N'Cricket'            , N'Match Winner'                  )
	,	(	N'Cricket'            , N'FT.1X2'                        )
	,	(	N'Cricket'            , N'Handicap'                      )
	,	(	N'Cricket'            , N'Over/Under'                    )
	,	(	N'Cricket'            , N'Odd/Even'                      )
	,	(	N'Cricket'            , N'Mix Parlay'                    )
	,	(	N'Cricket'            , N'System Parlay'                 )
	,	(	N'Cricket'            , N'Outright'                      )
								    					             
	,	(	N'Darts'              , N'Moneyline'                     )
	,	(	N'Darts'              , N'Handicap'                      )
	,	(	N'Darts'              , N'Over/Under'                    )
	,	(	N'Darts'              , N'Odd/Even'                      )
	,	(	N'Darts'              , N'Mix Parlay'                    )
	,	(	N'Darts'              , N'System Parlay'                 )
	,	(	N'Darts'              , N'Outright'                      )
								    					             
	,	(	N'Field Hockey'       , N'Moneyline'                     )
	,	(	N'Field Hockey'       , N'Handicap'                      )
	,	(	N'Field Hockey'       , N'Over/Under'                    )
	,	(	N'Field Hockey'       , N'Odd/Even'                      )
	,	(	N'Field Hockey'       , N'Mix Parlay'                    )
	,	(	N'Field Hockey'       , N'System Parlay'                 )
	,	(	N'Field Hockey'       , N'Outright'                      )
								    					             
	,	(	N'Golf'               , N'Moneyline'                     )
	,	(	N'Golf'               , N'Handicap'                      )
	,	(	N'Golf'               , N'Over/Under'                    )
	,	(	N'Golf'               , N'Odd/Even'                      )
	,	(	N'Golf'               , N'Mix Parlay'                    )
	,	(	N'Golf'               , N'System Parlay'                 )
	,	(	N'Golf'               , N'Outright'                      )
								    					             
	,	(	N'Ice Hockey'         , N'Moneyline'                     )
	,	(	N'Ice Hockey'         , N'Handicap'                      )
	,	(	N'Ice Hockey'         , N'Over/Under'                    )
	,	(	N'Ice Hockey'         , N'Odd/Even'                      )
	,	(	N'Ice Hockey'         , N'Mix Parlay'                    )
	,	(	N'Ice Hockey'         , N'System Parlay'                 )
	,	(	N'Ice Hockey'         , N'Outright'                      )
								    					             
	,	(	N'Motorsport'         , N'Moneyline'                     )
	,	(	N'Motorsport'         , N'Handicap'                      )
	,	(	N'Motorsport'         , N'Over/Under'                    )
	,	(	N'Motorsport'         , N'Odd/Even'                      )
	,	(	N'Motorsport'         , N'Mix Parlay'                    )
	,	(	N'Motorsport'         , N'System Parlay'                 )
	,	(	N'Motorsport'         , N'Outright'                      )
								    					             
	,	(	N'Muay Thai'          , N'Moneyline'                     )
	,	(	N'Muay Thai'          , N'Handicap'                      )
	,	(	N'Muay Thai'          , N'Over/Under'                    )
	,	(	N'Muay Thai'          , N'Odd/Even'                      )
	,	(	N'Muay Thai'          , N'Mix Parlay'                    )
	,	(	N'Muay Thai'          , N'System Parlay'                 )
	,	(	N'Muay Thai'          , N'Outright'                      )
								    					             
	,	(	N'Rugby'              , N'Moneyline'                     )
	,	(	N'Rugby'              , N'Handicap'                      )
	,	(	N'Rugby'              , N'Over/Under'                    )
	,	(	N'Rugby'              , N'Odd/Even'                      )
	,	(	N'Rugby'              , N'Mix Parlay'                    )
	,	(	N'Rugby'              , N'System Parlay'                 )
	,	(	N'Rugby'              , N'Outright'                      )
								    					             
	,	(	N'Snooker/Pool'       , N'Moneyline'                     )
	,	(	N'Snooker/Pool'       , N'Handicap'                      )
	,	(	N'Snooker/Pool'       , N'Over/Under'                    )
	,	(	N'Snooker/Pool'       , N'Odd/Even'                      )
	,	(	N'Snooker/Pool'       , N'Mix Parlay'                    )
	,	(	N'Snooker/Pool'       , N'System Parlay'                 )
	,	(	N'Snooker/Pool'       , N'Outright'                      )
								    					             
	,	(	N'Volleyball'         , N'Moneyline'                     )
	,	(	N'Volleyball'         , N'Handicap'                      )
	,	(	N'Volleyball'         , N'Over/Under'                    )
	,	(	N'Volleyball'         , N'Odd/Even'                      )
	,	(	N'Volleyball'         , N'Mix Parlay'                    )
	,	(	N'Volleyball'         , N'System Parlay'                 )
	,	(	N'Volleyball'         , N'Outright'                      )
								    					             
	,	(	N'Athletics'          , N'Moneyline'                     )
	,	(	N'Athletics'          , N'Outright'                      )
								    					             
	,	(	N'Boxing/MMA'         , N'Moneyline'                     )
	,	(	N'Boxing/MMA'         , N'Handicap'                      )
	,	(	N'Boxing/MMA'         , N'Over/Under'                    )
	,	(	N'Boxing/MMA'         , N'Odd/Even'                      )
	,	(	N'Boxing/MMA'         , N'Mix Parlay'                    )
	,	(	N'Boxing/MMA'         , N'System Parlay'                 )
	,	(	N'Boxing/MMA'         , N'Outright'                      )
								    					             
	,	(	N'Cycling'            , N'Moneyline'                     )
	,	(	N'Cycling'            , N'Handicap'                      )
	,	(	N'Cycling'            , N'Over/Under'                    )
	,	(	N'Cycling'            , N'Odd/Even'                      )
	,	(	N'Cycling'            , N'Mix Parlay'                    )
	,	(	N'Cycling'            , N'System Parlay'                 )
	,	(	N'Cycling'            , N'Outright'                      )
								    					             
	,	(	N'Diving'             , N'Moneyline'                     )
	,	(	N'Diving'             , N'Outright'                      )
								    					             
	,	(	N'Entertainment'      , N'Moneyline'                     )
	,	(	N'Entertainment'      , N'Outright'                      )
								    					             
	,	(	N'Handball'           , N'Moneyline'                     )
	,	(	N'Handball'           , N'Handicap'                      )
	,	(	N'Handball'           , N'Over/Under'                    )
	,	(	N'Handball'           , N'Odd/Even'                      )
	,	(	N'Handball'           , N'Mix Parlay'                    )
	,	(	N'Handball'           , N'System Parlay'                 )
	,	(	N'Handball'           , N'Outright'                      )
								    					             
	,	(	N'Netball'            , N'Moneyline'                     )
	,	(	N'Netball'            , N'Handicap'                      )
	,	(	N'Netball'            , N'Over/Under'                    )
	,	(	N'Netball'            , N'Odd/Even'                      )
	,	(	N'Netball'            , N'Mix Parlay'                    )
	,	(	N'Netball'            , N'System Parlay'                 )
	,	(	N'Netball'            , N'Outright'                      )
								    					             
	,	(	N'Squash'             , N'Moneyline'                     )
	,	(	N'Squash'             , N'Handicap'                      )
	,	(	N'Squash'             , N'Over/Under'                    )
	,	(	N'Squash'             , N'Odd/Even'                      )
	,	(	N'Squash'             , N'Mix Parlay'                    )
	,	(	N'Squash'             , N'System Parlay'                 )
	,	(	N'Squash'             , N'Outright'                      )
								    					             
	,	(	N'Swimming'           , N'Moneyline'                     )
	,	(	N'Swimming'           , N'Outright'                      )
								    					             
	,	(	N'Water Polo'         , N'Moneyline'                     )
	,	(	N'Water Polo'         , N'Outright'                      )
								    					             
	,	(	N'Other Sports'       , N'Moneyline'                     )
	,	(	N'Other Sports'       , N'Handicap'                      )
	,	(	N'Other Sports'       , N'Over/Under'                    )
	,	(	N'Other Sports'       , N'Odd/Even'                      )
	,	(	N'Other Sports'       , N'Mix Parlay'                    )
	,	(	N'Other Sports'       , N'System Parlay'                 )
	,	(	N'Other Sports'       , N'Outright'                      )
								  						             
	,	(	N'Virtual Soccer'     , N'Handicap'                      )
	,	(	N'Virtual Soccer'     , N'Over/Under'                    )
	,	(	N'Virtual Soccer'     , N'1X2'                           )
	,	(	N'Virtual Soccer'     , N'Double Chance'                 )
	,	(	N'Virtual Soccer'     , N'Total Goal'                    )
	,	(	N'Virtual Soccer'     , N'Correct Score'                 )
								  						             
	,	(	N'Virtual Racing'     , N'Win'                           )
	,	(	N'Virtual Racing'     , N'Place'                         )
	,	(	N'Virtual Racing'     , N'Win/Place'                     )
								  						             
	,	(	N'Virtual Tennis'     , N'Moneyline'                     )
	,	(	N'Virtual Tennis'     , N'Correct Score'                 )
	,	(	N'Virtual Tennis'     , N'Total Points'                  )		-- new
								  						             
	,	(	N'Virtual Greyhound'  , N'Win'                           )
	,	(	N'Virtual Greyhound'  , N'Place'                         )
	,	(	N'Virtual Greyhound'  , N'Win/Place'                     )
														             
	,	(	N'Virtual Speedway'   , N'Win'                           )
	,	(	N'Virtual Speedway'   , N'Place'                         )
	,	(	N'Virtual Speedway'   , N'Win/Place'                     )
														             
	,	(	N'Virtual Motorsports', N'Win'                           )
	,	(	N'Virtual Motorsports', N'Place'                         )
	,	(	N'Virtual Motorsports', N'Win/Place'                     )
														             
	,	(	N'Horse Racing'       , N'Win'                           )
	,	(	N'Horse Racing'       , N'Place'                         )
	,	(	N'Horse Racing'       , N'Win/Place'                     )
														             
	,	(	N'Greyhound Racing'   , N'Win'                           )
	,	(	N'Greyhound Racing'   , N'Place'                         )
	,	(	N'Greyhound Racing'   , N'Win/Place'                     )
														             
	,	(	N'Harness Racing'     , N'Win'                           )
	,	(	N'Harness Racing'     , N'Place'                         )
	,	(	N'Harness Racing'     , N'Win/Place'                     )
														             
	,	(	N'Keno'               , N'Big/Small'                     )
	,	(	N'Keno'               , N'Odd/Even'                      )
	,	(	N'Keno'               , N'Dragon/Tiger'                  )
	,	(	N'Keno'               , N'Up/Down'                       )
	,	(	N'Keno'               , N'Combo'                         )
	,	(	N'Keno'               , N'Five Elements'                 )
													                 
	,	(	N'Casino'             , N'Card Game'                     )
	,	(	N'Casino'             , N'Table Game'                    )
	,	(	N'Casino'             , N'Slot Games'                    )
	,	(	N'Casino'             , N'Video Poker'                   )
	,	(	N'Casino'             , N'Virtual Games'                 )
	,	(	N'Casino'             , N'Arcade Games'                  )
	,	(	N'Casino'             , N'Scratch Card'                  )
													                 
	,	(	N'Live Casino'        , N'Live Baccarat'                 )
	,	(	N'Live Casino'        , N'Party Baccarat'                )
	,	(	N'Live Casino'        , N'Live Roulette'                 )
	,	(	N'Live Casino'        , N'Party Roulette'                )
													                 
	,	(	N'Number Game'        , N'FT. OE'                        )		-- new
	,	(	N'Number Game'        , N'1st ball OE'                   )
	,	(	N'Number Game'        , N'Last ball OE'                  )
	,	(	N'Number Game'        , N'Next OE'                       )		-- new
	,	(	N'Number Game'        , N'1st ball OU'                   )
	,	(	N'Number Game'        , N'Last ball OU'                  )
	,	(	N'Number Game'        , N'Next OU'                       )		-- new
	,	(	N'Number Game'        , N'Next HL'                       )		-- new
	,	(	N'Number Game'        , N'Next Combo'                    )
	,	(	N'Number Game'        , N'Warrior'                       )
	,	(	N'Number Game'        , N'Number Wheel'                  )
												                     
	,	(	N'Gold Deluxe'        , N'Baccarat'                      )
	,	(	N'Gold Deluxe'        , N'Roulette'                      )

SELECT	@SettingName = 'BetType'
	,	@ParentID = 0
	,	@DisplayOrder = ISNULL(MAX(cs.DisplayOrder) + 1, 1)
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'BetType'
GROUP BY cs.SettingName
	
SELECT	@SettingValue = N'Set X Winner'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP
	
SELECT	@SettingValue = N'Total Points'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP
	
SELECT	@SettingValue = N'FT. OE'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP
	
SELECT	@SettingValue = N'Next OE'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP
	
SELECT	@SettingValue = N'Next OU'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP
	
SELECT	@SettingValue = N'Next HL'
EXECUTE	dbo.Acc_CRM_SettingIns @UserID = @UserID, @SettingName = @SettingName, @SettingValue = @SettingValue, @ParentID = @ParentID, @DisplayOrder = @DisplayOrder, @IP = @IP

UPDATE	bm
SET		bm.SubProductID = sp.SettingID
	,	bm.BetTypeID = bt.SettingID
FROM	#bettypeMap AS bm
LEFT JOIN	dbo.crmSetting AS sp WITH (NOLOCK)
		ON	sp.SettingName = 'Product'
		AND	sp.SettingValue = bm.SubProduct
LEFT JOIN	dbo.crmSetting AS bt WITH (NOLOCK)
		ON	bt.SettingName = 'BetType'
		AND	bt.SettingValue = bm.BetType
		
SELECT *
FROM	#bettypeMap AS bm

INSERT INTO	dbo.crmSettingRelation
	(	SettingID   , ParentID       , DisplayOrder)
SELECT	bm.BetTypeID, bm.SubProductID, 1
FROM	#bettypeMap AS bm
WHERE	NOT EXISTS (SELECT 1 FROM dbo.crmSettingRelation AS csr WHERE csr.SettingID = bm.BetTypeID AND csr.ParentID = bm.SubProductID)

DROP TABLE #bettypeMap
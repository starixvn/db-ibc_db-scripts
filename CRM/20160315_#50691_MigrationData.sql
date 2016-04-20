/*
	Creator:	20160318@Billy
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

INSERT INTO #mapping
		(	Product, SubProduct, ProductID, SubProductID, isActive)
VALUES	(	N'N/A' , N'N/A'    , 0        , 0           , 3       )

-- Activate newly added products
UPDATE	cs
SET		cs.IsActive = 1
FROM		dbo.crmSetting AS cs WITH (ROWLOCK, UPDLOCK)
INNER JOIN	#mapping AS m
		ON	m.SubProductID = cs.SettingID
WHERE	m.isActive = 2

-- Rename Setting Name to correct ones
UPDATE	dbo.crmSetting WITH (ROWLOCK, UPDLOCK)
SET		SettingName = 'SubProduct'
WHERE	SettingName = 'Product'

UPDATE	dbo.crmSetting WITH (ROWLOCK, UPDLOCK)
SET		SettingName = 'Product'
WHERE	SettingName = 'ParentProduct'

-- Update value of [crmFeedback] table
DECLARE	@counter		INT
	,	@step			INT = 20000
	,	@VirtualSport	NVARCHAR(50) 

SELECT	@counter = MAX(cf.FeedbackID)
FROM	dbo.crmFeedback AS cf WITH (NOLOCK)

WHILE	@counter > 0
BEGIN
	UPDATE	cf
	SET		cf.SubProductID = cf.ProductID
		,	cf.ProductID = m.ProductID
	FROM		dbo.crmFeedback AS cf WITH (ROWLOCK, UPDLOCK)
	LEFT JOIN	#mapping AS m
			ON	m.SubProductID = cf.ProductID
	WHERE	cf.FeedbackID BETWEEN @counter - @step + 1 AND @counter

	-- Update SubProduct for Virtual Sports Product
	SELECT	@VirtualSport = N'Virtual Soccer'
	UPDATE	cf
	SET	cf.SubProductID = cs.SettingID
	FROM		dbo.crmFeedback AS cf WITH (ROWLOCK, UPDLOCK)
	INNER JOIN	dbo.crmSetting AS cs WITH (NOLOCK)
			ON	cs.SettingValue = @VirtualSport
			AND	cs.SettingName = 'SubProduct'
	WHERE	cf.SubProductID = 8020
		AND	cf.Description LIKE '%' + @VirtualSport + '%'
		AND	cf.FeedbackID BETWEEN @counter - @step + 1 AND @counter

	SELECT	@VirtualSport = N'Virtual Racing'
	UPDATE	cf
	SET	cf.SubProductID = cs.SettingID
	FROM		dbo.crmFeedback AS cf WITH (ROWLOCK, UPDLOCK)
	INNER JOIN	dbo.crmSetting AS cs WITH (NOLOCK)
			ON	cs.SettingValue = @VirtualSport
			AND	cs.SettingName = 'SubProduct'
	WHERE	cf.SubProductID = 8020
		AND	cf.Description LIKE '%' + @VirtualSport + '%'
		AND	cf.FeedbackID BETWEEN @counter - @step + 1 AND @counter

	SELECT	@VirtualSport = N'Virtual Tennis'
	UPDATE	cf
	SET	cf.SubProductID = cs.SettingID
	FROM		dbo.crmFeedback AS cf WITH (ROWLOCK, UPDLOCK)
	INNER JOIN	dbo.crmSetting AS cs WITH (NOLOCK)
			ON	cs.SettingValue = @VirtualSport
			AND	cs.SettingName = 'SubProduct'
	WHERE	cf.SubProductID = 8020
		AND	cf.Description LIKE '%' + @VirtualSport + '%'
		AND	cf.FeedbackID BETWEEN @counter - @step + 1 AND @counter
	
	SELECT	@VirtualSport = N'Virtual Greyhound'
	UPDATE	cf
	SET	cf.SubProductID = cs.SettingID
	FROM		dbo.crmFeedback AS cf WITH (ROWLOCK, UPDLOCK)
	INNER JOIN	dbo.crmSetting AS cs WITH (NOLOCK)
			ON	cs.SettingValue = @VirtualSport
			AND	cs.SettingName = 'SubProduct'
	WHERE	cf.SubProductID = 8020
		AND	cf.Description LIKE '%' + @VirtualSport + '%'
		AND	cf.FeedbackID BETWEEN @counter - @step + 1 AND @counter
	
	SELECT	@VirtualSport = N'Virtual Speedway'
	UPDATE	cf
	SET	cf.SubProductID = cs.SettingID
	FROM		dbo.crmFeedback AS cf WITH (ROWLOCK, UPDLOCK)
	INNER JOIN	dbo.crmSetting AS cs WITH (NOLOCK)
			ON	cs.SettingValue = @VirtualSport
			AND	cs.SettingName = 'SubProduct'
	WHERE	cf.SubProductID = 8020
		AND	cf.Description LIKE '%' + @VirtualSport + '%'
		AND	cf.FeedbackID BETWEEN @counter - @step + 1 AND @counter
	
	SELECT	@VirtualSport = N'Virtual Motorsports'
	UPDATE	cf
	SET	cf.SubProductID = cs.SettingID
	FROM		dbo.crmFeedback AS cf WITH (ROWLOCK, UPDLOCK)
	INNER JOIN	dbo.crmSetting AS cs WITH (NOLOCK)
			ON	cs.SettingValue = @VirtualSport
			AND	cs.SettingName = 'SubProduct'
	WHERE	cf.SubProductID = 8020
		AND	cf.Description LIKE '%' + @VirtualSport + '%'
		AND	cf.FeedbackID BETWEEN @counter - @step + 1 AND @counter

	SELECT	@counter = @counter - @step

	WAITFOR DELAY '00:00:00.280'
END

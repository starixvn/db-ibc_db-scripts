/*
	Creator:	20160510@Billy
	Task:		Migrate data for N/A. settings
	DB:			DBCRM/bodb_CRM
*/

--	BEGIN STEP 1:
--		DEPLOY THIS SCRIPT ON DBCRM/bodb_CRM
------------------------------------------------------------

DECLARE	@StartDate		DATETIME
	,	@EndDate		DATETIME
	,	@ProductNA		INT
	,	@SubProductNA	INT
	,	@BetTypeNA		INT

SELECT	@StartDate = CAST(CAST(MIN(cf.CreateDate) AS DATE) AS DATETIME)
FROM	dbo.crmFeedback AS cf WITH (NOLOCK)

SELECT	@ProductNA = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'Product'
	AND	cs.SettingValue = N'N/A.'
	
SELECT	@SubProductNA = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'SubProduct'
	AND	cs.SettingValue = N'N/A.'

SELECT	@BetTypeNA = cs.SettingID
FROM	dbo.crmSetting AS cs WITH (NOLOCK)
WHERE	cs.SettingName = 'BetType'
	AND	cs.SettingValue = N'N/A.'

WHILE	@StartDate <= CURRENT_TIMESTAMP
BEGIN
	SELECT	@EndDate = DATEADD(MONTH, 1, @StartDate)
	
    UPDATE	dbo.crmFeedback
	SET		ProductID = CASE ISNULL(ProductID, 0) WHEN 0 THEN @ProductNA ELSE ProductID END
		,	SubProductID = CASE ISNULL(SubProductID, 0) WHEN 0 THEN @SubProductNA ELSE SubProductID END
		,	BetTypeID = CASE ISNULL(BetTypeID, 0) WHEN 0 THEN @BetTypeNA ELSE BetTypeID END
	WHERE	CreateDate >= @StartDate
		AND	CreateDate < @EndDate

	SELECT	@StartDate = @EndDate

	WAITFOR DELAY '00:00:00.028'
END
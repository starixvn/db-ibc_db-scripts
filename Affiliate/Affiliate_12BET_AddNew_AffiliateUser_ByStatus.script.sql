/*	
- 20160421@bobby.nguyen@starixsoft.com: Created
- Task: #56239 - Affiliate 12Bet - Create new affiliate user
*/
USE Affiliate_12BET
GO

BEGIN --variable declaration
DECLARE @affiliateId	INT
	,@affiliateName		VARCHAR(50)
	,@affiliateCode		VARCHAR(50)
	,@affiliateEmail	VARCHAR(50)
	,@affiliateType		TINYINT
	,@affiliateGroup	INT
	,@affiliatePrefix	VARCHAR(30)
	,@currencyId		INT
	,@affiliateStatus	VARCHAR(50)
	,@statusIsClosed	BIT
	,@errMsg			VARCHAR(250)
END

BEGIN --set status optional value to insert
SELECT @affiliateStatus = 'pennding' --pennding|approved|disapproved
	, @statusIsClosed	= 0 --1|0

--reset status
SELECT @affiliateStatus = CASE WHEN @statusIsClosed = 1 THEN 'approved' ELSE @affiliateStatus END
	,@affiliatePrefix	= '12BETAFF'
END

BEGIN TRY --generate affiliate username
	;WITH CTE_AffName AS
	(
		SELECT (CAST(SUBSTRING(username, 9, 10) AS INT) + 1) AS MaxAffID
		FROM dbo.AffInfo WITH(NOLOCK)
		WHERE AffID = (SELECT MAX(AffID) FROM dbo.AffInfo WITH(NOLOCK) WHERE username LIKE @affiliatePrefix + '%')
	)
	SELECT @affiliateCode	=  CAST(MaxAffID AS VARCHAR(10))
		, @affiliateName	= @affiliatePrefix + @affiliateCode
	FROM CTE_AffName
END TRY
BEGIN CATCH
	SELECT @affiliateName	= NULL
	,@errMsg				= ERROR_MESSAGE()
END CATCH

BEGIN --set default value
SELECT @affiliateType	= 2 --Asian Affiliate
	,@currencyId		= 3 --$US
	,@affiliateEmail	= ISNULL(@affiliateEmail, @affiliateName + '@test.com')
	,@affiliateGroup	= 102 --NoCommission

END

BEGIN TRY--insert new affiliate user
	INSERT INTO dbo.AffInfo (
			[UserName]
			,[FirstName]
			,[LastName]
			,[GroupID]
			,[Status]
			,[IsClosed]
			,[Currency]
			,[RegisteredDate]
			,[ApprovedDate]
			,[Email]
			,[Password]
			,[AffType]
		)
	SELECT
		@affiliateName AS UserName
		,'-' AS [FirstName]
		,'-' AS [LastName]
		,@affiliateGroup AS GroupID
		,@affiliateStatus AS [Status]
		,@statusIsClosed AS IsClosed
		,@currencyId AS Currency
		,GETDATE() AS [RegisteredDate]
		,CASE WHEN @affiliateStatus = 'pending' THEN NULL ELSE CAST(CURRENT_TIMESTAMP AS DATE) END  AS ApprovedDate
		,@affiliateEmail AS Email
		,NULL AS [Password]
		,@affiliateType AS [AffType]
	WHERE @affiliateName IS NOT NULL
	SELECT @affiliateId = SCOPE_IDENTITY()
END TRY
BEGIN CATCH
	SELECT @errMsg		= ERROR_MESSAGE()
END CATCH

BEGIN TRY --insert new affilate user detail
	INSERT INTO dbo.AffDetail (
		[AffID]
		,[UserName]
		,[SiteURL]
		,[MoreSiteURLs]
		,[NoSiteDesc]
		,[PreferredLanguage]
		,[Gender]
		,[Address]
		,[Postal]
		,[City]
		,[State]
		,[Country]
		,[Phone]
		,[MobilePhone]
		,[Fax]
		,[Question]
		,[Answer]
		,[PreferredPayment]
		,[Player_IBCCustID]
		,[Player_Username]
		,[MailOption]
	)
	SELECT
		@affiliateId
		,@affiliateName
		,'-' AS SiteURL
		,'-' AS MoreSiteURLs
		,'-' AS NoSiteDesc
		,'en-US' AS PreferredLanguage
		,1 AS Gender
		,'-' AS address
		,'-' AS postal
		,'-' AS city
		,'-' AS state
		,'-' AS country
		,'-' AS phone
		,'-' AS mobilephone
		,'' AS Fax
		,'-' AS Question
		,'-' AS Answer
		,'Player' AS PreferredPayment
		,NULL AS Player_IBCCustId
		,NULL AS Player_Username
		,NULL AS [MailOption]
	WHERE @affiliateId > 0
END TRY
BEGIN CATCH
	DELETE dbo.AffInfo WHERE AffID = @affiliateId
	SELECT @affiliateId	= 0 
		, @errMsg		= ERROR_MESSAGE()
END CATCH

BEGIN --output result
SELECT @affiliateId		AS AffiliateId
	,@affiliateName		AS AffiliateName
	,@affiliateCode		AS RefCode
	,@errMsg			AS ErrMsg
-----------------------------------------
SELECT *
FROM dbo.AffInfo WITH(NOLOCK)
WHERE AffID = @affiliateId

SELECT *
FROM dbo.AffDetail WITH(NOLOCK)
WHERE AffID = @affiliateId
END

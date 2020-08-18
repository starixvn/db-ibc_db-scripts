/*<info serverAlias="DBPLO-bodb_Ploutos"></info>*/
/*
	Create: 20200817@Sol
	DB : DBPLO-bodb_Ploutos
	Task: manual insert new PlayerProfile for 2 custid = 44121774, 39104856 [redmine: #139695]
*/

USE bodb_Ploutos;

GO

SET NOCOUNT ON

DECLARE @Today  DATE = '2020-08-06 00:00:00'
		
CREATE TABLE #Cust  
	( PlayerNo INT
	, PlayerName VARCHAR(50)
	, Brand VARCHAR(50)
	, SourcedLicenseeId INT
	, SourcedSiteName VARCHAR(100)
	, SourcedCurrencyId INT
	, LicenseeID INT
	, IsOwner	BIT
	, IsBetTicket	BIT
	, Username2 VARCHAR(50)
	, PRIMARY KEY (
		Brand,
		PlayerNo
	)
)

CREATE table #__finalPlayerProfile
(
	[CustID] INT
	,[Username] VARCHAR(30)
	,[Password] VARCHAR(30)
	,[EmailAddress] VARCHAR(50)
	,[IPAddress] VARCHAR(15)
	,[BrandCode] VARCHAR(20)
	,[LanguageCode] VARCHAR(5)
	,[CurrencyCode] VARCHAR(5)
	,[PlayerTypeCode] VARCHAR(50)
	,[StatusID] TINYINT
)

-- get cust info
INSERT INTO #Cust (PlayerNo, PlayerName, Brand, SourcedLicenseeId, SourcedSiteName, SourcedCurrencyId, LicenseeID, IsOwner, Username2)
SELECT
	al.custid AS PlayerNo
	,al.username AS PlayerName
	,b.BrandCode AS Brand
	,sc.SourcedLicenseeId
	,sc.SourcedSiteName
	,sc.SourcedCurrencyId
	,sc.LicenseeID
	,0 AS IsOwner
	,al.Username2
FROM bodb02.dbo.Customer al WITH (NOLOCK)
	INNER JOIN [bodb_licensee].[dbo].[LicenseeSourcedSetting] sc WITH (NOLOCK) 
		ON sc.SourcedId = al.recommend
	INNER JOIN Brand b WITH(NOLOCK)
		ON b.LicenseeID = sc.LicenseeId
WHERE al.roleid = 1
	AND sc.IsActive = 1
	AND EffectiveDate <= @Today
	AND EndDate >= @Today
	AND al.custid IN (44121774, 39104856)

-- check data
SELECT * FROM #Cust
 
DECLARE  @CurrencyCode	VARCHAR(5) 
		, @CountryCode VARCHAR(5) 
		, @Number INT

CREATE TABLE #Country (ID INT IDENTITY (1,1) , CountryCode VARCHAR(5 ), Number INT )

INSERT INTO #Country (CountryCode, Number)
SELECT
	M.CountryCode
	,COUNT(T.PlayerNo) AS Number
FROM #Cust T
INNER JOIN bodb02.dbo.Exchange e WITH (NOLOCK)
	ON E.exchangeid = T.SourcedCurrencyId
INNER JOIN bodb_Ploutos.dbo.MarketBrand M WITH (NOLOCK)
	ON M.BrandCode = T.Brand
		AND M.CurrencyCode = E.Code
GROUP BY M.CountryCode

DECLARE @i INT = 1, @Max INT

SELECT @Max = MAX(ID) FROM #Country

-- check data
SELECT * FROM #Country

-- insert data to final temp table
WHILE @i <= @Max
BEGIN

	SELECT
		@CountryCode = CountryCode
	   ,@Number = Number
	FROM #Country
	WHERE ID = @i

	;WITH CTE_Player
	AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY T.PlayerNo ASC) AS RowId
		   ,T.PlayerNo AS CustID
		   ,CASE
				WHEN T.IsOwner = 1 THEN T.PlayerName
				ELSE L.LicenseeName + CONVERT(VARCHAR(5), T.SourcedLicenseeId) + REPLACE(T.PlayerName, T.SourcedSiteName, '')
			END AS [Username]
		   ,Prepare.Password AS [Password]
		   ,CASE
				WHEN T.IsOwner = 1 THEN LOWER(REPLACE(T.PlayerName, L.LicenseeName, '') + '@' + LEFT(Prepare.Domain, CASE
						WHEN CHARINDEX('/', Prepare.Domain) > 0 THEN CHARINDEX('/', Prepare.Domain) - 1
						ELSE LEN(Prepare.Domain)
					END))
				ELSE LOWER(CONVERT(VARCHAR(5), T.SourcedLicenseeId) + REPLACE(T.PlayerName, T.SourcedSiteName, '') + '@' + +LEFT(Prepare.Domain, CASE
						WHEN CHARINDEX('/', Prepare.Domain) > 0 THEN CHARINDEX('/', Prepare.Domain) - 1
						ELSE LEN(Prepare.Domain)
					END))
			END AS [EmailAddress]
		   ,T.Brand AS [BrandCode]
		   ,Prepare.LanguageCode AS [LanguageCode]
		   ,E.Code [CurrencyCode]
		   ,'Real' AS [PlayerTypeCode]
		   ,0 AS StatusID
		FROM #Cust T
			INNER JOIN bodb02.dbo.Exchange e WITH (NOLOCK)
				ON E.exchangeid = T.SourcedCurrencyId
			INNER JOIN bodb_Ploutos.dbo.Brand WITH (NOLOCK)
				ON T.Brand = Brand.BrandCode
			INNER JOIN bodb_Licensee.dbo.Licensees l WITH (NOLOCK)
				ON L.LicenseeID = Brand.LicenseeID
			INNER JOIN bodb_Ploutos.dbo.MarketBrand M WITH (NOLOCK)
				ON M.BrandCode = T.Brand
				AND M.CurrencyCode = E.Code
			CROSS APPLY 
			(
				SELECT
					--Player Password
					dbo.Plo_F_Password_Generate(NEWID(), RAND()) AS [Password]
					--Player LanguageCode
					,dbo.Plo_F_Language_Generate(NEWID()) AS [LanguageCode]
					,REPLACE(SUBSTRING(Brand.BrandUrl, CASE
						WHEN CHARINDEX('//', Brand.BrandUrl) > 0 THEN CHARINDEX('//', Brand.BrandUrl) + 2
						ELSE 0
					END, 100), 'www.', '') AS Domain
			) AS Prepare

			WHERE M.CountryCode = @CountryCode
				AND NOT EXISTS (
									SELECT 1 
									FROM bodb_Ploutos.dbo.PlayerProfile p WITH (NOLOCK) 
									WHERE p.CustID = t.PlayerNo
										AND p.BrandCode = t.Brand
								)
	)
	INSERT INTO #__finalPlayerProfile ([CustID]
	, [Username]
	, [Password]
	, [EmailAddress]
	, [IPAddress]
	, [BrandCode]
	, [LanguageCode]
	, [CurrencyCode]
	, [PlayerTypeCode]
	, [StatusID])
		SELECT
			[CustID]
		   ,[Username]
		   ,[Password]
		   ,[EmailAddress]
		   ,[IPAddress]
		   ,[BrandCode]
		   ,[LanguageCode]
		   ,[CurrencyCode]
		   ,[PlayerTypeCode]
		   ,0 AS StatusID
		FROM CTE_Player c
		INNER JOIN [dbo].[Plo_F_IPAddress_GenerateTable](@CountryCode, @NUMBER) I
			ON I.RowID = c.RowId

	SELECT @i = @i + 1

END

---- check final data
SELECT * FROM #__finalPlayerProfile


---- Insert into PlayerProfile
INSERT INTO PlayerProfile 
(
	[CustID]
	, [Username]
	, [Password]
	, [EmailAddress]
	, [IPAddress]
	, [BrandCode]
	, [LanguageCode]
	, [CurrencyCode]
	, [PlayerTypeCode]
	, [StatusID]
)
SELECT
	[CustID]
	,[Username]
	,[Password]
	,[EmailAddress]
	,[IPAddress]
	,[BrandCode]
	,[LanguageCode]
	,[CurrencyCode]
	,[PlayerTypeCode]
	,[StatusID]
FROM #__finalPlayerProfile

DROP TABLE #Cust
DROP TABLE #Country
DROP TABLE #__finalPlayerProfile

GO
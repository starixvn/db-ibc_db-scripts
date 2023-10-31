/*<info serverAlias="DBTXN-IPDB,DBCust-IPDB,DBBAH-IPDB"></info>*/
/*
	Created: 20231031@Sol
	DB: IPDB
	Task: Update country name to remove some text - [RedmineID: #196100]
*/

GO

USE IPDB;

GO

IF OBJECT_ID('[Country]') IS NOT NULL
BEGIN

	UPDATE [Country]
		SET CountryName = 'TAIWAN'
	WHERE CountryName LIKE '%PROVINCE OF CHINA%'

END

GO

GO

IF OBJECT_ID('[IPTable_Mini]') IS NOT NULL
BEGIN

	UPDATE [IPTable_Mini]
		SET countryLONG = 'Taiwan'
	WHERE countryLONG LIKE '%Province of China%'

END

GO

GO

IF OBJECT_ID('[TEMP_IPTable_Mini]') IS NOT NULL
BEGIN

	UPDATE [TEMP_IPTable_Mini]
		SET countryLONG = 'Taiwan'
	WHERE countryLONG LIKE '%Province of China%'

END

GO

GO

IF OBJECT_ID('[IP_Exception]') IS NOT NULL
BEGIN

	UPDATE [IP_Exception]
		SET Country = 'Taiwan'
	WHERE Country LIKE '%Province of China%'

END

GO

GO

IF OBJECT_ID('[IPTable]') IS NOT NULL
BEGIN

	UPDATE [IPTable]
		SET countryLONG = 'Taiwan'
	WHERE countryLONG LIKE '%Province of China%'

END

GO

GO

IF OBJECT_ID('[TEMP_IP]') IS NOT NULL
BEGIN

	UPDATE [TEMP_IP]
		SET countryLONG = 'Taiwan'
	WHERE countryLONG LIKE '%Province of China%'

END

GO

GO

IF OBJECT_ID('[DeniedCountry]') IS NOT NULL
BEGIN

	UPDATE [DeniedCountry]
		SET countryLONG = 'Taiwan'
	WHERE countryLONG LIKE '%Province of China%'

END

GO

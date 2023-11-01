/*<info serverAlias="FPS-IPDB"></info>*/
/*
	Created: 20231031@Sol
	DB: IPDB
	Task: Update country name to remove some text - [RedmineID: #196100]
*/

GO

USE IPDB;

GO

IF OBJECT_ID('[bk_IP2Location_Old]') IS NOT NULL
BEGIN

	UPDATE [bk_IP2Location_Old]
		SET country_name = 'Taiwan'
	WHERE country_name LIKE '%Province of China%'

END

GO

IF OBJECT_ID('[bk_IPv62Location_Old]') IS NOT NULL
BEGIN

	UPDATE [bk_IPv62Location_Old]
		SET country_name = 'Taiwan'
	WHERE country_name LIKE '%Province of China%'

END

GO

IF OBJECT_ID('[IP2Location]') IS NOT NULL
BEGIN

	UPDATE [IP2Location]
		SET country_name = 'Taiwan'
	WHERE country_name LIKE '%Province of China%'

END

GO

IF OBJECT_ID('[IPv62Location]') IS NOT NULL
BEGIN

	UPDATE [IPv62Location]
		SET country_name = 'Taiwan'
	WHERE country_name LIKE '%Province of China%'

END

GO

IF OBJECT_ID('[_DEL_IPV4Location]') IS NOT NULL
BEGIN

	UPDATE [_DEL_IPV4Location]
		SET country_name = 'Taiwan'
	WHERE country_name LIKE '%Province of China%'

END

GO
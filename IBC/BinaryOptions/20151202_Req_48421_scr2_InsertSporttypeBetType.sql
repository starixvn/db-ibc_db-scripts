/*
	Created: 20151202@Billy
	Task: Insert SportType BetType (Non-UM Time)
	DB: DBPRO/bodb02 & DBTXN/bodb02
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBPRO/bodb02		--
----------------------------------------------------------

USE [bodb02]
GO

INSERT INTO Sports (SportType, SportName)
VALUES (200, 'Binary Options')

INSERT INTO bettype (typeid, ParentTypeid, typenamee)
VALUES	(1401, 1401, 'Binary'),
		(1402, 1402, '60 Seconds'),
		(1403, 1403, 'One Touch')
GO

-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBTXN/bodb02		--
----------------------------------------------------------

USE [bodb02]
GO

INSERT INTO Sport_Bettype_Reference (Bettype, Sporttype, isLicensee, BettypeRef, SporttypeRef, isActive)
VALUES	(1402, 200, 1, 1401, 200, 1),
		(1403, 200, 1, 1401, 200, 1)
GO

-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	--
----------------------------------------------------------
USE [CustDB]
GO

INSERT INTO ProductGlobalSetting (Sporttype, Bettype, MaxPositiontaking, Maxsdiscount, IsDep)
	VALUES	(200, 1401, 1, 0, 1),
			(200, 1402, 1, 0, 1),
			(200, 1403, 1, 0, 1)
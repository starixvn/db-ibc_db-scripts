/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/

/*
	Created: 20231010@Lewis
	DB: DBODDSFEED-bodb_OddsFeed
	Task: Mapping Licensee - Affiliate [RedmineID: #191786]
	Description:

			- STEP 1:	insert --> dbo.system --> list licensee name ref gdoc --> get new systemid,systemName

			- STEP 2:	insert --> dbo.AdminUserSystem
								   dbo.OddsSystemProfile
								   dbo.SystemDomain
								   dbo.SystemIP
						update --> dbo.Partner --> get new systemID for affilate
					   

			- STEP 3:	get data of 
								CeatedDate of the first affiliate
								Creator of the first affiliate
								ContactMail of the first affiliate
						update tbl System --> CeatedDate Creator ContactMail

			- STEP : delete 'licensee' from --> dbo.system
												 dbo.OddsSystemProfile
												 dbo.SystemDomain
												 dbo.SystemIP
*/
USE [bodb_oddsfeed]
GO

DECLARE @SystemID INT = 3
-- =====================================
-- STEP 1: INSERT INTO dbo.System
-- =====================================
DECLARE @NewSysID TABLE(
	NewSystemName NVARCHAR(50),
	NewSystemID SMALLINT
)
	-- insert dbo.system
INSERT INTO dbo.System
	(SystemName,Creator,CreatedDate,LastUpdate,LicenseeID,IsActive,OldSystemID,ContactEmail,MoreContactEmail)
	OUTPUT inserted.SystemName,inserted.SystemID
	INTO @NewSysID
Select '18Luck', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'DELA', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select '3star88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Abcasino', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Others', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'bmwbet', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Callmeboss', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'ECLBET', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'ENTAPLAY', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'erhaozhan', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'asiabet88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'GGBook', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Happy8', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'HC6YAYOU', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'HL8', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'IGPTech', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'ITCbet', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'K8VN', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'KzingJ51', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Mayfair', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Liga', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'N88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'MultiSL88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Nukegaming', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'ONE88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Senibet', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Sin88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'SL88SW', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'SM88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'SSSSEA', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'starsoccer', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Sun988', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Sungame', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Sunriseb2b', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'TGXICV', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'TLC', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Tripleone', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'TSENTER', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'UNOgaming', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'VCBA', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'VKGAME', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'VWIN66', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'W88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'WABET', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Wcasino88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'webet88', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'win365', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'XTD3', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'XTSB', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'Xtu168', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'ZhiFeng032', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL UNION
Select 'zt828', 1, '2010-07-25 4:24:04', GETDATE(), 0, 1, 3, 'martin.jr@oneworks.com',NULL 

-- =================================================================================================
-- STEP 2: INSERT INTO dbo.AdminUserSystem - dbo.OddsSystemProfile - dbo.SystemDomain - dbo.SystemIP
-- =================================================================================================

--dbo.AdminUserSystem
SELECT * 
INTO #AdminUserSystem
FROM dbo.AdminUserSystem WITH (NOLOCK) 
WHERE SystemID = @SystemID

--dbo.OddsSystemProfile
SELECT * 
INTO #OddsSystemProfile
FROM dbo.OddsSystemProfile WITH (NOLOCK) 
WHERE SystemID = @SystemID

--dbo.SystemDomain
SELECT * 
INTO #SystemDomain
FROM dbo.SystemDomain WITH (NOLOCK) 
WHERE SystemID = @SystemID

--dbo.SystemDomain
SELECT * 
INTO #SystemIP
FROM dbo.SystemIP WITH (NOLOCK) 
WHERE SystemID = @SystemID

-- =======================================
DECLARE @New_Sys_ID SMALLINT = (SELECT MIN(NewSystemID) FROM @NewSysID)
DECLARE @MaxSysId_After_Ins SMALLINT = (SELECT MAX(NewSystemID) FROM @NewSysID)

WHILE @New_Sys_ID <= @MaxSysId_After_Ins
BEGIN

	--dbo.AdminUserSystem
	IF EXISTS (SELECT TOP 1 * FROM #AdminUserSystem)
	BEGIN
		UPDATE A SET A.SystemID = @New_Sys_ID
		FROM #AdminUserSystem A WITH (ROWLOCK, UPDLOCK)

		BEGIN TRY
			INSERT INTO dbo.AdminUserSystem (
				SystemID
				,UserID
				,IsActive
				,IsHost
				)
			SELECT 
				SystemID
				,UserID
				,IsActive
				,IsHost
			FROM #AdminUserSystem	
		END TRY
		BEGIN CATCH
			SELECT @New_Sys_ID AS NewSystemID, ERROR_MESSAGE() AS MsgErr_AdminUserSystem
			BREAK
		END CATCH
	END

	--dbo.OddsSystemProfile
	IF EXISTS (SELECT TOP 1 * FROM #OddsSystemProfile)
	BEGIN 
		UPDATE A SET A.SystemID = @New_Sys_ID
		FROM #OddsSystemProfile A WITH (ROWLOCK, UPDLOCK)

		BEGIN TRY
			INSERT INTO dbo.OddsSystemProfile (
				SystemID
			   ,CreatedDate
			   ,Creator
			   ,Editable
			   ,LastUpdate
			   ,OddsType
			   ,LanguageList
			   ,OddsRegion
			   ,SportIDList
			   ,BetTypeIDList
			   ,LeagueIDList
			   ,CountryCodeList
			   ,LeagueKeyword
			   ,LeagueKeyword_O
			   ,DelayTimes
			   ,NumberOfIPs
			   ,OddsTypeFlag
			   ,LanguageListFlag
			   ,OddsRegionFlag
			   ,SportIDListFlag
			   ,BetTypeIDListFlag
			   ,LeagueIDListFlag
			   ,CountryCodeListFlag
			   ,LeagueKeywordFlag
			   ,LeagueKeyword_OFlag
			   ,DelayTimesFlag
			   ,OutrightIDList
			   ,ResultDelayTimes
			   ,ResultDelayTimesFlag
			   )
			SELECT 
				SystemID
			   ,CreatedDate
			   ,Creator
			   ,Editable
			   ,LastUpdate
			   ,OddsType
			   ,LanguageList
			   ,OddsRegion
			   ,SportIDList
			   ,BetTypeIDList
			   ,LeagueIDList
			   ,CountryCodeList
			   ,LeagueKeyword
			   ,LeagueKeyword_O
			   ,DelayTimes
			   ,NumberOfIPs
			   ,OddsTypeFlag
			   ,LanguageListFlag
			   ,OddsRegionFlag
			   ,SportIDListFlag
			   ,BetTypeIDListFlag
			   ,LeagueIDListFlag
			   ,CountryCodeListFlag
			   ,LeagueKeywordFlag
			   ,LeagueKeyword_OFlag
			   ,DelayTimesFlag
			   ,OutrightIDList
			   ,ResultDelayTimes
			   ,ResultDelayTimesFlag
			FROM #OddsSystemProfile	
		END TRY
		BEGIN CATCH
			SELECT @New_Sys_ID AS NewSystemID, ERROR_MESSAGE() AS MsgErr_OddsSystemProfile
			BREAK
		END CATCH
	END

	--dbo.SystemDomain
	IF EXISTS (SELECT TOP 1 * FROM #SystemDomain)
	BEGIN 
		UPDATE A SET A.SystemID = @New_Sys_ID
		FROM #SystemDomain A WITH (ROWLOCK, UPDLOCK)

		BEGIN TRY
			INSERT INTO dbo.SystemDomain (
				SystemID
			   ,DomainID
			   )
			SELECT 
				SystemID
			   ,DomainID
			FROM #SystemDomain	
		END TRY
		BEGIN CATCH
			SELECT @New_Sys_ID AS NewSystemID, ERROR_MESSAGE() AS MsgErr_SystemDomain
			BREAK
		END CATCH
	END

	--dbo.SystemIP
	IF EXISTS (SELECT TOP 1 * FROM #SystemIP)
	BEGIN 
		UPDATE A SET A.SystemID = @New_Sys_ID
		FROM #SystemIP A WITH (ROWLOCK, UPDLOCK)

		BEGIN TRY
			INSERT INTO dbo.SystemIP (
				SystemID
			   ,IPFrom
			   ,IPTo
			   ,Creator
			   ,CreatedDate
			   ,UpdatedBy
			   ,LastUpdate
			   )
			SELECT SystemID
			   ,IPFrom
			   ,IPTo
			   ,Creator
			   ,CreatedDate
			   ,UpdatedBy
			   ,LastUpdate
			FROM #SystemIP	
		END TRY
		BEGIN CATCH
			SELECT @New_Sys_ID AS NewSystemID, ERROR_MESSAGE() AS MsgErr_SystemDomain
			BREAK
		END CATCH
	END

	SET @New_Sys_ID += 1

END
-- =======================================


DROP TABLE #AdminUserSystem
DROP TABLE #OddsSystemProfile
DROP TABLE #SystemDomain
DROP TABLE #SystemIP

-- ==========================
-- STEP 3: UPDATE dbo.Partner
-- ==========================
CREATE TABLE #Partner(
	PartnerID INT,
	PartnerName VARCHAR(50),
	SystemID SMALLINT,
	SystemName NVARCHAR(50)
)
INSERT INTO #Partner (
	PartnerID,
	PartnerName,
	SystemName
)
Select 461,'18Luck','18Luck' UNION ALL
Select 89,'1bet','DELA' UNION ALL
Select 466,'3Star88','3star88' UNION ALL
Select 434,'Abcasino','Abcasino' UNION ALL
Select 113,'AshotMartirosyan','Others' UNION ALL
Select 46,'bcw','Others' UNION ALL
Select 482,'bmwbet','bmwbet' UNION ALL
Select 495,'Callmeboss','Callmeboss' UNION ALL
Select 30,'Dela','DELA' UNION ALL
Select 31,'Dela_live','DELA' UNION ALL
Select 480,'ECLBET','ECLBET' UNION ALL
Select 430,'ENTAPLAY','ENTAPLAY' UNION ALL
Select 446,'erhaozhan','erhaozhan' UNION ALL
Select 36,'fun88','asiabet88' UNION ALL
Select 505,'Fun88_Cricket','asiabet88' UNION ALL
Select 497,'Fun88Cricket','asiabet88' UNION ALL
Select 460,'GGBook','GGBook' UNION ALL
Select 474,'Happy8','Happy8' UNION ALL
Select 472,'HC6','HC6YAYOU' UNION ALL
Select 420,'HL8','HL8' UNION ALL
Select 459,'IGPTech','IGPTech' UNION ALL
Select 92,'infobetting','Others' UNION ALL
Select 442,'ITCbet','ITCbet' UNION ALL
Select 462,'K8VN','K8VN' UNION ALL
Select 443,'Kzing','KzingJ51' UNION ALL
Select 419,'letou','Mayfair' UNION ALL
Select 468,'Liga','Liga' UNION ALL
Select 464,'Livescore','N88' UNION ALL
Select 298,'Mansion','happy8' UNION ALL
Select 410,'Mansion_WorldCup_2018','happy8' UNION ALL
Select 409,'Manson_WorldCup_2018','happy8' UNION ALL
Select 114,'MichaelKosten','Others' UNION ALL
Select 508,'MultiSL88','MultiSL88' UNION ALL
Select 458,'Nova88','N88' UNION ALL
Select 465,'Nukegaming','Nukegaming' UNION ALL
Select 64,'odds.fun88.com','asiabet88' UNION ALL
Select 84,'odds_fun88_com','asiabet88' UNION ALL
Select 479,'ONE88','ONE88' UNION ALL
Select 302,'Senibet','Senibet' UNION ALL
Select 478,'Sin88','Sin88' UNION ALL
Select 484,'SL88SW','SL88SW' UNION ALL
Select 504,'SM88','SM88' UNION ALL
Select 423,'SSSSEA','SSSSEA' UNION ALL
Select 469,'starsoccer','starsoccer' UNION ALL
Select 397,'Sun988','Sun988' UNION ALL
Select 411,'Sun988_WC','Sun988' UNION ALL
Select 383,'Sungame','Sungame' UNION ALL
Select 418,'Sunriseb2b','Sunriseb2b' UNION ALL
Select 486,'TGXICV','TGXICV' UNION ALL
Select 42,'THTNG','Others' UNION ALL
Select 432,'TLC88','TLC' UNION ALL
Select 439,'Tripleone','Tripleone' UNION ALL
Select 467,'TSENTER','TSENTER' UNION ALL
Select 475,'UNOgaming','UNOgaming' UNION ALL
Select 395,'vcba','VCBA' UNION ALL
Select 494,'VKGAME','VKGAME' UNION ALL
Select 445,'Vwin66','VWIN66' UNION ALL
Select 392,'w88','W88' UNION ALL
Select 463,'WABET','WABET' UNION ALL
Select 481,'Wcasino88','Wcasino88' UNION ALL
Select 398,'Webet88','webet88' UNION ALL
Select 507,'win365','win365' UNION ALL
Select 344,'Winabet','DELA' UNION ALL
Select 396,'XTD3','XTD3' UNION ALL
Select 485,'XTSB','XTSB' UNION ALL
Select 447,'Xtu168','Xtu168' UNION ALL
Select 476,'ZhiFeng032','ZhiFeng032' UNION ALL
Select 422,'zt828','zt828'

-- Get NewSystemID for PartnerName

		UPDATE A SET A.SystemID = B.NewSystemID
		FROM #Partner A
		LEFT JOIN @NewSysID B
		ON A.SystemName = B.NewSystemName

-- Get Info ContactMail, Creator, CreatedDate
DECLARE @AfterUpdatePartner TABLE(
	PartnerID INT,
	SystemID SMALLINT,
	UserName VARCHAR(50),
	Site NVARCHAR(200),
	IsAllowed BIT,
	Remark NVARCHAR(255),
	CreatedDate DATETIME,
	LastUpdate DATETIME,
	LastRequest DATETIME,
	Creator INT,
	UpdatedBy INT,
	ContactPerson NVARCHAR(50),
	ContactEmail NVARCHAR(50),
	IsDeleted BIT,
	OldPartnerID SMALLINT
)
-- UPDATE dbo.Partner
	IF EXISTS (SELECT TOP 1 * FROM @NewSysID)
	BEGIN
		BEGIN TRY

			UPDATE C WITH (ROWLOCK,UPDLOCK)
			SET C.SystemID = D.SystemID , C.LastUpdate = GETDATE()
				OUTPUT inserted.* INTO @AfterUpdatePartner
			FROM dbo.Partner C
			INNER JOIN #Partner D
				ON C.UserName = D.PartnerName
				AND C.PartnerID = D.PartnerID
			WHERE C.SystemID = @SystemID
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS MsgErr_Partner
			RETURN
		END CATCH
	END


-- AFTER UPDATE dbo.Partner ==> get data CreatedDate, Creator, ContactMail
CREATE TABLE #Licensee (
		SystemID SMALLINT,
		SystemName NVARCHAR(50),
		IsActive BIT,
		CreatedDate DATETIME,
		Creator INT,
		ContactEmail VARCHAR(100)
)
INSERT INTO #Licensee(
		SystemID
		,SystemName
		,IsActive
		,CreatedDate
		,Creator
		,ContactEmail)
SELECT 
		A.NewSystemID
		,A.NewSystemName
		,C.IsActive
		,C.CreatedDate
		,C.Creator
		,C.ContactEmail
FROM @NewSysID A
	CROSS APPLY(
				SELECT TOP 1
					B.SystemID, B.CreatedDate, B.Creator, B.ContactEmail
					, IsActive = CASE WHEN (SELECT COUNT (*) 
											FROM @AfterUpdatePartner B1 
											WHERE B1.SystemID = A.NewSystemID 
												AND B1.IsAllowed = 1
												AND B1.IsDeleted = 0) > 0 
									 THEN 1 ELSE 0 END
				FROM @AfterUpdatePartner B
				WHERE B.SystemID = A.NewSystemID
				ORDER BY B.CreatedDate ASC
				) C
-- UPDATE dbo.System ==> CreatedDate, Creator, ContactMail	
IF EXISTS (SELECT TOP 1 * FROM #Licensee)
BEGIN
	BEGIN TRY
		UPDATE A WITH (ROWLOCK, UPDLOCK)
		SET A.IsActive = B.IsActive,
			A.CreatedDate = B.CreatedDate, 
			A.Creator = B.Creator, 
			A.ContactEmail = B.ContactEmail
		FROM dbo.System A 
			JOIN #Licensee B
				ON A.SystemID = B.SystemID
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS MsgErr_Update_System
		RETURN
	END CATCH
END

DROP TABLE #Partner
DROP TABLE #Licensee
-- =========================
-- STEP 4: DELETE 'licensee'
-- =========================
DELETE dbo.System WITH (ROWLOCK)
WHERE SystemID = @SystemID

DELETE dbo.AdminUserSystem WITH (ROWLOCK)
WHERE SystemID = @SystemID

DELETE dbo.OddsSystemProfile WITH (ROWLOCK)
WHERE SystemID = @SystemID

DELETE dbo.SystemDomain WITH (ROWLOCK)
WHERE SystemID = @SystemID

DELETE dbo.SystemIP WITH (ROWLOCK)
WHERE SystemID = @SystemID




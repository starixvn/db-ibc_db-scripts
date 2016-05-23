/*
	Creator:	20160523@Billy
	Task:		Migrate duplicated settings - Clean up unused data - [Redmine: #57017]
	DB:			DBCRM/bodb_CRM
*/

--	BEGIN STEP 1: DBCRM/bodb_CRM
--		Migrate mismatch setting data
------------------------------------------------------------

-- Migrate duplicated setting: BetType - Handicap
UPDATE	dbo.crmFeedback WITH (ROWLOCK, UPDLOCK)
SET		BetTypeID = 9000
WHERE	BetTypeID = 9023

-- Migrate duplicated setting: BetType - Moneyline
UPDATE	dbo.crmFeedback WITH (ROWLOCK, UPDLOCK)
SET		BetTypeID = 9005
WHERE	BetTypeID = 9006

-- Migrate duplicated setting: BetType - Over/Under
UPDATE	dbo.crmFeedback WITH (ROWLOCK, UPDLOCK)
SET		BetTypeID = 9001
WHERE	BetTypeID IN (9024, 9058)


--	BEGIN STEP 2:
--		DEPLOY THIS SCRIPT ON DBCRM/bodb_CRM
------------------------------------------------------------


CREATE TABLE	#crmSetting (
					SettingID		INT
				,	SettingName		VARCHAR(50)
				,	SettingValue	NVARCHAR(100)
				,	isActive		TINYINT
				)

INSERT INTO	#crmSetting
		(	SettingID, SettingName                 , SettingValue                                                                                          , IsActive)
VALUES	(	3007     , 'MainCategory'              , 'Hihi'                                                                                                , 2       )
	,	(	3026     , 'MainCategory'              , 'NONE'                                                                                                , 2       )
	,	(	3039     , 'MainCategory'              , 'TEST'                                                                                                , 2       )
	,	(	6039     , 'Site'                      , 'kakatest'                                                                                            , 2       )
	,	(	6040     , 'Site'                      , 'thaole1'                                                                                             , 2       )
	,	(	6041     , 'Site'                      , 'thaole2'                                                                                             , 2       )
	,	(	6042     , 'Site'                      , 'lethao1'                                                                                             , 2       )
	,	(	6043     , 'Site'                      , 'tina1'                                                                                               , 2       )
	,	(	6044     , 'Site'                      , 'tina5'                                                                                               , 2       )
	,	(	6045     , 'Site'                      , 'anna2'                                                                                               , 2       )
	,	(	6046     , 'Site'                      , 'User can not enter more than 100 characters on Setting value text box. Field Setting Value is limit1', 2       )
	,	(	6047     , 'Site'                      , 'anna3'                                                                                               , 2       )
	,	(	6048     , 'Site'                      , 'le1'                                                                                                 , 2       )
	,	(	6049     , 'Site'                      , '111'                                                                                                 , 2       )
	,	(	6050     , 'Site'                      , 'le3'                                                                                                 , 2       )
	,	(	6051     , 'Site'                      , 'aaa'                                                                                                 , 2       )
	,	(	6052     , 'Site'                      , 'thao1'                                                                                               , 2       )
	,	(	6053     , 'Site'                      , 'thao5'                                                                                               , 2       )
	,	(	6054     , 'Site'                      , 'thao5'                                                                                               , 2       )
	,	(	6210     , 'Site'                      , 'Suncity'                                                                                             , 2       )
	,	(	6217     , 'Site'                      , 'User can not enter more than 100 characters on Setting value text box.'                              , 2       )
	,	(	6218     , 'Site'                      , 'testaa1'                                                                                             , 2       )
	,	(	6219     , 'Site'                      , 'test2'                                                                                               , 2       )
	,	(	6220     , 'Site'                      , 'test3'                                                                                               , 2       )
	,	(	6221     , 'Site'                      , 'test11'                                                                                              , 2       )
	,	(	6222     , 'Site'                      , 'test12'                                                                                              , 2       )
	,	(	6223     , 'Site'                      , 'test13'                                                                                              , 2       )
	,	(	6224     , 'Site'                      , 'testanna2'                                                                                           , 2       )
	,	(	6225     , 'Site'                      , 'testanna3'                                                                                           , 2       )
	,	(	6226     , 'Site'                      , 'thaole4'                                                                                             , 2       )
	,	(	6227     , 'Site'                      , 'thaole4'                                                                                             , 2       )
	,	(	6228     , 'Site'                      , 'thaole4'                                                                                             , 2       )
	,	(	6229     , 'Site'                      , 'thaole5'                                                                                             , 2       )
	,	(	6230     , 'Site'                      , 'lethao2'                                                                                             , 2       )
	,	(	6233     , 'Site'                      , 'User can not enter more than 100 characters on Setting value text box.  Field Setting Value is limit', 2       )
	,	(	6234     , 'Site'                      , 'User can not enter more than 100 characters on Setting value text box. Field Setting Value is limit1', 2       )
	,	(	6235     , 'Site'                      , 'anna1'                                                                                               , 2       )
	,	(	6236     , 'Site'                      , 'le2'                                                                                                 , 2       )
	,	(	6237     , 'Site'                      , 'thao1'                                                                                               , 2       )
	,	(	6238     , 'Site'                      , 'thao7'                                                                                               , 2       )
	,	(	6239     , 'Site'                      , 'a1'                                                                                                  , 2       )
	,	(	6240     , 'Site'                      , 'a2'                                                                                                  , 2       )
	,	(	6242     , 'Site'                      , 'annatest1'                                                                                           , 2       )
	,	(	6243     , 'Site'                      , 'annatest12'                                                                                          , 2       )
	,	(	6244     , 'Site'                      , 'annatest11'                                                                                          , 2       )
	,	(	6245     , 'Site'                      , 'anna'                                                                                                , 2       )
	,	(	6251     , 'Site'                      , 'LukasTest'                                                                                           , 2       )
	,	(	6253     , 'Site'                      , 'testaa2'                                                                                             , 2       )
	,	(	6301     , 'Site'                      , 'Testing'                                                                                             , 2       )
	,	(	6302     , 'Site'                      , 'Testing001Credit'                                                                                    , 2       )
	,	(	6303     , 'Site'                      , 'Kiwi_test'                                                                                           , 2       )
	,	(	6304     , 'Site'                      , 'Justin_test'                                                                                         , 2       )
	,	(	6305     , 'Site'                      , 'Justin_Licen_Test'                                                                                   , 2       )
	,	(	6319     , 'Site'                      , 'Test Credit'                                                                                         , 2       )
	,	(	6320     , 'Site'                      , 'Test Licensee 1'                                                                                     , 2       )
	,	(	6326     , 'Site'                      , 'Test Credit Site'                                                                                    , 2       )
	,	(	6330     , 'Site'                      , 'Test site'                                                                                           , 2       )
	,	(	6333     , 'Site'                      , 'TestUAT01'                                                                                           , 2       )
	,	(	6334     , 'Site'                      , 'TESTUAT002'                                                                                          , 2       )
	,	(	6353     , 'Site'                      , 'Starix test Site'                                                                                    , 2       )
	,	(	6354     , 'Site'                      , 'Site Testing Starix32'                                                                               , 2       )
	,	(	9006     , 'BetType'                   , 'MoneyLine'                                                                                           , 2       )
	,	(	9007     , 'BetType'                   , 'Trouble'                                                                                             , 2       )
	,	(	9008     , 'BetType'                   , 'happy'                                                                                               , 2       )
	,	(	9009     , 'BetType'                   , 'hype'                                                                                                , 2       )
	,	(	9023     , 'BetType'                   , 'Handicap'                                                                                            , 2       )
	,	(	9024     , 'BetType'                   , 'Over/Under'                                                                                          , 2       )
	,	(	9058     , 'BetType'                   , 'Over/Under'                                                                                          , 2       )
	,	(	9061     , 'BetType'                   , '8171'                                                                                                , 2       )
	,	(	11005    , 'Status'                    , 'Status'                                                                                              , 2       )
	,	(	11007    , 'Status'                    , 'Test1'                                                                                               , 2       )
	,	(	15000    , 'BT new'                    , 'Outright'                                                                                            , 2       )
	,	(	15001    , 'BT new'                    , 'Mix parlay'                                                                                          , 2       )
	,	(	15002    , 'BT new'                    , 'MoneyLine'                                                                                           , 2       )
	,	(	16000    , 'Group'                     , 'Test'                                                                                                , 2       )
	,	(	17000    , 'Be tType'                  , 'd'                                                                                                   , 2       )
	,	(	18000    , 'Verify'                    , '11007'                                                                                               , 2       )
	,	(	19000    , 'Bahasa Indo'               , '12005'                                                                                               , 2       )
	,	(	19001    , 'Bahasa Indo'               , '9030'                                                                                                , 2       )
	,	(	20000    , 'N/A'                       , '1005'                                                                                                , 2       )
	,	(	21000    , 'Wagers Accept/Reject/Void' , '3006'                                                                                                , 2       )
	,	(	23000    , 'Indo'                      , '12005'                                                                                               , 2       )
	,	(	24000    , 'Non Member-related Enquiry', '9099'                                                                                                , 2       )
	,	(	25000    , 'annatest'                  , 'anna'                                                                                                , 2       )
	,	(	26000    , 'annatest1'                 , 'anna'                                                                                                , 2       )
	,	(	26001    , 'annatest1'                 , 'anna2'                                                                                               , 2       )
	,	(	27000    , 'annatest2'                 , 'anna2'                                                                                               , 2       )
	,	(	28000    , 'anntest3'                  , 'anna3'                                                                                               , 2       )
	,	(	29000    , 'test'                      , 'anna test'                                                                                           , 2       )
	,	(	30000    , '841'                       , '2025'                                                                                                , 2       )
	,	(	31000    , 'Licensee Internal Request' , '3027'                                                                                                , 2       )
	,	(	43000    , 'TestUAT'                   , 'Test01'                                                                                              , 2       )
	,	(	44000    , 'TestSetting'               , 'Setting01'                                                                                           , 2       )

DELETE	csr
FROM		dbo.crmSettingRelation AS csr
INNER JOIN	#crmSetting AS tmp
		ON	tmp.SettingID = csr.SettingID
		OR	tmp.SettingID = csr.ParentID

DELETE	cs
FROM		dbo.crmSetting AS cs
INNER JOIN	#crmSetting AS tmp
		ON	tmp.SettingID = cs.SettingID
		AND	tmp.SettingName = cs.SettingName
		AND	tmp.SettingValue = cs.SettingValue

DROP TABLE #crmSetting
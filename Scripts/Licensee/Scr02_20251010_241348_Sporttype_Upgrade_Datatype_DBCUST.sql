/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20251010@Tacy	
	Task: Upgrade SprottypeID Datatype [RedmineId : 241348]
	DB: DBCUST-CustDB
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE CustDB
GO

--1. Drop PK
ALTER TABLE DangerLevelPolicy DROP CONSTRAINT PK_DangerLevelPolicy
GO 

--2. Upgrade Datatype
ALTER TABLE DangerLevelPolicy ALTER COLUMN sporttype SMALLINT NOT NULL
GO 

--3. Add PK
ALTER TABLE DangerLevelPolicy ADD CONSTRAINT PK_DangerLevelPolicy PRIMARY KEY (SportType, DangerLevel, ActionType, LeagueGroupID)
GO
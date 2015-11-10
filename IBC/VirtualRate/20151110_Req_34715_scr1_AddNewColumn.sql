/*
	Created: 20151021@Billy
	Task: Add new column to ProfileVirtualSetting table (UM Time)
	DB: DBCUST.CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	--
-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBACC/bodb02		--
----------------------------------------------------------

USE [CustDB]
GO
  
-- Add new column to ProfileVirtualSetting table --
ALTER TABLE [dbo].[ProfileVirtualSetting]
ADD isActive BIT NOT NULL DEFAULT 0
GO

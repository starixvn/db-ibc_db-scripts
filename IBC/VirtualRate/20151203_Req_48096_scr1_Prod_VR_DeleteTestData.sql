/*
	Created: 20151126@Billy
	Task: Delete test data on Production environment (Non-UM Time)
	DB: DBCUST.CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Execrep SP for deleting Virtual Rate settings in new table [CustVirtualSetting] --
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
AS
BEGIN
	SET NOCOUNT ON

	DELETE FROM CustVirtualSetting

END
GO

-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

EXECUTE Acc_CustSetting3rd_19
GO
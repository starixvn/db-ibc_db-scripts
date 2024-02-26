/*<info serverAlias="DBACC-bodb_Report" executers="" viewers="" ></info>*/
/*
	Created: 20240226@Evan
	DB: DBACC-bodb_Report	
	Task: Add column Bettype, JpContribution to define value of Promotion and Contribution
	https://nexdev.net/issues/200273

*/
USE bodb_Report	
GO
--  Step 1: Add column
 
ALTER TABLE [dbo].[rptDepWinlost_AGCasino]
ADD Bettype INT, JpContribution MONEY;

-- Step 2: Update Current Bettype = 1800 

WHILE (1=1)
BEGIN
	UPDATE TOP (5000) [dbo].[rptDepWinlost_AGCasino] WITH(ROWLOCK)
	SET Bettype = 1800
	WHERE Bettype IS NULL

	IF @@ROWCOUNT < 5000
		BREAK

	WAITFOR DELAY '00:00:00.280'
END

-- Step 3: Update Current Bettype = 1800 
ALTER TABLE [dbo].[rptDepWinlost_AGCasino]
ALTER COLUMN Bettype INT NOT NULL;

-- Step 3: Revise index, key

-- Delete the primary key constraint.  
ALTER TABLE [dbo].[rptDepWinlost_AGCasino]  
DROP CONSTRAINT CIX_rptDepWinlost_AGCasino;  
-- Create new index
CREATE UNIQUE INDEX PK_rptDepWinlost_AGCasino on [dbo].[rptDepWinlost_AGCasino]([Custid],[Winlostdate],[Sporttype],[Bettype],[IsVIPGame])
CREATE CLUSTERED INDEX CIX_Winlostdate on [dbo].[rptDepWinlost_AGCasino] ([Winlostdate],[Custid])

GO


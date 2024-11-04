/*<info serverAlias="IRS_DBTP-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: IRS_DBTP-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/
USE [bodb02]
GO
-- ====================
-- 1. DROP SP - use TVP
-- ====================

	/*
	-- KL
	DROP PROCEDURE DR_Repl_PutSabaProgramStatus_Dist
	*/

	-- DBTP
	 DROP PROCEDURE Repl_PutSabaProgramStatus_Dist;
	 GO

-- ====================
-- 2. DROP TVP
-- ====================

	-- DBTP
	DROP TYPE dbo.TVP_ReplSabaProgramStatus;
	GO

-- ====================
-- 3. CREATE new TVP
-- ====================

	-- DBTP
	CREATE TYPE [dbo].[TVP_ReplSabaProgramStatus] AS TABLE (
		[SId] [INT] NOT NULL
		,[ProgramId] [SMALLINT] NOT NULL
		,[SiteDBGroupId] [SMALLINT] NOT NULL
		,[StatusId] [TINYINT] NULL
		,[IsNotified] [BIT] NULL
		,[CreatedDate] [DATETIME] NULL
		,[RepUpdateTime] [DATETIME2](7) NOT NULL
		,[isDeleted] [BIT]
		,[_FetchedTime] [DATETIME2](7)
	)
	GO
	GRANT EXECUTE ON TYPE::[dbo].[TVP_ReplSabaProgramStatus] TO [repl_ap] AS [dbo]
	GO

 -- CREATE new SP


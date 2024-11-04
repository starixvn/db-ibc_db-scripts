/*<info serverAlias="IRS_DBTP-bodb02,DBRepl-ReplDB"></info>*/
/*
	Created: 20240911@Lewis
	DB: IRS_DBTP-bodb02,DBRepl-ReplDB
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/

-- ====================
-- 1. DROP SP - use TVP
-- ====================

	/*
	-- KL
	DROP PROCEDURE DR_Repl_PutSabaProgramStatus_Dist
	*/

	-- DBTP + DBRepl
	 DROP PROCEDURE Repl_PutSabaProgramStatus_Dist;
	 GO

-- ====================
-- 2. DROP TVP
-- ====================

	-- DBTP + DBRepl
	DROP TYPE dbo.TVP_ReplSabaProgramStatus;
	GO

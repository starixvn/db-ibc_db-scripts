/*<info serverAlias="DBAGE-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: DBAGE-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/

-- ====================
-- 1. DROP SP - use TVP
-- ====================

	-- DBAGE
	 DROP PROCEDURE Repl_PutSabaProgramStatus;
	 GO

-- ====================
-- 2. DROP TVP
-- ====================

	-- DBAGE
	DROP TYPE dbo.TVP_ReplSabaProgramStatus;
	GO

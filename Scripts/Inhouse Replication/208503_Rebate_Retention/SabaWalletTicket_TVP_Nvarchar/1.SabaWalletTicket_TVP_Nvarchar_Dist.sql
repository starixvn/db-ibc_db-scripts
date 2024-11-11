/*<info serverAlias="IRS_DBTP-bodb02,DBRepl-ReplDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20240917@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02,DBRepl-ReplDB
	
	Revisions:
		- 20240917@Lewis: Created [RedmineID: #208503]

	Example:			
*/

-- ====================
-- 1. DROP SP - use TVP
-- ====================

	/*
	-- KL
	DROP PROCEDURE DR_Repl_PutSabaWalletTicket_Dist
	*/

	-- DBTP , DBRepl
	 DROP PROCEDURE Repl_PutSabaWalletTicket_Dist;
	 GO

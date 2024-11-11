/*<info serverAlias="DBAGE-bodb02,IRS_DBTP-bodb02,DBRepl-ReplDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241104@Lewis	
	Task: In-House
	DB: DBAGE-bodb02,IRS_DBTP-bodb02,DBRepl-ReplDB
	
	Revisions:
		- 20241104@Lewis: Created [RedmineID: #208503]

	Example:			
*/

UPDATE r SET r.active = 0
FROM RepInfo r WITH (ROWLOCK, UPDLOCK)
WHERE name ='SabaProgramStatus'





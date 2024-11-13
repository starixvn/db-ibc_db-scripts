/*<info serverAlias="IRS_DBAGE-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,DBRepl-ReplDB,DBCTG-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20240917@Lewis	
	Task: In-House
	DB: IRS_DBAGE-bodb02,IRS_DBACC-bodb02,IRS_DBTP-bodb02,DBRepl-ReplDB,DBCTG-bodb02
	
	Revisions:
		- 20240917@Lewis: Created [RedmineID: #208503]

	Example:			
*/

UPDATE r WITH (ROWLOCK,UPDLOCK) SET r.active = 1
FROM RepInfo r
WHERE [name]='SabaWalletTicket'
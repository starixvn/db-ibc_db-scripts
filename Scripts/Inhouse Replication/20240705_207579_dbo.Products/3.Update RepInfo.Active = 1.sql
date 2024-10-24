/*<info serverAlias="DBCustRepl-ReplCustDB,DBCUST-CustDB"></info>*/
/*
	Created: 20240705@Lewis
	DB: 
		+ DBCustRepl-ReplCustDB
		+ DBTXN-bodb02 (not yet)
		+ IRS_DBAGE-bodb02 (not yet)
		+ IRS_DBACC-bodb02 (not yet)
		+ IRS_DBBOF-bodb02 (not yet)
		+ IRS_DBTP-bodb02 (not yet)
		+ IRS_DBADM-bodb02 (not yet)
		+ IRS_DBBAH-bodb02 (not yet)
		+ IRS_DBPROUAT-bodb02 (not yet)
		+ DBCUST-CustDB
	Task: InHouse Replication - Insert data into RepInfo and RepInfoGroup tables  (Target + Distributor)
		
*/

UPDATE r WITH (ROWLOCK, UPDLOCK) SET r.Active = 1
FROM dbo.RepInfo r
WHERE r.[name] = 'Products'

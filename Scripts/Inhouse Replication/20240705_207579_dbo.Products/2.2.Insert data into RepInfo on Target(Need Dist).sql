/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20240705@Lewis
	DB: 
		+ DBTXN-bodb02 (not yet)
		+ IRS_DBAGE-bodb02 (not yet)
		+ IRS_DBACC-bodb02 (not yet)
		+ IRS_DBBOF-bodb02 (not yet)
		+ IRS_DBADM-bodb02 (not yet)
		+ IRS_DBBAH-bodb02 (not yet)
		+ IRS_DBPROUAT-bodb02 (not yet)
		+ DBCUST-CustDB
	Task: InHouse Replication - Insert data into RepInfo and RepInfoGroup tables  (Target - NEED DISTRIBUTOR)
		
*/
-- Target (NEED DISTRIBUTOR)

DECLARE @GroupID INT = 0

INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size)
SELECT @GroupID,'Products',0,'RepUpdateTime',0,'ProductID','Repl_GetProducts','Repl_PutProducts',1000,10,60000,0

INSERT INTO RepInfoGroup ([GroupID],[SourceServerName],[SourceDBName])
SELECT @GroupID,'DBRepl','ReplCustDB'



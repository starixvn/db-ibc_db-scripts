/*<info serverAlias="DBCustRepl-ReplCustDB"></info>*/
/*
	Created: 20240705@Lewis
	DB: DBCustRepl-ReplCustDB
	Task: InHouse Replication - Insert data into RepInfo and RepInfoGroup tables  (Distributor)
		
*/
-- Distributor
USE ReplCustDB
DECLARE @GroupID INT = 0

INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size)
SELECT @GroupID,'Products',0,'RepUpdateTime',0,'ProductID','Repl_GetProducts','Repl_PutProducts',1000,10,60000,0

INSERT INTO RepInfoGroup ([GroupID],[SourceServerName],[SourceDBName])
SELECT @GroupID,'DB02','bodb02'


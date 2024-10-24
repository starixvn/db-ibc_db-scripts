/*<info serverAlias="IRS_DBTP-bodb02"></info>*/
/*
	Created: 20240705@Lewis
	DB: IRS_DBTP-bodb02
	Task: InHouse Replication - Insert data into RepInfo and RepInfoGroup tables  (Target - NEED DISTRIBUTOR)
		
*/
-- Target (NO NEED DISTRIBUTOR)
USE bodb02
DECLARE @GroupID INT = 0

INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size)
SELECT @GroupID,'Products',0,'RepUpdateTime',0,'ProductID','Repl_GetProducts','Repl_PutProducts',1000,10,60000,0

INSERT INTO RepInfoGroup ([GroupID],[SourceServerName],[SourceDBName])
SELECT @GroupID,'SITDB02','bodb02'



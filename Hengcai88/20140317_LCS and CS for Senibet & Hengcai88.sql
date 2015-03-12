----------------------------
----  Senibet
----------------------------

-- Sync LCS for Senibet
UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET SyncLiveCasino = 1
Where srecommend in (select custid from dep_custsuper with (nolock)
							where site = 'Senibet')




----------------------------
----  Hengcai88
----------------------------

-- Sync LCS, CS for Hengcai88
UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET SyncLiveCasino = 1, SyncCasino = 1
Where srecommend in (select custid from dep_custsuper with (nolock)
							where site = 'Hengcai88')

-- Update LCS PT for super accounts Hengcai88
Update CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET spositiontaking = 0.93 
Where custid in (select custid 
					from custinfo with (nolock)
					where roleid = 4
						and srecommend in (select custid 
											from dep_custsuper with (nolock)
											where site = 'Hengcai88'))

-- Update LCS PT for master accounts Hengcai88
Update CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET mpositiontaking = 0.93 
Where custid in (select custid 
					from custinfo with (nolock)
					where roleid = 3
						and srecommend in (select custid 
											from dep_custsuper with (nolock)
											where site = 'Hengcai88'))

-- Update LCS PT for agents, members accounts Hengcai88
Update CustSettingGame WITH(UPDLOCK,ROWLOCK)
SET apositiontaking = 0.93 
Where custid in (select custid 
					from custinfo with (nolock)
					where roleid in (1, 2)
						and srecommend in (select custid 
											from dep_custsuper with (nolock)
											where site = 'Hengcai88'))




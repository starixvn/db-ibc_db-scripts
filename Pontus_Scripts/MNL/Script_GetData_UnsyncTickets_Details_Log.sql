/********** This is MNL MNL MNL MNL MNL site ***********/
/*
drop table #temp_old
drop table #temp_new
*/
SELECT t.logID, t.logdate,t.tablename,tmp_old.*
INTO #temp_old
FROM (SELECT logID,logdate, CONVERT(xml, transIDList_old) as transIDList_old, tablename  FROM  dbo.tmp_vnDBA_CaptureDataUnSyncTicket_xtest  WITH (NOLOCK)) as t
	CROSS APPLY (
					SELECT   
							t.c.value('@t','BIGINT') AS TransId,
							t.c.value('@sid','SMALLINT') AS StatusID,
							t.c.value('@s','NVARCHAR(10)') AS Status,
							t.c.value('@c','DATETIME') AS Checktime,
							t.c.value('@cr','INT') AS creator,
							t.c.value('@r','TINYINT') AS ruben,
							t.c.value('@a','MONEY') AS actual_stake,
							t.c.value('@sw','TINYINT') AS statuswinlost,
							t.c.value('@wld','MONEY') AS winlostdate
							
					FROM    T.transIDList_old.nodes('/r') t(c)
					
				) AS tmp_old

SELECT t.logid,t.logdate,t.tablename,tmp_new.*
INTO #temp_new
FROM (SELECT logID,logdate, CONVERT(xml, transIDList_new) as transIDList_new, tablename  from  dbo.tmp_vnDBA_CaptureDataUnSyncTicket_xtest  WITH (NOLOCK)) as t
	CROSS APPLY (
					SELECT   
							t.c.value('@t','BIGINT') AS TransId,
							t.c.value('@sid','SMALLINT') AS StatusID,
							t.c.value('@s','NVARCHAR(10)') AS Status,
							t.c.value('@c','DATETIME') AS Checktime,
							t.c.value('@cr','INT') AS creator,
							t.c.value('@r','TINYINT') AS ruben,
							t.c.value('@a','MONEY') AS actual_stake,
							t.c.value('@sw','TINYINT') AS statuswinlost,
							t.c.value('@wld','MONEY') AS winlostdate
							
					FROM    T.transIDList_new.nodes('/r') t(c)
					
				) AS tmp_new		

--select COUNT(1) from #temp_new
--select COUNT(1) from #temp_old

SELECT t1.logid,t1.logdate,t1.tablename, t1.TransId, t1.Status as old, t2.status as new, t1.logdate, b.bettype, b.matchid, b.winlostdate 
FROM #temp_old T1
	INNER JOIN #temp_new T2 ON T1.logID = t2.logID and t1.TransId = t2.TransId and t1.tablename = t2.tablename
	inner join bettrans b with (nolock) on b.transid = t1.TransId
where t1.tablename = 'bettrans'
order by t1.tablename,t1.TransId, t1.logdate	

SELECT t1.logid,t1.logdate,t1.tablename, t1.TransId, t1.Status as old, t2.status as new, t1.logdate, b.bettype, b.matchid, b.winlostdate 
FROM #temp_old T1
	INNER JOIN #temp_new T2 ON T1.logid = t2.logid and t1.TransId = t2.TransId and t1.tablename = t2.tablename
	inner join bettransm b with (nolock) on b.transid = t1.TransId
where t1.tablename = 'bettransm'
order by t1.tablename,t1.TransId, t1.logdate	

/*
	Created: 20180724@Helen
	Task: DB042 Index Renovation
	DB: DB042/bodb02
	
	Notes:
		avg_total_user_cost	: Average cost of the user queries that could be reduced by the new index. This is the current cost of the query.
		avg_user_impact		: Average impact on the query if this index were created. i.e. The query cost would on average drop by this percentage value.
		user_seeks			: Number of Seek operations that this index could have been used by user queries.
		user_scans			: Number of Scan operations that this index could have been used by user queries.
		Ref: https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-missing-index-group-stats-transact-sql?view=sql-server-2017
*/
USE bodb02
GO
SELECT
	 dm_mid.database_id AS DatabaseID,dm_migs.avg_total_user_cost, dm_migs.avg_user_impact,dm_migs.user_seeks,dm_migs.user_scans,last_user_seek, last_user_scan,
	
	 CONVERT (decimal (28,1), dm_migs.avg_total_user_cost * dm_migs.avg_user_impact * (dm_migs.user_seeks + dm_migs.user_scans)) AS improvement_measure, 
            
	 dm_migs.last_user_seek AS Last_User_Seek,
	
	OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName],
	
	'CREATE NONCLUSTERED INDEX [inx' + '_'
	+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') +
	CASE
	WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN '_'
	ELSE ''
	END
	+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
	+ ']'
	+ ' ON ' + dm_mid.statement
	+ ' (' + ISNULL (dm_mid.equality_columns,'')
	+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN ',' ELSE
	'' END
	+ ISNULL (dm_mid.inequality_columns, '')
	+ ')'
	+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement
		
FROM sys.dm_db_missing_index_groups dm_mig
	JOIN sys.dm_db_missing_index_group_stats dm_migs ON dm_migs.group_handle = dm_mig.index_group_handle
	JOIN sys.dm_db_missing_index_details dm_mid ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID('bodb02')
ORDER BY improvement_measure DESC

/*
	Created: 20181122@Helen
	Task: DB053.bodb_AGE/BODB02 & DB052.bodb_Summary Migration - [Redmine:104770]
	SERVER: DB053/bodb_AGE
*/
USE bodb_AGE

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('bettrans_forecast_agent'),
('bettrans_running_20180126_bk'),
('bettrans_running_del'),
('bettrans_running_toDelete'),
('bettrans_trigger_agent'),
('DownlineTo_LeagueControl'),
('DownlineTo_Match_SMAControl'),
('DownlineTo_MatchControl'),
('DownlineTo_SMAControl'),
('DownlineTo_SportControl'),
('LimitLoss_Setting_20140627_BK'),
('LimitLoss_Setting_UAT'),
('LimitLoss_ActionConfig_20140627_BK'),
('LimitLoss_ActionConfig_UAT'),
('tmp_binary_dst2'),
('tmp_v_tablediff2'),
('_datasync_FieldsInfo'),
('_datasync_AGG')

SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'DROP TABLE ' + ObjectName + '_delete'
	FROM #Tables_MarkDelete
	WHERE ID = @start
	
	PRINT 'In progress:' + @sql
	
	BEGIN TRY
		EXEC (@sql)
		PRINT 'Done: ' + @sql
	END TRY
	BEGIN CATCH
		PRINT 'Failed: OBJECT NOT EXISTS - ' + @sql 
	END CATCH

	SET @start = @start + 1
	
END

DROP TABLE #Tables_MarkDelete

GO
DROP TABLE AgeRWLastSyncVersion
GO


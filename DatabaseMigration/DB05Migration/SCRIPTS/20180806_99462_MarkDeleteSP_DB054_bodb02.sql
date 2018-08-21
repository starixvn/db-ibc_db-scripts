/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DB054/BODB02
*/
USE BODB02

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Acc_SMATurnoverCheckList'),
('Acc_SMATurnoverIns'),
('Acc_SMATurnoverUpd'),
('NAP_SMATurnoverGlobalSettingDel'),
('NAP_SMATurnoverGlobalSettingIns'),
('NAP_SMATurnoverGlobalSettingUpd'),
('NAP_SMATurnoverUpd'),
('Acc_SMATurnoverCheckList'),
('Acc_SMATurnoverIns'),
('Acc_SMATurnoverUpd'),
('NAP_SMATurnover_LeagueControlDel'),
('NAP_SMATurnover_LeagueControlUpd'),
('NAP_SMATurnover_MatchControlDel'),
('NAP_SMATurnover_MatchControlUpd'),
('NAP_SMATurnover_SMAControlByEventDel'),
('NAP_SMATurnover_SMAControlByEventIns'),
('NAP_SMATurnover_SMAControlByEventUpd'),
('NAP_SMATurnover_SMAControlDel'),
('NAP_SMATurnover_SMAControlIns'),
('NAP_SMATurnover_SMAControlUpd'),
('NAP_SMATurnover_SportControlUpd')

SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'sp_rename '''	+  ObjectName + ''',''' + ObjectName + '_delete'''
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


/*
	Created: 20181002@Helen
	Task: DB052.bodb_NAP migration - [Redmine:104770]
	SERVER: DB053/bodb_age
*/
USE bodb_age

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES
('Task_Delete_bettrans_running'),
('Task_STDBY_Sync_AGE'),
('Task_STDBY_Sync_AGE_CustGroup'),
('Task_STDBY_Sync_AGE_CustGroup_xpre'),
('Task_STDBY_Sync_AGE_CustProfilePicture'),
--('Acc_CustGroupSelGroup'),
('Acc_CustGroupSelGroup_test'),
('Age_CustomerSelSuggestUsername_lukas'),
('DBA_NAP_LimitLoss_update'),
('Task_STDBY_Sync_AGE'),
('Task_STDBY_Sync_AGE_CustGroup'),
('Task_STDBY_Sync_AGE_CustProfilePicture'),
('Task_STDBY_Sync_AGE_Del'),
('Task_STDBY_Sync_AGE_Del_CustGroup'),
('Task_STDBY_Sync_AGE_Del_CustProfilePicture'),
('Acc_CustGroupSelExtraPTGroupByCustID'),
('NAP_SMATurnover_LeagueControlDel_delete'),
('NAP_SMATurnover_LeagueControlSel'),
('NAP_SMATurnover_LeagueControlUpd_delete'),
('NAP_SMATurnover_MatchControlDel_delete'),
('NAP_SMATurnover_MatchControlSel'),
('NAP_SMATurnover_MatchControlUpd_delete'),
('NAP_SMATurnover_SMAControlByEventDel_delete'),
('NAP_SMATurnover_SMAControlByEventIns_delete'),
('NAP_SMATurnover_SMAControlByEventDel_delete'),
('NAP_SMATurnover_SMAControlByEventIns_delete'),
('NAP_SMATurnover_SMAControlByEventSel'),
('NAP_SMATurnover_SMAControlByEventUpd_delete'),
('NAP_SMATurnover_MatchControlDel_delete'),
('NAP_SMATurnover_MatchControlSel'),
('NAP_SMATurnover_MatchControlUpd_delete'),
('NAP_SMATurnover_SMAControlByEventDel_delete'),
('NAP_SMATurnover_SMAControlByEventIns_delete'),
('NAP_SMATurnover_SMAControlByEventDel_delete'),
('NAP_SMATurnover_SMAControlByEventIns_delete'),
('NAP_SMATurnover_SMAControlSel'),
('NAP_SMATurnover_LeagueControlDel_delete'),
('NAP_SMATurnover_LeagueControlSel'),
('NAP_SMATurnover_LeagueControlUpd_delete'),
('NAP_SMATurnover_MatchControlDel_delete'),
('NAP_SMATurnover_MatchControlSel'),
('NAP_SMATurnover_MatchControlUpd_delete'),
('NAP_SMATurnover_SMAControlByEventDel_delete'),
('NAP_SMATurnover_SMAControlByEventIns_delete'),
('NAP_SMATurnover_SportControlSel'),
('NAP_SMATurnover_SportControlUpd_delete')

SET @end = (SELECT MAX(ID) FROM #Tables_MarkDelete)
DECLARE @sql NVARCHAR(MAX) = ''

WHILE @start < = @end
BEGIN
	SELECT @sql = 'DROP PROC ' + ObjectName + '_delete'
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


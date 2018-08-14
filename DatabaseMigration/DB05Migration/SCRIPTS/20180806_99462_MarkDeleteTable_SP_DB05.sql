/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DB05/bodb02
*/
USE bodb02

GO
---------STEP 1: Mark delete for Tables -----------------------------------
DECLARE @end INT = 1, @start INT = 1

CREATE TABLE #Tables_MarkDelete (ID INT IDENTITY (1,1),ObjectName VARCHAR (200))

INSERT INTO #Tables_MarkDelete (ObjectName)
VALUES

-- Tables
('AccCustomer_1'),
('Acc_Menu'),
('Acc_MemberPolicy_1'),
('Acc_GroupPolicy_1'),
('Acc_GroupInfo_1'),
('Acc_FunctionInfo'),

--('CustAccount'),
--('CustInfo'),
--('Customer'),
--('Site'),
--('Acc_CustDirect'),

('UserLog'),
('Acc_CustGroup'),
('Acc_CustVirtualRate'),
('Acc_ExchangeRate'),
('Acc_ExchangeRate_History'),
('Acc_ExchangeRate_InvalidTransfer'),
('CalcList_Customer'),

-- SP/function

('Acc_DailyCreatedCustomer_Details'),
('Acc_DailyCreatedCustomer'),
('Acc_CustomerIsDummyAccount'),
('f_DirectAgencyList'),
('Acc_Con_FuncInfoDel_1'),
('WriteLog_UserLog'),
('Acc_Con_FuncInfoUpd_1'),
('Acc_Con_GroupInfoIns_1'),
('Acc_Con_GroupInfoDel_1'),
('Acc_Con_GroupInfoUpd_1'),
('Acc_Con_GroupPolicyUpd_1'),
('Acc_Con_AdminPolicyUpd_1'),
('Acc_BettransDelSpecial_1'),
('Age_CheckBeforeLogin'),
('sp_MSupd_userlog'),
('sp_MSdel_userlog'),
('sp_MSins_userlog'),
('WriteLog_UserLog'),
('GetLoginInfo'),
('Dot_logfile'),
('logfile'),
('Admin_Tools_MatchLog'),
('Admin_Tools_MatchLogX'),
('Acc_VirtualRateMulSelCheck'),
('Acc_VirtualRateMulInsTmpExcel'),
('Acc_VirtualRateMulDelTmpExcel'),
('Acc_ExchangeRateCheckValid_1'),
('Acc_ExchangeRateIns_1'),
('Acc_ExchangeRateUpd_1'),
('Acc_ExchangeRateSel_1'),
('Acc_ExchangeRateCheckValid'),
('Acc_ExchangeRateIns'),
('Acc_ExchangeRateUpd'),
('Acc_ExchangeRateSel')

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


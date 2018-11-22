-- Change database name before run script
USE [bodb_Age]
GO

-- SP List need to check
DECLARE @SPName TABLE (SPName VARCHAR(200))
INSERT INTO @SPName (SPName)
SELECT 'Age_CustomerSelProfilePicture' UNION ALL
SELECT 'Age_CustomerUpdProfilePicture' UNION ALL
SELECT 'Age_Rpt_GetTimeRange' UNION ALL
SELECT 'Age_CustomerSelDateLimit' UNION ALL
SELECT 'Age_CustomerSelProfilePicture' UNION ALL
SELECT 'Age_CustomerUpdProfilePicture' UNION ALL
SELECT 'Age_Rpt_GetTimeRange' UNION ALL
SELECT 'Acc_CustomerDateLimitSel' UNION ALL
SELECT 'Acc_CustomerDateLimitDel' UNION ALL
SELECT 'Acc_CustomerDateLimitIns' UNION ALL
SELECT 'Age_CustomerSelProfilePicture'

SELECT DISTINCT
	--o.name,   
    --o.type_desc AS referencing_desciption,   
    --sed.referencing_class_desc,  
    sed.referenced_server_name,
	sed.referenced_database_name,
	sed.referenced_schema_name,  
    sed.referenced_entity_name,
	--o1.name,
	o1.type_desc
FROM sys.sql_expression_dependencies AS sed  
	INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
	INNER JOIN sys.objects AS o1 ON sed.referenced_id = o1.object_id
	INNER JOIN @SPName AS s ON o.name = s.SPName
WHERE o1.type_desc NOT IN ('USER_TABLE') -- change if need
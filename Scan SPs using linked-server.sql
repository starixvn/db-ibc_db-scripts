/*DB053.bodb02
DB053.bodb_Summary
DB053.bodb_Chatbot
DBSUM.bodb_summary
DBAGE.bodb02
DBAGE.bodb_summary
DBAGE.bodb_chatbot
*/

SELECT DISTINCT t2.name [Object Name] ,
	CASE t2.type
		WHEN'U' THEN 'User Table'
		WHEN'S' THEN 'System Table'
		WHEN 'V' THEN 'View'
		WHEN 'TR' THEN 'Trigger'
		WHEN 'P' THEN 'Stored Procedure'
		WHEN 'C' THEN 'Constraint - Check'
		WHEN 'D' THEN 'Default'
		WHEN 'K' THEN 'Primary Key'
		WHEN 'F' THEN 'Foreign Key'
		WHEN 'L' THEN 'Log'
		WHEN 'R' THEN 'Rule'
		WHEN 'RF' THEN 'Replication Filter stp'
		ELSE 'Other: ''' + t2 .type+ ''''
		END [Object Type],
	t2.crdate [Created Date]
FROM syscomments t1
	INNER JOIN sysobjects t2 ON t1. id = t2 .id
WHERE ((t1.[text]  LIKE '%DBAGE.bodb02.%')
	or (t2.[name] LIKE '%DBAGE.bodb02.%'))
	and t2.name not like '%xpre'
	and t2.name not like '%xtest'
	and t2.name not like '%uat1'
	and t2.name not like '%uat2'
	and t2.name not like '%uat3'
	and t2.name not like '%uat4'
	--and t2.name not like 'Acc_Rpt_Winloss%'
	and t2.name not like 'Lbs_Rpt_Winloss%'
	and t2.name not like 'agw_%'
	and t2.name not like '%UAT5'
	and t2.name not like '%_lukas'
	and t2.name not like '%_test'
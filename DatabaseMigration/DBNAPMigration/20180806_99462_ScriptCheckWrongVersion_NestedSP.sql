/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: 
	dbtrans/bodb02
	dbacc/bodb02
	dbacc/bodb_ACC
	dbage/bodb02
	dbage/bodb_Age
	
*/
SELECT	o.name
FROM		sys.sql_modules AS sm WITH (NOLOCK)
INNER JOIN	sys.objects AS o WITH (NOLOCK)	ON	o.object_id = sm.object_id
WHERE	o.type IN ('P') AND O.name  NOT LIKE '%_UAT4' AND O.name  NOT LIKE '%_xpre' AND O.name NOT LIKE '%_xtest' 
	AND (sm.definition LIKE '%f_GetDeniedSiteByUser_UAT4%'
		OR sm.definition LIKE '%Acc_Con_CheckPermission_UAT4%'
		OR sm.definition LIKE '%Acc_Con_CheckPermission_All_UAT4%'
		)
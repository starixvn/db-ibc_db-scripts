/*<info serverAlias="DBACC-bodb02,DBAGE-bodb02,DBBOF-bodb02,DBSIC-custdb,DBSID-custdb,DBTXN-custdb" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250214@Lewis	
	Task: In-House
	DB: DBACC-bodb02,DBAGE-bodb02,DBBOF-bodb02,DBSIC-custdb,DBSID-custdb,DBTXN-custdb
	
	Revisions:
		- 20250214@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'Acc_GroupExtraPT2Setting')
BEGIN
	UPDATE RepInfo
	SET active = 1
	WHERE [group] = 13
		AND [name] =  'Acc_GroupExtraPT2Setting'
END
ELSE
BEGIN  
	SELECT 'Acc_GroupExtraPT2Setting not exists !!!'
END
GO
/***************************************************************************/


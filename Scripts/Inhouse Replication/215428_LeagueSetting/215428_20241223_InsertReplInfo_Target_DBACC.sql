/*<info serverAlias="DBACC-bodb02,DBBOF-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20241223@Lewis	
	Task: In-House
	DB: DBACC-bodb02,DBBOF-bodb02
	
	Revisions:
		- 20241223@Lewis: Created [RedmineID: #215667]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'LeagueSetting')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 13,'LeagueSetting',0,'stamp',0,'Leagueid','Repl_GetLeagueSetting_Dist','Repl_PutLeagueSetting',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'LeagueSetting exists !!!'
END
GO
/***************************************************************************/




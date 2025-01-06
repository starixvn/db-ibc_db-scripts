/*<info serverAlias="IRS_DBG-bodb02,IRS_DBCTG-custdb,IRS_DBSID-custdb,IRS_DBSIC-custdb,IRS_DBPRO-bodb02" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250106@Lewis	
	Task: In-House
	DB: IRS_DBG-bodb02,IRS_DBCTG-custdb,IRS_DBSID-custdb,IRS_DBSIC-custdb,IRS_DBPRO-bodb02
	
	Revisions:
		- 20250106@Lewis: Created [RedmineID: #215883]

	Example:			
*/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'exchange')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 0,'exchange',0,'repupdatetime',0,'ExchangeId','Repl_Gettblexchange_Dist','Repl_Puttblexchange',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'exchange exists !!!'
END
GO
/***************************************************************************/




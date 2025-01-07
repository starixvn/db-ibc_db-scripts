/*<info serverAlias="IRS_DBTP-bodb02,DBCustRepl-ReplCustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250107@Lewis	
	Task: In-House
	DB: IRS_DBTP-bodb02,DBCustRepl-ReplCustDB
	
	Revisions:
		- 20250107@Lewis: Created [RedmineID: #215883]

	Example:			
*/


/************************************ExchangeDailyOanda***************************************/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'ExchangeDailyOanda')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 13,'ExchangeDailyOanda',0,'repupdatetime',0,'ExchangeDate|ExchangeId','Repl_GetExchangeDailyOanda','Repl_PutExchangeDailyOanda_Dist',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'ExchangeDailyOanda exists !!!'
END
GO

/*********************************ExchangeDaily_Crypto******************************************/
IF NOT EXISTS (SELECT * FROM dbo.RepInfo WITH (NOLOCK) WHERE [name] = 'ExchangeDaily_Crypto')
BEGIN
	INSERT INTO RepInfo ([group],[name],active,version_key,version_type,unique_key,get_sp,put_sp,interval,back_fix,delayed_fix,batch_size) 
	SELECT 13,'ExchangeDaily_Crypto',0,'repupdatetime',0,'ExchangeDate|ExchangeId','Repl_GetExchangeDaily_Crypto','Repl_PutExchangeDaily_Crypto_Dist',1000,10,60000,0
END
ELSE
BEGIN  
	SELECT 'ExchangeDaily_Crypto exists !!!'
END
GO

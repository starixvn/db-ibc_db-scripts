/*<info serverAlias="DBLIC-bodb_licenseeReport"></info>*/
/*
	Created: 20240506@Danny
	Task:  reSum data of Ag Casino [redmine: 204752] 
	DB:  DBLIC-bodb_licenseeReport
*/

use bodb_licenseeReport;

 
EXEC GEN_rptBettingByProduct
	
 	@date				= '2024-04-01',
	@date2				= '2024-04-30',
	@DataSource			= 'SeparatedProduct',
	@SeparatedProductID = 10, 
	@ProductCodes		= 'AGC',
	@IsManual = 1

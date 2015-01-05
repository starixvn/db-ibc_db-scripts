USE bodb_licensee
GO
   /*
	Created: Jim
	Date: 2015-01-05
	Task:  Aoncash - Enable Keno report(#28381)
	DB:DBLIC/bodb_licensee
 */

EXEC DBA_Lrf_OfferProduct3rd
	@LicenseeName   = 'Aoncash',
	@ProductName  	= 'Keno',
	@EffectiveDate	 =''

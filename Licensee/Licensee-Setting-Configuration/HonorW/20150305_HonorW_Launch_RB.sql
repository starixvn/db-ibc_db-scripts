/*
RedmineID:#31617
Licensee 161 - Launch of new product Racing
*/
USE bodb_licensee
GO
 EXEC [dbo].[DBA_Lrf_LaunchProduct]
	@LicenseeName ='HonorW',
	@ProductCode  	 ='RB',
	@EffectiveDate	  ='2015-03-03'

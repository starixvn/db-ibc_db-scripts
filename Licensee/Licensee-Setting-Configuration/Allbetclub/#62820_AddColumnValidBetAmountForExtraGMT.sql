/*  
	Created: 20160907@Harper		
	Task:	 #62820_LA - Implement Allbet - Add new column ValidBetAmount
	DB:	 	 DBLIC.bodb_LicenseeReport			
*/

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ValidBetAmount' AND object_id = OBJECT_ID(N'rpt_ThirdPartyWL_ExtraGMT'))
BEGIN
	ALTER TABLE rpt_ThirdPartyWL_ExtraGMT
	ADD ValidBetAmount MONEY
END
GO
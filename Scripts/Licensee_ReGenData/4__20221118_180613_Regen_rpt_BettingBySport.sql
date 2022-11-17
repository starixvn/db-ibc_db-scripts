 /*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Create : 20221021@Danny 
	Regen data for rpt_BettingBySport tale - [Redmine: #180613] 
	DB: DBLIC.bodb_LicenseeReport
*/

USE bodb_LicenseeReport

BEGIN
	DELETE FROM dbo.rpt_BettingBySport
	WHERE rptDate IN ('2022-11-08','2022-11-09')

	INSERT INTO dbo.rpt_BettingBySport(
		rptDate 
		, SiteID 
		, ProductID
		, SportType 
		, CurrencyId
		, StatusId	
		, LicenseeWL
		, AdjustedLicenseeWL
		, CustomerWL
		, AdjustedCustomerWL
		, Turnover
		, BetCount
		, WLShare
		, CommissionS
		, AdjustedCommissionS
		, CommShare
		, AdjustedCommShare
		, CustomerCategory
		, IsParlay
	)
	SELECT rptDate 
		, SiteID 
		, ProductID
		, SportType 
		, CurrencyId
		, StatusId	
		, LicenseeWL
		, AdjustedLicenseeWL
		, CustomerWL
		, AdjustedCustomerWL
		, Turnover
		, BetCount
		, WLShare
		, CommissionS
		, AdjustedCommissionS
		, CommShare
		, AdjustedCommShare
		, CustomerCategory
		, IsParlay
	FROM DBARC.bodb_Archive.dbo.rpt_BettingBySport_regen WITH(NOLOCK)

END
GO

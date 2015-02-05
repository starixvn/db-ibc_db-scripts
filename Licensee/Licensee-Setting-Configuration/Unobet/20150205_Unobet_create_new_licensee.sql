USE bodb_licensee
GO
EXEC [DBA_Lrf_CreateNewLicensee]
	@LicenseeName   		='Unobet'
	,@SuperWildCard  	 	= 'UnobetSuper'
	,@ResellerName   	  	= 'Boping' 
	,@IsSpecial      	 	= 0
	,@ProductCode	  	 	= 'SB,NG,VS,LC,CS,KN,AGC'
	,@SystemisActive 	  	= ''
	,@IsAllowedDW 		   	= 0
	,@IsOfferLas		    = 0
	,@IsAllowMemberComm     = 0
	,@IsAllowWLbyLeague	    = 0
	,@IsDeposit				= 0 
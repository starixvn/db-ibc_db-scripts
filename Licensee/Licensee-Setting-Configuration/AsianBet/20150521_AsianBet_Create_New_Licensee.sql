USE bodb_licensee
GO
EXEC [DBA_Lrf_CreateNewLicensee]
	@LicenseeName   		='AsianBet '
	,@SuperWildCard  	 	= 'AsianBetSuper%'
	,@ResellerName   	  	= 'Boping' 
	,@IsSpecial      	 	= 0
	,@ProductCode	  	 	= 'SB,NG,LC,CS,VS,AG,GD,BA,'
	,@SystemisActive 	  	= ''
	,@IsAllowedDW 		   	= 0
	,@IsOfferLas		    = 0
	,@IsAllowMemberComm     = 0
	,@IsAllowWLbyLeague	    = 0
	,@IsDeposit				= 0 
	
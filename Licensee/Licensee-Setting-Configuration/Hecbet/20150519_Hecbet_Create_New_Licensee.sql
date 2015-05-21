USE bodb_licensee
GO
EXEC [DBA_Lrf_CreateNewLicensee]
	@LicenseeName   		='Hecbet '
	,@SuperWildCard  	 	= 'HecbetSuper%'
	,@ResellerName   	  	= 'Boping' 
	,@IsSpecial      	 	= 0
	,@ProductCode	  	 	= 'SB,BA'
	,@SystemisActive 	  	= ''
	,@IsAllowedDW 		   	= 0
	,@IsOfferLas		    = 0
	,@IsAllowMemberComm     = 0
	,@IsAllowWLbyLeague	    = 0
	,@IsDeposit				= 0 
	
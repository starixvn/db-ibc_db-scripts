USE bodb_licensee
GO
EXEC [DBA_Lrf_CreateNewLicensee]
	@LicenseeName   		='DBP'
	,@SuperWildCard  	 	= 'DBPSuper%'
	,@ResellerName   	  	= 'DBP' 
	,@IsSpecial      	 	= 0
	,@ProductCode	  	 	= 'SB,VS'
	,@SystemisActive 	  	= ''
	,@IsAllowedDW 		   	= 0
	,@IsOfferLas		    = 0
	,@IsAllowMemberComm     = 0
	,@IsAllowWLbyLeague	    = 0
	,@IsDeposit				= 0 
	
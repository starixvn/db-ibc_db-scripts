--- 21Cash :https://redmine.nexcel.vn/issues/34614

USE bodb_licensee
GO
EXEC [DBA_Lrf_CreateNewLicensee]
	@LicenseeName   		='21Cash'
	,@SuperWildCard  	 	= '21CashSuper'
	,@ResellerName   	  	= '21Cash' 
	,@IsSpecial      	 	= 0
	,@ProductCode	  	 	= 'SB,BA,LC'
	,@SystemisActive 	  	= ''
	,@IsAllowedDW 		   	= 0
	,@IsOfferLas		    = 0
	,@IsAllowMemberComm     = 0
	,@IsAllowWLbyLeague	    = 0
	,@IsDeposit				= 0 
	
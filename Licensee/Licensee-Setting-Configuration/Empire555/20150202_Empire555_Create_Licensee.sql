USE bodb_licensee
GO
EXEC [DBA_Lrf_CreateNewLicensee]
	@LicenseeName   	='Empire555'
	,@SuperWildCard  	 = 'Empire555Super'
	,@ResellerName   	  = 'Boping' 
	,@IsSpecial      	 = 0
	,@ProductCode	  	 = 'SB,NG,VS,LC,CS'
	,@SystemisActive 	  = ''
	,@IsAllowedDW 		   = 0
	,@IsOfferLas		    = 0
	,@IsAllowMemberComm     = 0
	,@IsAllowWLbyLeague	    = 0
	,@IsDeposit				 = 0 
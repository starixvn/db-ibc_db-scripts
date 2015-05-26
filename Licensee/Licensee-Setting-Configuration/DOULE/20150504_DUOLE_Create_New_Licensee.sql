--- DUOLE : https://redmine.nexcel.vn/issues/34918

USE bodb_licensee
GO
EXEC [DBA_Lrf_CreateNewLicensee]
	@LicenseeName   		='DUOLE'
	,@SuperWildCard  	 	= 'DUOLESuper'
	,@ResellerName   	  	= 'DUOLE' 
	,@IsSpecial      	 	= 0
	,@ProductCode	  	 	= 'SB,NG,LC,CS,VS,RB,GD,BA'
	,@SystemisActive 	  	= ''
	,@IsAllowedDW 		   	= 0
	,@IsOfferLas		    = 0
	,@IsAllowMemberComm     = 0
	,@IsAllowWLbyLeague	    = 0
	,@IsDeposit				= 0 
	
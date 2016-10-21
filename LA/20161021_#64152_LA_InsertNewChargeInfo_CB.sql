USE bodb_licensee
GO

/*
	Created:	Harper@20161021
	Task:		#64152: Insert new Charge info for CollosusBet
	DB:			DBLIC.bodb_licensee

	Revisions:

	Param's Explanation:
*/

INSERT INTO dbo.OAS_ChargeInfo
        ( ProductID ,
          FromParty ,
          ToParty ,
          ParentChargeID ,
          Rate ,
          ChargeType ,
          FromDate ,
          ToDate ,
          MinAmount ,
          MaxAmount ,
          Remark ,
          BaseCurrencyId ,
          FirstOfBilling ,
          BasisOfBilling
        )
VALUES  ( 15 , 14 , 1 , 0 , 0.1215 , 6 , '20160101' , '20161231' , NULL , NULL , N'Input for testing Oct 2016' , 12 , '20160101' , N''),
		( 15 , 14 , 1 , 0 , 0.45 , 7 , '20160101' , '20161231' , NULL , NULL , N'Input for testing Oct 2016' , 12 , '20160101' , N'')
		
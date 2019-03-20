use bodb_ACC
/*

DB: DBACC.bodb_ACC
Create: 20190320@Sophia
Task: CN88 - UAT - initial script for ExtraPT 
*/




---- 1. Real dummy for reset winning ExtraPT

		  INSERT INTO [Acc_DWLList_ExtraPT] (CustId,GroupId,GroupName)
		  VALUES (35476102, 27, 'CN88') 

---- 2. Test dummy for reset winning ExtraPT

		  INSERT INTO [Acc_DWLList_ExtraPT_xtest]  (CustId,GroupId,GroupName)
		  VALUES (35475842, 27, 'CN88') 

		  

		   
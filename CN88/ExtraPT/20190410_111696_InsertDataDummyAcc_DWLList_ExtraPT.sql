use bodb_ACC
/*

DB: DBACC.bodb_ACC
Create: 20190410@Sophia
Task: CN88 - UAT - initial more ExtraPT group [redmine: #111696]
*/




---- 1. Real dummy for reset winning ExtraPT

		  UPDATE [Acc_DWLList_ExtraPT] 
		  SET GroupName = 'CN88_33'
		  WHERE GroupId = 27
		  
		  INSERT INTO [Acc_DWLList_ExtraPT] (CustId,GroupId,GroupName)
		  VALUES (35854107, 28, 'CN88_22')
		  
		  INSERT INTO [Acc_DWLList_ExtraPT] (CustId,GroupId,GroupName)
		  VALUES (35854106, 29, 'CN88_11')
		  
		  INSERT INTO [Acc_DWLList_ExtraPT] (CustId,GroupId,GroupName)
		  VALUES (35854105, 30, 'CN88_00')
		  

---- 2. Test dummy for reset winning ExtraPT

		  UPDATE [Acc_DWLList_ExtraPT_xtest] 
		  SET GroupName = 'CN88_33'
		  WHERE GroupId = 27

		  INSERT INTO [Acc_DWLList_ExtraPT_xtest] (CustId,GroupId,GroupName)
		  VALUES (35854117, 28, 'CN88_22')
		  
		  INSERT INTO [Acc_DWLList_ExtraPT_xtest] (CustId,GroupId,GroupName)
		  VALUES (35854116, 29, 'CN88_11')
		  
		  INSERT INTO [Acc_DWLList_ExtraPT_xtest] (CustId,GroupId,GroupName)
		  VALUES (35854115, 30, 'CN88_00') 
use CustDB
/*

DB: DBCUST.CustDB
Create: 20190411@Sophia
Task: Update GroupName CN88_33[redmine: #111696]
*/




---- 1. change name CN88 to CN88_33

		  UPDATE [Acc_GroupExtraPTSetting] 
		  SET GroupName = 'CN88_33'
		  WHERE GroupId = 27
		  
		  UPDATE [Acc_GroupExtraPT_Product] 
		  SET GroupName = 'CN88_33'
		  WHERE GroupId = 27
		  
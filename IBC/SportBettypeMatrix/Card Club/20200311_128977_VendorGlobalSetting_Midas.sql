USE CUSTDB
GO 

/*
Created: 20200311@Sophia
Task: update VendorGlobalSetting for Midas - CardClub [Redmine: #128977]
DB: DBCUST.CUSTDB
*/


 UPDATE	VendorGlobalSetting 
SET		
Sporttype = 165,
bettype = 1901
WHERE	VendorId = 33
AND		VName = '3rdCashWLShareRate'


UPDATE	VendorGlobalSetting 
SET		
Sporttype = 165,
bettype = 1901
WHERE	VendorId = 33
AND		VName = '3rdCreditWLShareRate' 
  
INSERT INTO VendorGlobalSetting (VendorId,VName,NumberValue,sporttype,bettype)
VALUES (33,'3rdCashWLShareRateTX', 0.035, 165, 1902),
(33,'3rdCreditWLShareRateTX', 0.035, 165, 1902) 


select * from VendorGlobalSetting

/*

CREATED: 20190906@Sophia
DB: DBCUST.CUSTDB
Task: Adjust effective date of new Headline's PT [redmine: 119795 ]  
*/


 SELECT * FROM Acc_GroupExtraPTSetting 
 WHERE superID =  37479076 
 AND groupID = 30
 AND ToDate = '2019-09-05' 


UPDATE Acc_GroupExtraPTSetting 
SET  ToDate = '2019-09-04'
WHERE superID =  37479076 
 AND groupID = 30
 AND ToDate = '2019-09-05'



SELECT * FROM Acc_GroupExtraPTSetting 
WHERE superID =  37479076 
 AND groupID = 27
  AND FromDate = '2019-09-06'  
  

UPDATE Acc_GroupExtraPTSetting 
SET  FromDate = '2019-09-05'
WHERE superID =  37479076 
 AND groupID = 27
 AND FromDate = '2019-09-06' 
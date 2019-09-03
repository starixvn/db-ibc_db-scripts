
/*

CREATED: 20190903@Sophia
DB: DBCUST.CUSTDB
Task: Adjust effective date of new Headline's PT [redmine: 119579 ]  
*/
SELECT * 
FROM Acc_GroupExtraPTSetting 
WHERE superID =  37477969  
AND ToDate = '2019-09-01'
AND GroupId = 30
 

UPDATE Acc_GroupExtraPTSetting 
SET ToDate = '2019-08-27'
WHERE superID =  37477969  
AND ToDate = '2019-09-01'
AND GroupId = 30
 
 

SELECT * 
FROM Acc_GroupExtraPTSetting 
WHERE superID =  37477969  
AND FromDate = '2019-09-02'
AND GroupId = 27
 

UPDATE Acc_GroupExtraPTSetting 
SET FromDate = '2019-08-28'
WHERE superID =  37477969  
AND FromDate = '2019-09-02'
AND GroupId = 27
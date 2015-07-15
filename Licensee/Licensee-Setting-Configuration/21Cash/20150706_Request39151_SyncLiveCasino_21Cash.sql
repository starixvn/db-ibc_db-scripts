/*
--Author: Susan
- Redmine:https://redmine.nexcel.vn/issues/39151
- Remark : Sync LiveCS for Licensee: 21Cash

*/
  

-- Sync LCS FOR whole lines :30 rows
UPDATE custinfo WITH (UPDLOCK, ROWLOCK)
SET SyncLiveCasino = 1
 WHERE srecommend IN (17719629,  ---21CashSuperIN
					  17719645   ---21CashSuperUUS
                     )
AND mrecommend NOT IN (SELECT custid FROM custInfo WITH(NOLOCK) WHERE username like '%Acc%')

 
-- Update LCS PT for super accounts --2 row
UPDATE CustSettingGame WITH (UPDLOCK, ROWLOCK)
SET spositiontaking = 0.93
FROM CustSettingGame newCS 
INNER JOIN custInfo c WITH(NOLOCK) ON newCS.custid = c.custid 
WHERE  roleid = 4
AND c.custid IN    (17719629,  ---21CashSuperIN 
					17719645  ---21CashSuperUUS
                   )
AND Sporttype = 162  --Live CS 

 
-- Update LCS PT for master accounts  2 rows
UPDATE newCS WITH (UPDLOCK, ROWLOCK)
SET mpositiontaking = 0.93
FROM CustSettingGame newCS 
INNER JOIN custInfo c WITH(NOLOCK) ON newCS.custid = c.custid 
 WHERE  roleid =3
AND srecommend IN (17719629,  ---21CashSuperIN
				   17719645  ---21CashSuperUUS
                  )
AND Sporttype = 162  --Live CS 
AND mrecommend not in (SELECT custid FROM custInfo WITH(NOLOCK)  WHERE roleid=3 and username like '%Acc%')

 

-- Update LCS PT for agents, members accounts 26 rows
UPDATE newCS  WITH (UPDLOCK, ROWLOCK)
SET apositiontaking = 0.93
FROM CustSettingGame newCS 
INNER JOIN custInfo c WITH(NOLOCK) ON newCS.custid = c.custid 
 WHERE  roleid IN (1, 2)
AND srecommend IN (17719629,  ---21CashSuperIN
				   17719645  ---21CashSuperUUS
                  )
AND Sporttype = 162  --Live CS 
AND mrecommend not in (SELECT custid FROM custInfo WITH(NOLOCK)  WHERE roleid=3 and username like '%Acc%')
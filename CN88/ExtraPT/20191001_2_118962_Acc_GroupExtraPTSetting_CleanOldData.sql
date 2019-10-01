
/*
Create: 20191001@Sophia
Task: Clean data ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss', 'MG-SuperLive') [redmine: #118962]
DB: DBUCST.CUSTDB
*/


---Clean data ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss', 'MG-SuperLive')

Select count (*)  from Acc_GroupExtraPTSetting  Where SubProduct IN ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss', 'MG-SuperLive')

Select count (*)  from Acc_GroupExtraPT_Product  Where SubProduct IN ('BT-Comm', 'BT-Bought','BT-Sold', 'BT-Winloss', 'MG-SuperLive')

 
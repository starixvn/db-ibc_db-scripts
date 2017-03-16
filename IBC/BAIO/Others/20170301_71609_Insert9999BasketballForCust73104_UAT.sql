/*
	Created: 20170315@Helen
	Task: BAIO - Setting - add setting bettype 9999 for 73104
	DB: DBCUST/CUSTDB
*/
USE CustDB

GO

INSERT INTO CustSetting(custid, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking)
SELECT custid, 9999 AS bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
FROM CustSetting WITH (NOLOCK)
WHERE custid = 73104 and sporttype = 2 AND bettype = 1
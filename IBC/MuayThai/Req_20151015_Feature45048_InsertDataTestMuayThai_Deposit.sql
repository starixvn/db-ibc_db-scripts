/*
	Created: Elodie
	Date: 20151015
	Task: Import data test of Muay Thai for Spondemo and Athena
*/
INSERT INTO Dep_CustSetting (custid, bettype, sporttype, islive, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, minbet, maxbet)
SELECT cs.custid, bettype, 44, islive, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, minbet, maxbet
FROM Dep_CustSetting cs WITH (NOLOCK)
	INNER JOIN CustInfo c WITH(NOLOCK) ON c.custid = cs.custid
WHERE sporttype = 99 AND bettype = 3 AND c.srecommend IN (3233912, 10063437)

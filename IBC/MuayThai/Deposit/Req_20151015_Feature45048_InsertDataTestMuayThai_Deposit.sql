/*
	Created: Elodie
	Date: 20151015
	Task: Import data test of Muay Thai for deposit UUS
*/
DECLARE @Super12Bet INT, @SuperAlog INT, @SuperSpon INT, @SuperAthena INT

SELECT @Super12Bet = custid FROM CustInfo WITH (NOLOCK) WHERE username = '12BETSuperUUS'
SELECT @SuperAlog = custid FROM CustInfo WITH (NOLOCK) WHERE username = 'ALogSuperUUS'
SELECT @SuperSpon = custid FROM CustInfo WITH (NOLOCK) WHERE username = 'SPONSuperUUS'
SELECT @SuperAthena = custid FROM CustInfo WITH (NOLOCK) WHERE username = 'Athena000SuperUUS'

INSERT INTO Dep_CustSetting (custid, bettype, sporttype, islive, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, minbet, maxbet)
SELECT cs.custid, bettype, 44, islive, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, minbet, maxbet
FROM Dep_CustSetting cs WITH (NOLOCK)
	INNER JOIN CustInfo c WITH(NOLOCK) ON c.custid = cs.custid
WHERE sporttype = 99 AND bettype = 3 AND c.srecommend IN (@Super12Bet, @SuperAlog, @SuperSpon, @SuperAthena)

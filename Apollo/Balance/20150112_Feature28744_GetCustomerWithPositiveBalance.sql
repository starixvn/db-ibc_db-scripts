
--Get a list of members that have balance > 0
	SELECT	B.custid, B.Username, b.CurrencyName, SUM(b.Winlost - B.actual_stake + B.PlayerComm) as Balance 
		FROM	Bettrans B 		
		GROUP BY  B.custid, B.Username,  B.CurrencyName
		HAVING SUM(b.Winlost - B.actual_stake + B.PlayerComm) > 0
		order BY  B.Username,  B.CurrencyName

/*
--check balance 1 customer 
select b.Balance-c.Balance 
from BalanceCredit c join BalanceDebit b on b.custid=c.custid
where b.custid= 558
*/

		
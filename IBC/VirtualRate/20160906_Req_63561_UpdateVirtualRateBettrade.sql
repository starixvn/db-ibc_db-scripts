 /*
	Created: 20160907@Winnie
	Task: Modify Virtual Rate data following new requirements - [Redmine: #61713]
	DB: DBCUST/CustDB
*/

 UPDATE custInfo WITH (ROWLOCK,UPDLOCK) 
 SET VirtualMultiplier=0
 WHERE custid IN
 (SELECT  b.Custid  FROM
	BetTradeCust b WITH(NOLOCK) 
 )
 




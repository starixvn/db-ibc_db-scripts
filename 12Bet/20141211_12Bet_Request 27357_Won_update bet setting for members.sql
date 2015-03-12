/*
	Created: Susan
	Date: 2014-12-03
	Site: 12Bet
	Currency: Won
	Task: 
		- Adjust bet setting for all members under currency Won
	DB: DBTXN/CustDB
*/ 
---1269 rows effected

UPDATE custGameType WITH(UPDLOCK,ROWLOCK)
set MinBet=1000, MaxBet=1500000 , 
MaxPerGameType= 1500000 	
where custid in (select custid from custInfo with(nolock)
					where recommend=6006340 --12BETWON01
					 and roleid=1)


					  
				

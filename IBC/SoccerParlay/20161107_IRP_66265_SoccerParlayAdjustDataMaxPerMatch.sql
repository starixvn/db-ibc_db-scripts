
/*
	Created by: Winnie
	Date: 2016-11-07
	Task:  Adjust data MaxPerMatch for Parlay Soccer credit customer[Redmine:#66265]
	DB: DBCUST/CustDB
*/ 

UPDATE custInfo WITH(UPDLOCK,ROWLOCK)
	SET MaxPerMatch1MP=Maxpermatch
WHERE  ISNULL(MaxPerMatch1MP,0) <> Maxpermatch		

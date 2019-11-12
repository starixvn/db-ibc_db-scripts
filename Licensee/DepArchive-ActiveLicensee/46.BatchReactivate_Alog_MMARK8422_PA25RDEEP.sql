/*
	Task: Reactivate 2 dormant members who have Bet tickets of Exchange Product - https://nexdev.net/issues/110714
			alog$MMARK8422 (17522820)
			alog$PA25RDEEP (21078705)
	Creator: Dominic@20190322
	Run at: CustDB@DBCUST
*/
USE CustDB

--alog$MMARK8422
IF NOT EXISTS(SELECT 1 FROM Customer (NOLOCK) WHERE CustID=17522820)
BEGIN
	EXEC [Dot_Dep_Customer_Archive_ReactiveCustomer] @CustID  = 17522820
END

--alog$PA25RDEEP
IF NOT EXISTS(SELECT 1 FROM Customer (NOLOCK) WHERE CustID=21078705)
BEGIN
	EXEC [Dot_Dep_Customer_Archive_ReactiveCustomer] @CustID  = 21078705
END
 

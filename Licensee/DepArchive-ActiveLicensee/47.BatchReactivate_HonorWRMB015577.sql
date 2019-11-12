/*
	Task: Reactivate HonorWRMB015577 (20851687) - https://nexdev.net/issues/110714
	Creator: Dominic@20190322
	Run at: CustDB@DBCUST
*/
USE CustDB

--HonorW$eb_qinyun
IF NOT EXISTS(SELECT 1 FROM Customer (NOLOCK) WHERE CustID=20851687)
BEGIN
	EXEC [Dot_Dep_Customer_Archive_ReactiveCustomer] @CustID  = 20851687
END
 

/*<info serverAlias="DBGRP02L-bodb02"></info>*/
/*
	Created: 20231206@Sol
	Task: insert missing dummy account to Task_Cust_CheckBalance_Exception table
	DB: DBGRP02L-bodb02
*/

use bodb02;

go

--get custid that need to insert into Task_Cust_CheckBalance_Exception

select c.custid, c.username
	into #__missingDummy
from custdb.dbo.custinfo c with(nolock)
where c.custid in 
(1435103
,94770883
,104402749
,104402750)--check dataselect custid, usernamefrom #__missingDummygo--insert data, 148 rows affectedinsert into Task_Cust_CheckBalance_Exception(custid, Remark)select custid, usernamefrom #__missingDummyGO
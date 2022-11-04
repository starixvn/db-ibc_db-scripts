/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20221104@Sophia
	DB: DBCUST-bodb_Licensee
	Task: Udpate ToParty [Redmine: #180162]
 
*/

use bodb_Licensee
go

UPDATE OAS_ChargeInfo WITH (ROWLOCK)
SET ToParty = 1
Where FromParty in (771, 772) 
 
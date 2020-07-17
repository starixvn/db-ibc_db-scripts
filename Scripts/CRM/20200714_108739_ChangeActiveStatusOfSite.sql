/*<info serverAlias="DBCUST-CustDB"></info>*/

/*
	Created: Malcolm
	Date: 20200714
	Task : Update active status of site [Redmine : #108739]
	DB: DBCUST/CustDB
*/
UPDATE t
  SET 
      isActive = 0
FROM Site t WITH (ROWLOCK, UPDLOCK)
WHERE t.site IN('spotico', 'EU88', '766666', '222227', '222225', '033333');

/*<info serverAlias="DBCUST-CUSTDB" step="1"></info>*/

/*
Created: 20211021@Sophia
Task :  Update Acc_ClearBalanceList
DB: DBCUST-CUSTDB
*/



		UPDATE  dbo.Acc_ClearBalanceList  WITH (ROWLOCK)
		SET 	Status = 'failed',
				LastTransfer = getdate(),
				IsTransferring = 0
		WHERE custID = 45078457 	
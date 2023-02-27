/*<info serverAlias="DBCTG-bodb02"></info>*/
Use bodb02

/*
Create: 20230227@Danny
DB : DBCTG-bodb02
Task: Update CN88 Transfer Ticket to orphan [Redmine: #184200]

*/

UPDATE bettrans WITH(ROWLOCK, UPDLOCK)
SET custid = 0, Winlost = 0, Actual_Stake = 0, Recommend = 0, MRecommend = 0, SRecommend = 0	
WHERE TRANSID IN (88766678971711502,89137768441053198)
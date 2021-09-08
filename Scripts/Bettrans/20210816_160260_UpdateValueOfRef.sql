/*<info serverAlias="DBTXN-bodb02" step="1"></info>*/
Use bodb02

/*
Create: 20210816@Sophia
DB : DBTXN-bodb02
Task: update value of Ref table [Redmine: #160260]

*/

UPDATE Ref WITH (ROWLOCK) 
SET RefNo = 2147483648
WHERE RefId = 'RefNo'


/* 
---- this step for testing on SIT only:
UPDATE Ref WITH (ROWLOCK) 
SET Transcode = 2147483647
WHERE RefId = 'acc'

*/
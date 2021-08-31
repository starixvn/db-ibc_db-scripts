/*<info serverAlias="DBTXN-bodb02" step="1"></info>*/
Use bodb02

/*
Create: 20210816@Sophia
DB : DBTXN-bodb02
Task: Change datatype from INT to BIGINT of Ref table [Redmine: #160260]

*/

ALTER TABLE Ref
ALTER COLUMN RefNo BIGINT

ALTER TABLE Ref
ALTER COLUMN transcode BIGINT



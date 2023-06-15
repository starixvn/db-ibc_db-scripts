/*<info serverAlias="DBN88-bodb_N88" isFunction="0" isNested=""></info>*/
/*	
	Created: 20230615@Sally
	Task: Fix inconsistency - [Redmine: #186979]
	DB: DBN88/bodb_N88
	- Repull data DepositInfo
*/

/*Run ON DB052, DB053*/

DELETE API_TimeTracker WHERE DataSource = 'DepositInfo'

INSERT INTO API_TimeTracker (DataSource , calledTime, KeyValue)
VALUES ('DepositInfo', '2023-05-16 00:00:00', '{"Id":5328140,"UpdateTime":"2023-05-16 00:00:00"}')
GO
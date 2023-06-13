/*<info serverAlias="DBN88-bodb_N88" isFunction="0" isNested=""></info>*/
/*	
	Created: 20230613@Sally
	Task: Update setting - [Redmine: #186979]
	DB: DBN88/bodb_N88

*/

/*Run ON DB052, DB053*/

DELETE API_TimeTracker WHERE dataSource = 'PromotionSpecific'

INSERT INTO API_TimeTracker (DataSource , calledTime, KeyValue)
VALUES ('PromotionSpecific', '2020-01-01 00:00:00', '2020-01-01 00:00:00')

GO

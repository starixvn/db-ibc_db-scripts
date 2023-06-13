/*<info serverAlias="DBN88-bodb_N88" isFunction="0" isNested=""></info>*/
/*	
	Created: 20230613@Sally
	Task: Update setting - [Redmine: #186979]
	DB: DBN88/bodb_N88

*/

/*Run ON DB052, DB053*/

DELETE a
FROM API_TimeTracker a WITH (ROWLOCK)
WHERE dataSource = 'PromotionSpecific'
AND Id > 4155869

UPDATE a SET CalledTime ='2023-06-13 00:00:00', KeyValue ='2023-06-13 00:00:00'
FROM API_TimeTracker a WITH (ROWLOCK)
WHERE dataSource = 'PromotionSpecific'
AND Id = 4155869

GO
DELETE API_TimeTracker WHERE dataSource = 'VipUpgradeReview'

INSERT INTO API_TimeTracker (DataSource , calledTime, KeyValue)
VALUES ('VipUpgradeReview', '2021-01-01 00:00:00', '2021-01-01 00:00:00')
GO
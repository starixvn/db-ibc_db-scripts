/*
	Description: A script to update ActionName for ActionID: 450, 451, 452
	Creator: 20151116@Billy
	DB: DBLOG/bodb_CustomerLog
*/

USE [bodb_CustomerLog]
GO

UPDATE LogAction
SET	ActionNameEN = 'Update Other Products Position Taking for member',
	ActionNameCH = 'Update Other Products Position Taking for member',
	ActionNameCS = 'Update Other Products Position Taking for member',
	ActionNameJP = 'Update Other Products Position Taking for member',
	ActionNameIT = 'Update Other Products Position Taking for member',
	ActionNameTH = 'Update Other Products Position Taking for member',
	ActionNameKO = 'Update Other Products Position Taking for member',
	ActionNameVI = 'Update Other Products Position Taking for member'
WHERE ActionID = 450

UPDATE LogAction
SET	ActionNameEN = 'Update Master''s Other Products Position Taking for member',
	ActionNameCH = 'Update Master''s Other Products Position Taking for member',
	ActionNameCS = 'Update Master''s Other Products Position Taking for member',
	ActionNameJP = 'Update Master''s Other Products Position Taking for member',
	ActionNameIT = 'Update Master''s Other Products Position Taking for member',
	ActionNameTH = 'Update Master''s Other Products Position Taking for member',
	ActionNameKO = 'Update Master''s Other Products Position Taking for member',
	ActionNameVI = 'Update Master''s Other Products Position Taking for member'
WHERE ActionID = 451

UPDATE LogAction
SET	ActionNameEN = 'Update Super''s Other Products Position Taking for member',
	ActionNameCH = 'Update Super''s Other Products Position Taking for member',
	ActionNameCS = 'Update Super''s Other Products Position Taking for member',
	ActionNameJP = 'Update Super''s Other Products Position Taking for member',
	ActionNameIT = 'Update Super''s Other Products Position Taking for member',
	ActionNameTH = 'Update Super''s Other Products Position Taking for member',
	ActionNameKO = 'Update Super''s Other Products Position Taking for member',
	ActionNameVI = 'Update Super''s Other Products Position Taking for member'
WHERE ActionID = 452
GO

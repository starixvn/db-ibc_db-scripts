/*
	Created: Vicky
	Task: add column ActionID into table Single_Calculate_Queue_3rd
	DB: DBTXN/bodb02
	Date: 20190115
	
*/
USE [bodb02]
GO

ALTER TABLE dbo.Single_Calculate_Queue_3rd ADD
	ActionID INT NULL
	
GO
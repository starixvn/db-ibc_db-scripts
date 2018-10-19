/*
	Created: Vicky
	Task: add column OddsType for SettlementSpecialBettypeProfile
	DB: DBTXN/bodb02
	Date: 20181019
*/
USE [bodb02]
GO

ALTER SettlementSpecialBettypeProfile
ADD OddsType SMALLINT

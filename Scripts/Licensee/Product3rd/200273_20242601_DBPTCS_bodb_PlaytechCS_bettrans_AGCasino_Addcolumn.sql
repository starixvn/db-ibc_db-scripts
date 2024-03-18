/*<info serverAlias="DBPTCS-bodb_PlaytechCS" executers="" viewers="" ></info>*/
/*
	Created: 20240126@Evan
	DB: DBLIC-bodb_PlaytechCS
	Task: Add column to define value of Promotion and Contribution
	https://nexdev.net/issues/200273

*/
USE [bodb_PlaytechCS]
GO

ALTER TABLE bettrans_AGCasino
ADD GameCode VARCHAR(30), JpContribution MONEY


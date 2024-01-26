/*<info serverAlias="DBACC-bodb_archive" executers="" viewers="" ></info>*/
/*
	Created: 20240126@Evan
	DB: DBACC-bodb_archive	
	Task: Add column to define value of Promotion and Contribution
	https://nexdev.net/issues/200273

*/
USE bodb_archive	
GO

ALTER TABLE bettrans_AGCasino_bk
ADD GameCode VARCHAR(30), JpContribution MONEY


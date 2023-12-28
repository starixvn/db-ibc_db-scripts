/*<info serverAlias="DBPTCS-bodb_PlaytechCS" executers="" viewers="" ></info>*/
/*
	Created: 20231228@Evan
	DB: DBLIC-bodb_PlaytechCS
	Task: Create table bettrans_AGCasino_Temp for check data only

*/

USE [bodb_PlaytechCS]
GO

ALTER TABLE bettrans_AGCasino_Temp
ADD JpInvest MONEY , JpPayout MONEY
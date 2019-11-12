/*
	Task: Update config to archive for 32 licensees - Support #109528
	Creator: Dominic@20190313
	Run at: DBCUST.CustDB

*/
USE [CustDB]

--Update current active config to 'Pending'
UPDATE Dep_Customer_Archived_Config
SET Status=2 --Pending
WHERE Status=0

--Update config to archive 32 licensees
UPDATE Dep_Customer_Archived_Config
SET Status=0 --Active
WHERE site in (
	'e8Casino '
	,'DEWA '
	,'PanguGame'
	,'Lucky88'
	,'818Bet'
	,'Unobet'
	,'Swin'
	,'Brown888'
	,'M8bola'
	,'IGPTech'
	,'ECLBET'
	,'396Club'
	,'NBCbet'
	,'BetStar'
	,'Heaven'
	,'Hengcai88'
	,'Q8bola'
	,'GPIGAME'
	,'DBP'
	,'Taipanbet'
	,'HL8'
	,'Zzun88'
	,'Hecbet'
	,'88Macao'
	,'TGO'
	,'iBet'
	,'Mayayule'
	,'Royal'
	,'Dawoo'
	,'IBO'
	,'9bet'
	,'ITCBet'
)
/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Create: 20211230@Sol
	DB : DBRPT-bodb_Report
	Task: insert data - [Redmine: #162264]
*/

USE bodb_Report;

GO  

INSERT INTO dbo.tblCasinoPartners(PartnerId, PartnerName, TransferId, CancelTransferId)
VALUES
(1	,'Hogaming'			,22008	,22009)
,(2	,'OPusCasino'		,22010	,22011)
,(3	,'AGCasino'			,22014	,22015)
,(4	,'GoldDeluxe'		,22016	,22017)
,(5	,'Voidbridge'		,22018	,22019)
,(7	,'3DSlot'			,22020	,22021)
,(8	,'LBKeno'			,22022	,22023)
,(9	,'12Opal'			,22024	,22025)
,(10	,'12Amber'		,22026	,22027)
,(11	,'12Quartz'		,22028	,22029)
,(13	,'12Topaz'		,22032	,22033)
,(14	,'IMone'		,22034	,22035)
,(15	,'BTi'			,22036	,22037)
,(17	,'12Sapphire'	,22040	,22041)
,(18	,'12TopazNew'	,22042	,22043)
,(19	,'12KYGaming'	,22044	,22045)
,(20	,'12Moonstone' 	,22046	,22047)
,(21	,'12EA'			,22048	,22049)
,(22	,'12n2Live'		,22050	,22051)
,(23	,'12IDNPoker'	,22052	,22053)
,(24	,'12BG'			,22054	,22055)
,(25	,'AVPMini'		,22056	,22057)
,(26	,'AVPSlot'		,22058	,22059)

GO
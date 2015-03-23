--DBA
--1. Clone DB to new Sub DbName
--2 Grant Permisstion
--3 Install/Update SQL jobs - reports/stats data
--  - Collect/repair stattistic data of subscriber
--  - job_collect_subscriber_report

--4 Update Maitainence Plan
-- check permission on one dynamic view VW_LatestTrans, add alter/create view permission for fpsWebSub user

-- update FPS_ADmin/SubDBServers table, add new row for new licensee
/*
select MAX([SubscriberId]) from subdbservers
select * from subdbservers
where  DbName='FPS_SUB_I228BET'

USE [FPS_ADMIN]
GO

INSERT INTO [dbo].[SubDBServers]
           ([SubscriberId]
           ,[ServerIP]
           ,[ServerName]
           ,[DbName]
           ,[LinkedDevice]
           ,[IsOnMain])
     VALUES
           (131
           ,'10.40.40.107' --DB SERVER ip
           ,'FPSLIC107WEB' --LINKED SERVER NAME TO DBSERVER
           ,'FPS_SUB_Spondemo'
           ,'FPSDEV' ----LINKED SERVER NAME TO FPS_DEV db server
           ,0
		   )

*/
-- update deployment tool
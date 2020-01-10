/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/
USE CustDB
GO
--Table TOControl_Profile
INSERT INTO TOControl_Profile ([ProfileName],Sporttype)
VALUES ('Live - HDP', 1)
,('Live - OU', 1)
,('Live - 1H HDP', 1)
,('Live - 1H OU', 1)
,('Live - Others', 1)
,('Non Live - HDP', 1)
,('Non Live - OU', 1)
,('Non Live - 1H HDP', 1)
,('Non Live - 1H OU', 1)
,('Non Live - Others', 1)
,('Live - HDP&ML', 99)
,('Live - OU', 99)
,('Live - 1H HDP&ML', 99)
,('Live - 1H OU', 99)
,('Live - Others', 99)
,('Non Live - HDP&ML', 99)
,('Non Live - OU', 99)
,('Non Live - 1H HDP&ML', 99)
,('Non Live - 1H OU', 99)
,('Non Live - Others', 99)

--Table TOControl_ProfileSetting
INSERT INTO TOControl_ProfileSetting(ProfileID, Sporttype, Bettype, liveindicator)
VALUES (1, 1, 1, 1)
,(2, 1, 3, 1)
,(3, 1, 7, 1)
,(4, 1 ,8, 1)
,(5, 1, 0, 1)
,(6, 1, 1, 0)
,(7, 1, 3, 0)
,(8, 1, 7, 0)
,(9, 1, 8, 0)
,(10, 1, 0, 0)
,(11, 99, 1, 1)
,(11, 99, 20, 1)
,(12, 99, 3, 1)
,(13, 99, 7, 1)
,(13, 99, 21, 1)
,(14, 99, 8, 1)
,(15, 99, 0, 0)
,(16, 99, 1, 0)
,(16, 99, 20, 0)
,(17, 99, 3, 1)
,(18, 99, 7, 0)
,(18, 99, 21, 0)
,(19, 99, 8, 0)
,(20, 99, 0, 0)

GO


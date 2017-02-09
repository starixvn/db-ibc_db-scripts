/*
	Created: 20170208@Helen
	Task: Missing Allbet setting - [Redmine:68644]
	DB: DBCUST/CUSTDB
*/

CREATE TABLE #cust_missingsetting (custid INT, Roleid INT, srecommend INT, mrecommend INT, recommend INT)

INSERT INTO #cust_missingsetting (custid,Roleid,srecommend,mrecommend,recommend)
SELECT custid,Roleid,srecommend,mrecommend,recommend
FROM custInfo CI WITH (NOLOCK)
WHERE CI.custid IN (1)

DECLARE @SportType SMALLINT = 211, @Bettype SMALLINT = 2401
/********************************************* Commision : SettingType = 3 ****************************************/
--IF @RoleID = 2,3,4
INSERT INTO [dbo].[CustDiscount3rd_Agent]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[Discount])
SELECT custid,@SportType,@Bettype,0 -- 0 zero by default
FROM #cust_missingsetting
WHERE Roleid IN (2,3,4)
-- Roleid = 1
--super.discount: super.discount
--master.discount: master.discount
--agent.discount: agent.discount
--playerdiscount: 0
INSERT INTO [dbo].[CustDiscount3rd_Member]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[PlayerDiscount]
   ,[AgentDiscount]
   ,[MasterDiscount]
   ,[SuperDiscount])
SELECT 
	ft.custid
	,acs.SportType
	,acs.BetType
	,0
	,acs.Discount
	,mcs.Discount
	,scs.Discount
FROM #cust_missingsetting ft 
	INNER JOIN dbo.CustDiscount3rd_Agent acs WITH (NOLOCK) ON acs.SportType = @SportType AND acs.BetType = @Bettype AND acs.custid=ft.recommend
	INNER JOIN dbo.CustDiscount3rd_Agent mcs WITH (NOLOCK) ON acs.sporttype = mcs.sporttype AND acs.bettype = mcs.bettype AND mcs.custid = ft.mrecommend
	INNER JOIN dbo.CustDiscount3rd_Agent scs WITH (NOLOCK) ON acs.sporttype = scs.sporttype AND acs.bettype = scs.bettype AND scs.custid = ft.srecommend
WHERE ft.Roleid = 1

DROP TABLE #cust_missingsetting

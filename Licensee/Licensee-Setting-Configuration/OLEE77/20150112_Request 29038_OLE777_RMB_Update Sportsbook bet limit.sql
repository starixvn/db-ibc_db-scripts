/*  OLE777- Adjust bet settings for Sporbooks
	Bet setting will follow info in the ticket below
	https://redmine.nexcel.vn/issues/29038
	Author: Susan
	Created date: 2015-01-12
currency			Max bet			Max per match
RMB					200,000		   400,000

*/

ALTER PROCEDURE [dbo].[Acc_ExecRep_cust_09]
		  @srecommend INT
	     ,@maxcustid INT	
		 ,@target VARCHAR(20)
AS
BEGIN
SET NOCOUNT ON;
IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only


IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Custinfo') RETURN

--update soccer bet setting : 1827 rows

UPDATE Custinfo WITH (ROWLOCK, UPDLOCK)
SET		maxpermatch = 400000,
		maxpermatch2 = 400000,
		maxpermatch3 = 400000,
		maxpermatch5 = 400000,
		maxpermatch8 = 400000,
		maxpermatch10 = 400000,
		maxpermatch11 = 400000,
		maxpermatch99 = 400000,
		maxpermatch154 = 400000, --applied for HRFO
		MaxPerMatch99MP = 400000
		WHERE srecommend =@srecommend
	  AND mrecommend not in (select custid from custinfo with(nolock)
								where username like '%Acc%' and roleid=3)
	  AND custid <= @maxcustid

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting') RETURN

--perform updating sportbook max bet : 78561 rows

UPDATE DCS WITH (ROWLOCK,UPDLOCK)
SET		Maxbet = 200000
FROM Dep_CustSetting dcs
INNER JOIN custInfo ci with (nolock)on dcs.custid = ci.custid
WHERE ci.srecommend =@srecommend
	  AND ci.mrecommend NOT IN (select custid from custinfo with(nolock)
								where username like '%Acc%' and roleid=3)
	  AND ci.custid <= @maxcustid	
		

End

GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------


-- BEGIN STEP 2: RUN THIS SCRIPT AT ReplicateDB-----
-------------------------------------------------

Declare @currency int ,@srecommend int ,@site varchar (50)
,@maxcustid int
 
select @currency=13,--RMB
		@site='OLE777',
	   @maxcustid=xxx --input maxcustid 16914473

SELECT @srecommend = custid 
FROM Dep_CustSuper with(NOLOCK) where site = @site and currency =@currency  ---RMB
		
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend, @maxcustid=@maxcustid,@target = 'REPLICATED'  	
	

GO

---- End of step 2

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------

Declare @currency int ,@srecommend int ,@site varchar (50)
,@maxcustid int
 
select @currency=13,--RMB
		@site='OLE777',
	   @maxcustid=xxx --input maxcustid 16914473

SELECT @srecommend = custid 
FROM Dep_CustSuper with(NOLOCK) where site = @site and currency =@currency  ---RM
		
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend, @maxcustid=@maxcustid,@target = 'DBTRANS'  	
	
GO


---- End of step 3
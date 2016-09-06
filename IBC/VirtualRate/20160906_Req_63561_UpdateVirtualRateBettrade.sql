 /*
	Created: 20160805@Winnie
	Task: Modify Virtual Rate data following new requirements - [Redmine: #61713]
	DB: DBCUST/CustDB
*/
ALTER PROCEDURE	dbo.Acc_CustSetting3rd_19	
	@target		VARCHAR(20)			
AS
BEGIN	
	SET NOCOUNT ON; 
	IF (@target = 'REPLICATED' AND @@SERVERNAME =  'DBCUST')	-- Run at all replicated servers
		RETURN;
	IF (@target = 'DBCUST'	   AND @@SERVERNAME <> 'DBCUST')	-- Run at DBCUST only
		RETURN;
	
	IF dbo.f_CheckRepTable('CustVirtualSetting') = 0 RETURN
	IF dbo.f_CheckRepTable('BetTradeCust') = 0 RETURN
	IF dbo.f_CheckRepTable('Dep_CustSuper') = 0 RETURN
 
 UPDATE CustVirtualSetting WITH (ROWLOCK,UPDLOCK) 
 SET bitmapVirtual=0x64646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464
 WHERE custid IN
 (SELECT  a.Custid  FROM Customer a WITH(NOLOCK)
 INNER JOIN BetTradeCust b WITH(NOLOCK) ON a.custid=b.custid
 WHERE a.srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK) WHERE site  IN('TLC', 'Fun88'))
 )
 
END
GO
-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON REPLICATED SERVER --
-----------------------------------------------------------

	EXECUTE	dbo.Acc_CustSetting3rd_19
			@target = 'REPLICATED';



-- BEGIN STEP 3: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Select super lines for importing data --


	EXECUTE	dbo.Acc_CustSetting3rd_19			
				@target = 'DBCUST';


GO
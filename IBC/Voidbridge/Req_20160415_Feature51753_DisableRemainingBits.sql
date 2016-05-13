/*
	Created: Dominic
	Date: 2016-04-15
	Task: Update bit values to 1 for bits between 5th and 255th
	DB: DBCust/CustDB
*/   
-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE Acc_DynamicCustomerInfo_09
	@CustID INT	
	,@target VARCHAR(30)
AS
BEGIN   
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
	  RETURN
	  
	DECLARE @xml VARCHAR(MAX) = '<root>	
	<r b="5" s="1"/>
	<r b="6" s="1"/>
	<r b="7" s="1"/>
	<r b="8" s="1"/>
	<r b="9" s="1"/>
	<r b="10" s="1"/>
	<r b="11" s="1"/>
	<r b="12" s="1"/>
	<r b="13" s="1"/>
	<r b="14" s="1"/>
	<r b="15" s="1"/>
	<r b="16" s="1"/>
	<r b="17" s="1"/>
	<r b="18" s="1"/>
	<r b="19" s="1"/>
	<r b="20" s="1"/>
	<r b="21" s="1"/>
	<r b="22" s="1"/>
	<r b="23" s="1"/>
	<r b="24" s="1"/>
	<r b="25" s="1"/>
	<r b="26" s="1"/>
	<r b="27" s="1"/>
	<r b="28" s="1"/>
	<r b="29" s="1"/>
	<r b="30" s="1"/>
	<r b="31" s="1"/>
	<r b="32" s="1"/>
	<r b="33" s="1"/>
	<r b="34" s="1"/>
	<r b="35" s="1"/>
	<r b="36" s="1"/>
	<r b="37" s="1"/>
	<r b="38" s="1"/>
	<r b="39" s="1"/>
	<r b="40" s="1"/>
	<r b="41" s="1"/>
	<r b="42" s="1"/>
	<r b="43" s="1"/>
	<r b="44" s="1"/>
	<r b="45" s="1"/>
	<r b="46" s="1"/>
	<r b="47" s="1"/>
	<r b="48" s="1"/>
	<r b="49" s="1"/>
	<r b="50" s="1"/>
	<r b="51" s="1"/>
	<r b="52" s="1"/>
	<r b="53" s="1"/>
	<r b="54" s="1"/>
	<r b="55" s="1"/>
	<r b="56" s="1"/>
	<r b="57" s="1"/>
	<r b="58" s="1"/>
	<r b="59" s="1"/>
	<r b="60" s="1"/>
	<r b="61" s="1"/>
	<r b="62" s="1"/>
	<r b="63" s="1"/>
	<r b="64" s="1"/>
	<r b="65" s="1"/>
	<r b="66" s="1"/>
	<r b="67" s="1"/>
	<r b="68" s="1"/>
	<r b="69" s="1"/>
	<r b="70" s="1"/>
	<r b="71" s="1"/>
	<r b="72" s="1"/>
	<r b="73" s="1"/>
	<r b="74" s="1"/>
	<r b="75" s="1"/>
	<r b="76" s="1"/>
	<r b="77" s="1"/>
	<r b="78" s="1"/>
	<r b="79" s="1"/>
	<r b="80" s="1"/>
	<r b="81" s="1"/>
	<r b="82" s="1"/>
	<r b="83" s="1"/>
	<r b="84" s="1"/>
	<r b="85" s="1"/>
	<r b="86" s="1"/>
	<r b="87" s="1"/>
	<r b="88" s="1"/>
	<r b="89" s="1"/>
	<r b="90" s="1"/>
	<r b="91" s="1"/>
	<r b="92" s="1"/>
	<r b="93" s="1"/>
	<r b="94" s="1"/>
	<r b="95" s="1"/>
	<r b="96" s="1"/>
	<r b="97" s="1"/>
	<r b="98" s="1"/>
	<r b="99" s="1"/>
	<r b="100" s="1"/>
	<r b="101" s="1"/>
	<r b="102" s="1"/>
	<r b="103" s="1"/>
	<r b="104" s="1"/>
	<r b="105" s="1"/>
	<r b="106" s="1"/>
	<r b="107" s="1"/>
	<r b="108" s="1"/>
	<r b="109" s="1"/>
	<r b="110" s="1"/>
	<r b="111" s="1"/>
	<r b="112" s="1"/>
	<r b="113" s="1"/>
	<r b="114" s="1"/>
	<r b="115" s="1"/>
	<r b="116" s="1"/>
	<r b="117" s="1"/>
	<r b="118" s="1"/>
	<r b="119" s="1"/>
	<r b="120" s="1"/>
	<r b="121" s="1"/>
	<r b="122" s="1"/>
	<r b="123" s="1"/>
	<r b="124" s="1"/>
	<r b="125" s="1"/>
	<r b="126" s="1"/>
	<r b="127" s="1"/>
	<r b="128" s="1"/>
	<r b="129" s="1"/>
	<r b="130" s="1"/>
	<r b="131" s="1"/>
	<r b="132" s="1"/>
	<r b="133" s="1"/>
	<r b="134" s="1"/>
	<r b="135" s="1"/>
	<r b="136" s="1"/>
	<r b="137" s="1"/>
	<r b="138" s="1"/>
	<r b="139" s="1"/>
	<r b="140" s="1"/>
	<r b="141" s="1"/>
	<r b="142" s="1"/>
	<r b="143" s="1"/>
	<r b="144" s="1"/>
	<r b="145" s="1"/>
	<r b="146" s="1"/>
	<r b="147" s="1"/>
	<r b="148" s="1"/>
	<r b="149" s="1"/>
	<r b="150" s="1"/>
	<r b="151" s="1"/>
	<r b="152" s="1"/>
	<r b="153" s="1"/>
	<r b="154" s="1"/>
	<r b="155" s="1"/>
	<r b="156" s="1"/>
	<r b="157" s="1"/>
	<r b="158" s="1"/>
	<r b="159" s="1"/>
	<r b="160" s="1"/>
	<r b="161" s="1"/>
	<r b="162" s="1"/>
	<r b="163" s="1"/>
	<r b="164" s="1"/>
	<r b="165" s="1"/>
	<r b="166" s="1"/>
	<r b="167" s="1"/>
	<r b="168" s="1"/>
	<r b="169" s="1"/>
	<r b="170" s="1"/>
	<r b="171" s="1"/>
	<r b="172" s="1"/>
	<r b="173" s="1"/>
	<r b="174" s="1"/>
	<r b="175" s="1"/>
	<r b="176" s="1"/>
	<r b="177" s="1"/>
	<r b="178" s="1"/>
	<r b="179" s="1"/>
	<r b="180" s="1"/>
	<r b="181" s="1"/>
	<r b="182" s="1"/>
	<r b="183" s="1"/>
	<r b="184" s="1"/>
	<r b="185" s="1"/>
	<r b="186" s="1"/>
	<r b="187" s="1"/>
	<r b="188" s="1"/>
	<r b="189" s="1"/>
	<r b="190" s="1"/>
	<r b="191" s="1"/>
	<r b="192" s="1"/>
	<r b="193" s="1"/>
	<r b="194" s="1"/>
	<r b="195" s="1"/>
	<r b="196" s="1"/>
	<r b="197" s="1"/>
	<r b="198" s="1"/>
	<r b="199" s="1"/>
	<r b="200" s="1"/>
	<r b="201" s="1"/>
	<r b="202" s="1"/>
	<r b="203" s="1"/>
	<r b="204" s="1"/>
	<r b="205" s="1"/>
	<r b="206" s="1"/>
	<r b="207" s="1"/>
	<r b="208" s="1"/>
	<r b="209" s="1"/>
	<r b="210" s="1"/>
	<r b="211" s="1"/>
	<r b="212" s="1"/>
	<r b="213" s="1"/>
	<r b="214" s="1"/>
	<r b="215" s="1"/>
	<r b="216" s="1"/>
	<r b="217" s="1"/>
	<r b="218" s="1"/>
	<r b="219" s="1"/>
	<r b="220" s="1"/>
	<r b="221" s="1"/>
	<r b="222" s="1"/>
	<r b="223" s="1"/>
	<r b="224" s="1"/>
	<r b="225" s="1"/>
	<r b="226" s="1"/>
	<r b="227" s="1"/>
	<r b="228" s="1"/>
	<r b="229" s="1"/>
	<r b="230" s="1"/>
	<r b="231" s="1"/>
	<r b="232" s="1"/>
	<r b="233" s="1"/>
	<r b="234" s="1"/>
	<r b="235" s="1"/>
	<r b="236" s="1"/>
	<r b="237" s="1"/>
	<r b="238" s="1"/>
	<r b="239" s="1"/>
	<r b="240" s="1"/>
	<r b="241" s="1"/>
	<r b="242" s="1"/>
	<r b="243" s="1"/>
	<r b="244" s="1"/>
	<r b="245" s="1"/>
	<r b="246" s="1"/>
	<r b="247" s="1"/>
	<r b="248" s="1"/>
	<r b="249" s="1"/>
	<r b="250" s="1"/>
	<r b="251" s="1"/>
	<r b="252" s="1"/>
	<r b="253" s="1"/>
	<r b="254" s="1"/>
	<r b="255" s="1"/>
	</root>'

	--Update product status
	UPDATE cs
	SET
			bitmapIsHidden = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, @xml)),
			bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, @xml)),
			bitmapHasSynced = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapHasSynced, @xml))
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	WHERE ci.srecommend = @CustID

END

-- BEGIN STEP 2: BEFORE UM - RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @CustID = @srecommend
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END



-- BEGIN STEP 3: BEFORE UM - RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DBCUST) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @CustID = @srecommend
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END


-- BEGIN STEP 4: IN UM - RUN THIS SCRIPT -----
--------------------------------------------------------------------------------------
DECLARE @max_custid INT
	
SELECT @max_custid = xxx

CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	
CREATE TABLE #CustomerTemp
(
	CustID INT PRIMARY KEY CLUSTERED
)


INSERT #CustomerTemp(CustID)
SELECT CustID
FROM dbo.customer WITH(NOLOCK)
WHERE srecommend IN (SELECT CustID FROM #supers)
	AND CustID > @max_custid
	
DECLARE @xml VARCHAR(MAX) = '<root>
	<r b="4" s="1"/>
	<r b="5" s="1"/>
	<r b="6" s="1"/>
	<r b="7" s="1"/>
	<r b="8" s="1"/>
	<r b="9" s="1"/>
	<r b="10" s="1"/>
	<r b="11" s="1"/>
	<r b="12" s="1"/>
	<r b="13" s="1"/>
	<r b="14" s="1"/>
	<r b="15" s="1"/>
	<r b="16" s="1"/>
	<r b="17" s="1"/>
	<r b="18" s="1"/>
	<r b="19" s="1"/>
	<r b="20" s="1"/>
	<r b="21" s="1"/>
	<r b="22" s="1"/>
	<r b="23" s="1"/>
	<r b="24" s="1"/>
	<r b="25" s="1"/>
	<r b="26" s="1"/>
	<r b="27" s="1"/>
	<r b="28" s="1"/>
	<r b="29" s="1"/>
	<r b="30" s="1"/>
	<r b="31" s="1"/>
	<r b="32" s="1"/>
	<r b="33" s="1"/>
	<r b="34" s="1"/>
	<r b="35" s="1"/>
	<r b="36" s="1"/>
	<r b="37" s="1"/>
	<r b="38" s="1"/>
	<r b="39" s="1"/>
	<r b="40" s="1"/>
	<r b="41" s="1"/>
	<r b="42" s="1"/>
	<r b="43" s="1"/>
	<r b="44" s="1"/>
	<r b="45" s="1"/>
	<r b="46" s="1"/>
	<r b="47" s="1"/>
	<r b="48" s="1"/>
	<r b="49" s="1"/>
	<r b="50" s="1"/>
	<r b="51" s="1"/>
	<r b="52" s="1"/>
	<r b="53" s="1"/>
	<r b="54" s="1"/>
	<r b="55" s="1"/>
	<r b="56" s="1"/>
	<r b="57" s="1"/>
	<r b="58" s="1"/>
	<r b="59" s="1"/>
	<r b="60" s="1"/>
	<r b="61" s="1"/>
	<r b="62" s="1"/>
	<r b="63" s="1"/>
	<r b="64" s="1"/>
	<r b="65" s="1"/>
	<r b="66" s="1"/>
	<r b="67" s="1"/>
	<r b="68" s="1"/>
	<r b="69" s="1"/>
	<r b="70" s="1"/>
	<r b="71" s="1"/>
	<r b="72" s="1"/>
	<r b="73" s="1"/>
	<r b="74" s="1"/>
	<r b="75" s="1"/>
	<r b="76" s="1"/>
	<r b="77" s="1"/>
	<r b="78" s="1"/>
	<r b="79" s="1"/>
	<r b="80" s="1"/>
	<r b="81" s="1"/>
	<r b="82" s="1"/>
	<r b="83" s="1"/>
	<r b="84" s="1"/>
	<r b="85" s="1"/>
	<r b="86" s="1"/>
	<r b="87" s="1"/>
	<r b="88" s="1"/>
	<r b="89" s="1"/>
	<r b="90" s="1"/>
	<r b="91" s="1"/>
	<r b="92" s="1"/>
	<r b="93" s="1"/>
	<r b="94" s="1"/>
	<r b="95" s="1"/>
	<r b="96" s="1"/>
	<r b="97" s="1"/>
	<r b="98" s="1"/>
	<r b="99" s="1"/>
	<r b="100" s="1"/>
	<r b="101" s="1"/>
	<r b="102" s="1"/>
	<r b="103" s="1"/>
	<r b="104" s="1"/>
	<r b="105" s="1"/>
	<r b="106" s="1"/>
	<r b="107" s="1"/>
	<r b="108" s="1"/>
	<r b="109" s="1"/>
	<r b="110" s="1"/>
	<r b="111" s="1"/>
	<r b="112" s="1"/>
	<r b="113" s="1"/>
	<r b="114" s="1"/>
	<r b="115" s="1"/>
	<r b="116" s="1"/>
	<r b="117" s="1"/>
	<r b="118" s="1"/>
	<r b="119" s="1"/>
	<r b="120" s="1"/>
	<r b="121" s="1"/>
	<r b="122" s="1"/>
	<r b="123" s="1"/>
	<r b="124" s="1"/>
	<r b="125" s="1"/>
	<r b="126" s="1"/>
	<r b="127" s="1"/>
	<r b="128" s="1"/>
	<r b="129" s="1"/>
	<r b="130" s="1"/>
	<r b="131" s="1"/>
	<r b="132" s="1"/>
	<r b="133" s="1"/>
	<r b="134" s="1"/>
	<r b="135" s="1"/>
	<r b="136" s="1"/>
	<r b="137" s="1"/>
	<r b="138" s="1"/>
	<r b="139" s="1"/>
	<r b="140" s="1"/>
	<r b="141" s="1"/>
	<r b="142" s="1"/>
	<r b="143" s="1"/>
	<r b="144" s="1"/>
	<r b="145" s="1"/>
	<r b="146" s="1"/>
	<r b="147" s="1"/>
	<r b="148" s="1"/>
	<r b="149" s="1"/>
	<r b="150" s="1"/>
	<r b="151" s="1"/>
	<r b="152" s="1"/>
	<r b="153" s="1"/>
	<r b="154" s="1"/>
	<r b="155" s="1"/>
	<r b="156" s="1"/>
	<r b="157" s="1"/>
	<r b="158" s="1"/>
	<r b="159" s="1"/>
	<r b="160" s="1"/>
	<r b="161" s="1"/>
	<r b="162" s="1"/>
	<r b="163" s="1"/>
	<r b="164" s="1"/>
	<r b="165" s="1"/>
	<r b="166" s="1"/>
	<r b="167" s="1"/>
	<r b="168" s="1"/>
	<r b="169" s="1"/>
	<r b="170" s="1"/>
	<r b="171" s="1"/>
	<r b="172" s="1"/>
	<r b="173" s="1"/>
	<r b="174" s="1"/>
	<r b="175" s="1"/>
	<r b="176" s="1"/>
	<r b="177" s="1"/>
	<r b="178" s="1"/>
	<r b="179" s="1"/>
	<r b="180" s="1"/>
	<r b="181" s="1"/>
	<r b="182" s="1"/>
	<r b="183" s="1"/>
	<r b="184" s="1"/>
	<r b="185" s="1"/>
	<r b="186" s="1"/>
	<r b="187" s="1"/>
	<r b="188" s="1"/>
	<r b="189" s="1"/>
	<r b="190" s="1"/>
	<r b="191" s="1"/>
	<r b="192" s="1"/>
	<r b="193" s="1"/>
	<r b="194" s="1"/>
	<r b="195" s="1"/>
	<r b="196" s="1"/>
	<r b="197" s="1"/>
	<r b="198" s="1"/>
	<r b="199" s="1"/>
	<r b="200" s="1"/>
	<r b="201" s="1"/>
	<r b="202" s="1"/>
	<r b="203" s="1"/>
	<r b="204" s="1"/>
	<r b="205" s="1"/>
	<r b="206" s="1"/>
	<r b="207" s="1"/>
	<r b="208" s="1"/>
	<r b="209" s="1"/>
	<r b="210" s="1"/>
	<r b="211" s="1"/>
	<r b="212" s="1"/>
	<r b="213" s="1"/>
	<r b="214" s="1"/>
	<r b="215" s="1"/>
	<r b="216" s="1"/>
	<r b="217" s="1"/>
	<r b="218" s="1"/>
	<r b="219" s="1"/>
	<r b="220" s="1"/>
	<r b="221" s="1"/>
	<r b="222" s="1"/>
	<r b="223" s="1"/>
	<r b="224" s="1"/>
	<r b="225" s="1"/>
	<r b="226" s="1"/>
	<r b="227" s="1"/>
	<r b="228" s="1"/>
	<r b="229" s="1"/>
	<r b="230" s="1"/>
	<r b="231" s="1"/>
	<r b="232" s="1"/>
	<r b="233" s="1"/>
	<r b="234" s="1"/>
	<r b="235" s="1"/>
	<r b="236" s="1"/>
	<r b="237" s="1"/>
	<r b="238" s="1"/>
	<r b="239" s="1"/>
	<r b="240" s="1"/>
	<r b="241" s="1"/>
	<r b="242" s="1"/>
	<r b="243" s="1"/>
	<r b="244" s="1"/>
	<r b="245" s="1"/>
	<r b="246" s="1"/>
	<r b="247" s="1"/>
	<r b="248" s="1"/>
	<r b="249" s="1"/>
	<r b="250" s="1"/>
	<r b="251" s="1"/>
	<r b="252" s="1"/>
	<r b="253" s="1"/>
	<r b="254" s="1"/>
	<r b="255" s="1"/>
	</root>'

	--Update product status of CF
	UPDATE cs
	SET
			bitmapIsHidden = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, @xml)),
			bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, @xml))
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #CustomerTemp ci WITH(NOLOCK) ON ci.CustID = cs.CustID
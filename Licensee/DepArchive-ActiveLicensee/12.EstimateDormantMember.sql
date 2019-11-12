/*
	Run at: bodb02@DB06
*/
USE bodb02
GO


------------------------------------------Step 1: Get a list of agents------------------------------------------------------------
--Comma separated string of licensee,e.g, 'KaiHao,12bet,W88'
DECLARE @_LicenseeLst VARCHAR(4000)='FUN88,Oriental Game,368Cash,Newhonbet,ISC888,Macaubet,HAYDOCK,GamingSoft,LIVV88 (KEENOCEAN),HONBET,Ty777,SunGame,365online,MAYFAIR (LETOU/BET16),BE7,TLC,AG,Liga,VWin,HuangMa,HEJI (HAPPY168),PKbet,Aoncash,Ae88,Gampag,HonorW,Boying,KhmerG,Abcasino,9Club,Sunrise,ITCbet,3star88,MrCat,OLE777,9bet,Webet138,TGame,FLC,Boma365,Sun988,webet88,Salon365,Senibet'

--Temporary variables for Licensee loop action
DECLARE @_RegisteredLicenseeName NVARCHAR(50)
DECLARE @_LicenseeName NVARCHAR(50)
DECLARE @_LicenseeStatusId TINYINT



--List of Licensees
CREATE TABLE #LicenseeLst (LicenseeName NVARCHAR(50)
							,RegisteredLicenseeName NVARCHAR(50)
							,LicenseeStatusId TINYINT
							,IsExecuted BIT DEFAULT(0)
							)
CREATE UNIQUE CLUSTERED INDEX IX_LicenseeName ON #LicenseeLst(LicenseeName)

--List of Agents under a Licensee
CREATE TABLE #AgentLst(LicenseeName NVARCHAR(50), RegisteredLicenseeName NVARCHAR(50), AgentID INT, AgentUserName VARCHAR(30),IsExecuted BIT DEFAULT(0) )

CREATE UNIQUE CLUSTERED INDEX IX_AgentID ON #AgentLst(AgentID)

DECLARE @XML XML
SET @XML = N'<root><r>' + REPLACE(@_LicenseeLst, ',', '</r><r>') + '</r></root>'

INSERT INTO #LicenseeLst(LicenseeName) 
SELECT r.value('.','NVARCHAR(50)')
FROM @xml.nodes('//root/r') AS RECORDS(r)


UPDATE main
SET main.RegisteredLicenseeName = l.RegisteredLicenseeName
, main.[LicenseeStatusId] = l.[LicenseeStatusId]
FROM #LicenseeLst main
INNER JOIN DBLIC.bodb_OIC.dbo.licensee l ON l.LicenseeName=main.LicenseeName


IF EXISTS(SELECT 1 FROM #LicenseeLst WHERE RegisteredLicenseeName IS NULL)
BEGIN
	RAISERROR('There are licensees with unidentified registered name.', 11, 1)
	
	RETURN
END

WHILE(EXISTS(SELECT 1 FROM #LicenseeLst WHERE IsExecuted=0))
BEGIN
	UPDATE TOP(1) main
	SET main.IsExecuted=1
		, @_RegisteredLicenseeName = main.RegisteredLicenseeName
		, @_LicenseeName = main.LicenseeName
		, @_LicenseeStatusId = main.LicenseeStatusId
	FROM #LicenseeLst main
	WHERE IsExecuted=0

	IF @_LicenseeStatusId = 4 --Terminated Licensee: Insert dummy accounts for UUS lines
	BEGIN
		INSERT INTO #AgentLst(LicenseeName,RegisteredLicenseeName,AgentID, AgentUserName)
		SELECT @_LicenseeName,@_RegisteredLicenseeName,custid,username
		FROM Customer ag(NOLOCK)
		WHERE roleid=2
		AND username NOT LIKE '%ACC%' 
		AND srecommend IN (
			SELECT CustID
			FROM Dep_CustSuper (NOLOCK)
			WHERE site = @_RegisteredLicenseeName
		)
		AND EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE recommend=ag.custid AND roleid=1)
	END
	ELSE
	BEGIN
		INSERT INTO #AgentLst(LicenseeName,RegisteredLicenseeName,AgentID, AgentUserName)
		SELECT @_LicenseeName,@_RegisteredLicenseeName,custid,username
		FROM Customer ag(NOLOCK)
		WHERE roleid=2
		AND username NOT LIKE '%ACC%' 
		AND currency NOT IN (20,27,28)
		AND srecommend IN (
			SELECT CustID
			FROM Dep_CustSuper (NOLOCK)
			WHERE site = @_RegisteredLicenseeName
		)
		AND EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE recommend=ag.custid AND roleid=1)
	END

	DELETE  ag 
	FROM #AgentLst ag
	WHERE EXISTS (SELECT 1 FROM Customer (NOLOCK) WHERE recommend=ag.AgentID AND roleid=1 AND username LIKE '%ClearBal')

END

------------------------------------------Step 2: Scan Customer------------------------------------------------------------
DECLARE
	 @minBalance MONEY = 0, 
	 @minDays INT = 365,
	 @CheckStatement_DaysPerBatch INT = 1,
	 @CheckBettrans_CustPerBatch INT = 2000

	SET NOCOUNT ON
	DECLARE @MinBettingDate DATETIME

	SET @MinBettingDate = DATEADD(dd, -@minDays, CAST(GETDATE() AS DATE))
	CREATE TABLE #Member 
	(
		custid int PRIMARY KEY, AgentID INT, username varchar(50), username2 varchar(50), memberBalance MONEY default 0, isProcessed INT default 0
	)

	CREATE TABLE #BettingMember 
	(
		custid INT
	)

	CREATE TABLE #tmpMember 
	(
		custid INT
	)

-- 1.Get infor of all customer in Customer and custinfo table
	INSERT INTO #Member (custid, AgentID, username, username2)
	SELECT cust.custid,ci.recommend, cust.username, cust.username2
	FROM customer cust WITH (NOLOCK)
	INNER JOIN custInfo ci (NOLOCK) ON cust.custid = ci.custid
	WHERE cust.roleid = 1
		AND cust.recommend  IN (SELECT AgentID FROM #AgentLst)
		AND (cust.creatdate < @MinBettingDate)
		AND cust.srecommend IN (SELECT custid FROM Dep_CustSuper (NOLOCK))
		AND ISNULL(BonusWalletFlag,0) = 0
		

	DELETE FROM #Member
	WHERE custid IN (SELECT custid FROM DBCUST.CustDB.dbo.Dep_Customer_Archived_Exception WITH (NOLOCK))
	-- Remove CustIDBalanceDummy out of the list betting member if exist
	-- Remove account like BetTrade and CashOut, ClearBal
	DELETE FROM #Member
	WHERE  username LIKE '%BetTrade%' OR username LIKE '%CashOut%' OR username LIKE '%ClearBal%'

	IF EXISTS(SELECT 1 FROM #Member)
	BEGIN
		-- 2. Get List Member have bet ticket in #Member table (can apply batch processing)
		-- Apply loop by date for bodb_Report.dbo.STATEMENT table

		DECLARE @fromDate_e DATETIME, @toDate_e DATETIME, @toDate DATETIME

		SET @fromDate_e = @MinBettingDate
		SET @toDate_e = DATEADD(DAY, @CheckStatement_DaysPerBatch, @fromDate_e)

		SET @toDate = CAST(GETDATE() AS DATE)
	
		IF @toDate_e > @toDate SELECT @toDate_e = @toDate
	
		WHILE @fromDate_e <= @toDate	
		BEGIN

			INSERT INTO #BettingMember (custid)	
			SELECT DISTINCT custid 
					FROM bodb_Report.dbo.STATEMENT st WITH  (NOLOCK, FORCESEEK)
					WHERE accDate >= @fromDate_e AND accDate < @toDate_e
					AND TransType <> N'bal' 
					AND st.custid IN ( SELECT custid 
										FROM #Member m)

			IF @toDate_e = @toDate
						BREAK;

			SELECT @fromDate_e = @toDate_e
			SELECT @toDate_e = DATEADD(DAY, @CheckStatement_DaysPerBatch, @fromDate_e)
			IF @toDate_e > @toDate SELECT @toDate_e = @toDate
			END
	
		DELETE FROM #Member
		WHERE custid IN (SELECT custid FROM #BettingMember)
		TRUNCATE TABLE #BettingMember

		WHILE(1=1)
		BEGIN
			TRUNCATE TABLE #tmpMember

			INSERT INTO #tmpMember
			SELECT TOP (@CheckBettrans_CustPerBatch) custid
			FROM #Member WHERE isProcessed = 0	
			IF (@@ROWCOUNT = 0) BREAK

			INSERT INTO #BettingMember (custid)
			SELECT custid 
			FROM #tmpMember m
			WHERE EXISTS (
					SELECT custid
					FROM bettrans b with (NOLOCK)
					WHERE bettype <> 20000 AND b.custid = m.custid
				)

			INSERT INTO #BettingMember (custid)
			SELECT custid 
			FROM #tmpMember m
			WHERE EXISTS (
				SELECT custid
				FROM translog b with (NOLOCK)
				WHERE b.custid = m.custid
				)

			INSERT INTO #BettingMember (custid)
			SELECT custid 
			FROM #tmpMember m
			where EXISTS (
				SELECT custid
				FROM bettransRNG b with (NOLOCK)
				WHERE b.custid = m.custid
				)
			
			INSERT INTO #BettingMember (custid)
			SELECT custid 
			FROM #tmpMember m
			WHERE EXISTS (
					SELECT custid
					FROM bettransLC b with (NOLOCK)
					WHERE b.custid = m.custid
				)

			UPDATE #Member
			SET isProcessed = 1
			WHERE custid IN (SELECT custid FROM #tmpMember)

		END
	
		DELETE FROM #Member
		WHERE custid IN (SELECT custid FROM #BettingMember)

	-- 3. Update balance of all member in #Member (can apply batch processing)

		WHILE(1=1)
		BEGIN
			TRUNCATE TABLE #tmpMember -- Reuse #tmpMember table for updating balance

			INSERT INTO #tmpMember
			SELECT TOP (@CheckBettrans_CustPerBatch) custid
			FROM #Member WHERE isProcessed = 1
			IF (@@ROWCOUNT = 0) BREAK

			UPDATE #Member SET memberBalance = b.MemberBalance
			FROM #Member
			INNER JOIN (
				SELECT custid, ISNULL(SUM(winlost-actual_stake+playercomm),0) as MemberBalance
				FROM bettrans WITH (NOLOCK)
				WHERE custid IN (SELECT custid FROM #tmpMember)
				GROUP BY custid
				) b ON #Member.custid = b.custid

			UPDATE #Member
			SET isProcessed = 2
			WHERE custid IN (SELECT custid FROM #tmpMember)

		END
	
	END

-- 4. Get member in #Member table and exclude Bettrade, CashOut account
SELECT ag.LicenseeName,ag.RegisteredLicenseeName
, COUNT(1) TotalDormantMember
, SUM(CASE WHEN m.memberBalance < 0 THEN 1 ELSE 0 END) NegativeBalance
, SUM(CASE WHEN m.memberBalance = 0 THEN 1 ELSE 0 END) ZeroBalance
, SUM(CASE WHEN m.memberBalance > 0 THEN 1 ELSE 0 END) PositiveBalance
FROM #Member m
INNER JOIN #AgentLst ag ON m.AgentID=ag.AgentID
WHERE memberBalance <= @minBalance
GROUP BY ag.LicenseeName,ag.RegisteredLicenseeName

/*
	DROP TABLE #tmpMember
	DROP TABLE #BettingMember
	DROP TABLE #Member
	DROP TABLE #LicenseeLst
	DROP TABLE #AgentLst
*/


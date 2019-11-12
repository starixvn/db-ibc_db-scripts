/*
	Run at: bodb02@DB06
	Task: Estimate dormant members for Say Hau 's reference
*/
USE bodb02
GO


------------------------------------------Step 1: Get a list of agents------------------------------------------------------------
--Comma separated string of licensee,e.g, 'KaiHao,12bet,W88'
DECLARE @_LicenseeLst VARCHAR(MAX)='mansion88,W88,HAIFA,XTD3,alog,12Bet,asiabet88,368Cash,Avia,Newhonbet,ISC888,GamingSoft,Macaubet,KeenOcean,HONBET,Bodog,365online,SunGame,Ty777,Dawoo,MayFair,IBO,BE7,TLC,AG,Liga,PKbet,Happy1668,Vwin,HuangMa,Aoncash,Ae88,Gampag,HonorW,Mayayule,Royal,Boying,KhmerG,iBET,Abcasino,Sunrise,9Club,Yibo,CGame,Webet138,ITCBet,MrCat,OLE777,3star88,K8VN,TGame,BETSUN,webet88,9bet,Sun988,FLC,Boma365,GMASTER,Bobo88,Salon365,IONclub,Senibet,BigGaming'

--Temporary variables for Licensee loop action
DECLARE @_RegisteredLicenseeName NVARCHAR(50)
DECLARE @_LicenseeName NVARCHAR(50)



--List of Licensees
CREATE TABLE #LicenseeLst (LicenseeName NVARCHAR(50)
							,RegisteredLicenseeName NVARCHAR(50)
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
SET main.RegisteredLicenseeName = main.LicenseeName
FROM #LicenseeLst main


WHILE(EXISTS(SELECT 1 FROM #LicenseeLst WHERE IsExecuted=0))
BEGIN
	UPDATE TOP(1) main
	SET main.IsExecuted=1
		, @_RegisteredLicenseeName = main.RegisteredLicenseeName
		, @_LicenseeName = main.LicenseeName
	FROM #LicenseeLst main
	WHERE IsExecuted=0

	INSERT INTO #AgentLst(LicenseeName,RegisteredLicenseeName,AgentID, AgentUserName)
		SELECT @_LicenseeName,@_RegisteredLicenseeName,custid,username
		FROM vw_Customer ag(NOLOCK)
		WHERE roleid=2
		AND username NOT LIKE '%ACC%' 
		AND currency NOT IN (20,27,28)
		AND srecommend IN (
			SELECT CustID
			FROM Dep_CustSuper (NOLOCK)
			WHERE site = @_RegisteredLicenseeName
		)
		AND EXISTS (SELECT 1 FROM vw_Customer (NOLOCK) WHERE recommend=ag.custid AND roleid=1)

END

------------------------------------------Step 2: Scan Customer------------------------------------------------------------
DECLARE @minDays INT = 1825, --5 years
	 @CheckStatement_DaysPerBatch INT = 100,
	 @CheckBettrans_CustPerBatch INT = 20000

	SET NOCOUNT ON
	DECLARE @MinBettingDate DATETIME

	SET @MinBettingDate = DATEADD(dd, -@minDays, CAST(GETDATE() AS DATE))
	CREATE TABLE #Member 
	(
		custid int PRIMARY KEY, AgentID INT, username varchar(50), username2 varchar(50), memberBalance MONEY default 0
		, isProcessed INT default 0
		, creatdate DATETIME
		--Nearest date having bet tickets
		, NearestActiveDate DATETIME NULL
	)

	CREATE TABLE #BettingMember 
	(
		custid INT
		--Nearest date having bet tickets
		, NearestActiveDate DATETIME NULL
	)

	CREATE TABLE #tmpMember 
	(
		custid INT
	)

-- 1.Get infor of all customer in Customer and custinfo table
	INSERT INTO #Member (custid, AgentID, username, username2, creatdate)
	SELECT cust.custid,ci.recommend, cust.username, cust.username2, cust.creatdate
	FROM vw_Customer cust WITH (NOLOCK)
	INNER JOIN custInfo ci (NOLOCK) ON cust.custid = ci.custid
	WHERE cust.roleid = 1
		AND cust.recommend  IN (SELECT AgentID FROM #AgentLst)
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

		DECLARE @fromDate_e DATETIME, @toDate_e DATETIME, @fromDate DATETIME

		SET @fromDate_e = @MinBettingDate
	
		SELECT  @toDate_e = CAST(GETDATE() AS DATE)

		SELECT @fromDate_e =  DATEADD(DAY, - @CheckStatement_DaysPerBatch, @toDate_e)
	
		WHILE @fromDate_e >= @MinBettingDate	
		BEGIN

			INSERT INTO #BettingMember (custid, NearestActiveDate)	
			SELECT st.Custid, MAX(accdate) NearestActiveDate
			FROM bodb_Report.dbo.STATEMENT st WITH  (NOLOCK, FORCESEEK)
			WHERE accDate > @fromDate_e AND accDate <= @toDate_e
			AND TransType <> N'bal' 
			AND st.custid IN (  
								SELECT custid 
								FROM #Member m
								WHERE NearestActiveDate IS NULL
							)
			GROUP BY st.Custid

			UPDATE main
			SET main.NearestActiveDate = b.NearestActiveDate
			FROM #Member main
			INNER JOIN #BettingMember b 
				ON main.custid = b.custid
			WHERE main.NearestActiveDate IS NULL


			TRUNCATE TABLE #BettingMember

			IF @fromDate_e = @MinBettingDate
						BREAK;

			SELECT @toDate_e = @fromDate_e
			SELECT @fromDate_e = DATEADD(DAY, -@CheckStatement_DaysPerBatch, @toDate_e)

			IF @fromDate_e < @MinBettingDate SELECT @fromDate_e = @MinBettingDate
		END
		

		WHILE(1=1)
		BEGIN
			TRUNCATE TABLE #tmpMember

			INSERT INTO #tmpMember
			SELECT TOP (@CheckBettrans_CustPerBatch) custid
			FROM #Member 
			WHERE isProcessed = 0	
				AND NearestActiveDate IS NULL

			IF (@@ROWCOUNT = 0) BREAK

			INSERT INTO #BettingMember (custid, NearestActiveDate)
			SELECT custid,MAX(transdate)
			FROM bettrans b with (NOLOCK)
			WHERE bettype <> 20000 
			AND b.custid IN (
					SELECT custid 
					FROM #tmpMember
			)
			GROUP BY custid

			INSERT INTO #BettingMember (custid, NearestActiveDate)
			SELECT custid,MAX(transdate)
			FROM translog b with (NOLOCK)
			WHERE b.custid IN (
					SELECT custid 
					FROM #tmpMember
			)
			GROUP BY custid

			INSERT INTO #BettingMember (custid, NearestActiveDate)
			SELECT custid,MAX(transdate)
			FROM bettransRNG b with (NOLOCK)
			WHERE b.custid IN (
					SELECT custid 
					FROM #tmpMember
			)
			GROUP BY custid
			
			INSERT INTO #BettingMember (custid, NearestActiveDate)
			SELECT custid,MAX(transdate)
			FROM bettransLC b with (NOLOCK)
			WHERE b.custid IN (
					SELECT custid 
					FROM #tmpMember
			)
			GROUP BY custid


			UPDATE #Member
			SET isProcessed = 1
			WHERE custid IN (SELECT custid FROM #tmpMember)

			UPDATE main
			SET main.NearestActiveDate = b.NearestActiveDate
			FROM #Member main
			INNER JOIN (
				SELECT CustID, MAX(NearestActiveDate) NearestActiveDate
				FROM #BettingMember 
				GROUP BY CustID
			) b
				ON main.custid = b.custid
			WHERE main.NearestActiveDate IS NULL

			TRUNCATE TABLE #BettingMember
		END

		UPDATE #Member
		SET isProcessed = 1

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
--Not have tickets for last 365*@year days
DECLARE @year TINYINT = 1

WHILE @year <= 5
BEGIN
	SELECT @year

	SELECT ag.LicenseeName,ag.RegisteredLicenseeName
	, COUNT(1) TotalDormantMember
	, SUM(CASE WHEN m.memberBalance < 0 THEN 1 ELSE 0 END) NegativeBalance
	, SUM(CASE WHEN m.memberBalance = 0 THEN 1 ELSE 0 END) ZeroBalance
	, SUM(CASE WHEN m.memberBalance > 0 THEN 1 ELSE 0 END) PositiveBalance
	FROM #Member m
	INNER JOIN #AgentLst ag ON m.AgentID=ag.AgentID
	AND (
		NearestActiveDate IS NULL 
		OR NearestActiveDate NOT BETWEEN DATEADD(DAY,-365 * @year,GETDATE()) AND GETDATE()
	)
	AND m.creatdate < DATEADD(DAY,-365 * @year,GETDATE())
	GROUP BY ag.LicenseeName,ag.RegisteredLicenseeName

	SELECT @year = @year + 1
END

/*
DROP TABLE #tmpMember
DROP TABLE #BettingMember
DROP TABLE #Member
DROP TABLE #LicenseeLst
DROP TABLE #AgentLst
*/



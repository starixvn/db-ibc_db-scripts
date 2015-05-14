
/*	Createdby: Jamie 
	Task: Synchronize historical data
*/
/*	1. DBPRO.bodb02.dbo.match */

CREATE TABLE #tmpMatch(
	 MatchID		INT
	,Betstatus		NVARCHAR(50)
	,HomeValue		VARCHAR(50)
)

INSERT INTO #tmpMatch(MatchID,Betstatus,HomeValue)
SELECT	MatchID, Betstatus, CASE WHEN betstatus LIKE '%PS:N%' THEN 'N'
								 WHEN betstatus LIKE '%PS:Y%' THEN 'Y'
								 ELSE ''
								 END AS HomeValue
FROM	bodb02.dbo.Match m WITH (NOLOCK)
WHERE	Sporttype = 1 
		AND eventstatus ='completed'
		AND betstatus LIKE '%PS:%'
		AND NOT EXISTS(SELECT MatchID FROM bodb02.dbo.ResultDetail r WITH (NOLOCK) WHERE r.MatcHID = m.MatcHID AND r.ResourceId ='135')

INSERT INTO bodb02.dbo.ResultDetail(				 
				 MatchID
				,ResourceID
				,HomeValue
				,AwayValue
				,OtherInfo 
				,ResultStatusID
				,SettlementStatusID
				,CreateBy
				,CreateDate
				,LastModifyBy
				,LastModifyDate)
SELECT	tm.MatchID
		,'135'
		,tm.HomeValue
		,NULL 
		,NULL
		,CASE WHEN ISNULL(rm.SettlementStatus135,0) IN (2,4) THEN 2 
			  WHEN ISNULL(rm.SettlementStatus135,0) = 3 THEN 5
			  ELSE 0 END 
		,4
		,111
		,GETDATE()
		,111
		,GETDATE() 
FROM	#tmpMatch tm WITH (NOLOCK)
		LEFT JOIN bodb02.dbo.match_remark rm WITH (NOLOCK) ON tm.MatchID = rm.matchid 

DROP TABLE #tmpMatch

/*	2. DBPRO.bodb02.dbo.match14 */

CREATE TABLE #tmpMatch14(
	 MatchID		INT
	,Betstatus		NVARCHAR(50)
	,HomeValue		VARCHAR(50)
)

INSERT INTO #tmpMatch14(MatchID,Betstatus,HomeValue)
SELECT	MatchID, Betstatus, CASE WHEN betstatus LIKE '%PS:N%' THEN 'N'
								 WHEN betstatus LIKE '%PS:Y%' THEN 'Y'
								 ELSE ''
								 END AS HomeValue
FROM	bodb02.dbo.Match14 m WITH (NOLOCK)
WHERE	Sporttype = 1 
		AND eventstatus ='completed'
		AND betstatus LIKE '%PS:%'
		AND NOT EXISTS(SELECT MatchID FROM bodb02.dbo.ResultDetail14 r WITH (NOLOCK) WHERE r.MatcHID = m.MatcHID AND r.ResourceId ='135')

INSERT INTO bodb02.dbo.ResultDetail14(				 
				 MatchID
				,ResourceID
				,HomeValue
				,AwayValue
				,OtherInfo 
				,ResultStatusID
				,SettlementStatusID
				,CreateBy
				,CreateDate
				,LastModifyBy
				,LastModifyDate)
SELECT	tm.MatchID
		,'135'
		,tm.HomeValue
		,NULL 
		,NULL
		,2 
		,4
		,111
		,GETDATE()
		,111
		,GETDATE() 
FROM	#tmpMatch14 tm WITH (NOLOCK)

DROP TABLE #tmpMatch14

/*	2. DBARC.bodb_archive.dbo.match_BK */

CREATE TABLE #tmpMatch_BK(
	 MatchID		INT
	,Betstatus		NVARCHAR(50)
	,HomeValue		VARCHAR(50)
)

INSERT INTO #tmpMatch_BK(MatchID,Betstatus,HomeValue)
SELECT	MatchID, Betstatus, CASE WHEN betstatus LIKE '%PS:N%' THEN 'N'
								 WHEN betstatus LIKE '%PS:Y%' THEN 'Y'
								 ELSE ''
								 END AS HomeValue
FROM	bodb_Archive.dbo.Match_bk m WITH (NOLOCK)
WHERE	Sporttype = 1 
		AND eventstatus ='completed'
		AND betstatus LIKE '%PS:%'
		AND eventdate >='2014-08-01' --Offer Date 


INSERT INTO bodb_Archive.dbo.ResultDetail_BK(				 
				 MatchID
				,ResourceID
				,HomeValue
				,AwayValue
				,OtherInfo 
				,ResultStatusID
				,SettlementStatusID
				,CreateBy
				,CreateDate
				,LastModifyBy
				,LastModifyDate)
SELECT	tm.MatchID
		,'135'
		,tm.HomeValue
		,NULL 
		,NULL
		,2 
		,4
		,111
		,GETDATE()
		,111
		,GETDATE() 
FROM	#tmpMatch_BK tm WITH (NOLOCK)

DROP TABLE #tmpMatch_BK

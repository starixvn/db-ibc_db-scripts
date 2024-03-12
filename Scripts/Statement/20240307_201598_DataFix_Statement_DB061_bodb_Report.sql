/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
Create: 20240307@Lewis
Task: Database - Archive DB has missed a ticket after Thursday routine  [RedmineID: #201598]
DB: DBRPT-bodb_Report

Description:
*/

USE bodb_report

DECLARE 
	@custid INT = 54846016
	,@agent INT = 6630793
	,@master INT = 6630783
	,@super INT = 6630778
	,@date DATETIME = '20230129'

CREATE TABLE #temp_data(
	custid int
	,accdate datetime
	,totalamt money
	,transtype nvarchar(50)
	,transdesc nvarchar(300)
)

CREATE TABLE #temp_statement(
	custid int
	,accdate datetime
	,totalamt money
	,transtype nvarchar(50)
	,transdesc nvarchar(300)
)

INSERT INTO #temp_data(
	custid
	,accdate 
	,totalamt
	,transtype
	,transdesc
)
--member
        SELECT custid,winlostdate accdate,SUM(winlost-actual_stake) totalamt,CAST('BET' AS varchar(128)) transtype, CAST('Betting' AS varchar(1000)) AS transdesc
        FROM bodb_Archive.dbo.bettrans_bk bettrans WITH (NOLOCK)
        WHERE winlostdate = @date and custid = @custid
        GROUP BY winlostdate,custid
        HAVING SUM(winlost-actual_stake) <> 0
    UNION ALL
        SELECT custid,winlostdate accdate,SUM(playercomm) totalamt,'COM' transtype, 'Commission' transdesc
        FROM bodb_Archive.dbo.bettrans_bk bettrans  WITH (NOLOCK)
        WHERE winlostdate = @date and custid = @custid
        GROUP BY winlostdate,custid
        HAVING SUM(playercomm) <> 0
    UNION ALL       
--agent
        SELECT recommend,winlostdate accdate,SUM(awinlost) totalamt,'POS' transtype, 'Position' transdesc
        FROM bodb_Archive.dbo.bettrans_bk bettrans WITH (NOLOCK)
        WHERE winlostdate = @date and recommend = @agent
        GROUP BY winlostdate,recommend
        HAVING SUM(awinlost) <> 0
    UNION ALL
        SELECT recommend,winlostdate accdate,SUM(comm-playercomm) totalamt,'COM' transtype, 'Commission' transdesc
        FROM bodb_Archive.dbo.bettrans_bk bettrans  WITH (NOLOCK)
        WHERE winlostdate = @date and recommend = @agent
        GROUP BY winlostdate,recommend
        HAVING SUM(comm-playercomm) <> 0
    UNION ALL
--master
        SELECT mrecommend,winlostdate accdate,SUM(mwinlost) totalamt,'POS' transtype, 'Position' transdesc
        FROM bodb_Archive.dbo.bettrans_bk bettrans WITH (NOLOCK)
        WHERE winlostdate = @date and mrecommend = @master
        GROUP BY winlostdate,mrecommend
        HAVING SUM(mwinlost) <> 0
    UNION ALL
        SELECT mrecommend,winlostdate accdate,SUM(acomm-comm) totalamt,'COM' transtype, 'Commission' transdesc
        FROM bodb_Archive.dbo.bettrans_bk bettrans WITH (NOLOCK)
        WHERE winlostdate = @date and mrecommend = @master
        GROUP BY winlostdate,mrecommend
        HAVING SUM(acomm-comm) <> 0
    UNION ALL
--super
        SELECT srecommend,winlostdate accdate,SUM(swinlost) totalamt,'POS' transtype, 'Position' transdesc
        FROM bodb_Archive.dbo.bettrans_bk bettrans WITH (NOLOCK)
        WHERE winlostdate = @date and srecommend = @super
        GROUP BY winlostdate,srecommend
        HAVING SUM(swinlost) <> 0
    UNION ALL
        SELECT srecommend,winlostdate accdate,SUM(scomm-acomm) totalamt,'COM' transtype, 'Commission' transdesc
        FROM bodb_Archive.dbo.bettrans_bk bettrans WITH (NOLOCK)
        WHERE winlostdate = @date and srecommend = @super
        GROUP BY winlostdate,srecommend
        HAVING SUM(scomm-acomm) <> 0
		

INSERT INTO #temp_statement(
	custid
	,accdate 
	,totalamt
	,transtype
	,transdesc
)
SELECT custid
	,accdate
	,totalamt
	,transtype
	,transdesc
FROM statement WITH (NOLOCK) 
WHERE custid IN (@custid,@agent,@master,@super) 
	AND accdate = @date

IF EXISTS (
			SELECT TOP 1 1 
			FROM #temp_data a
			FULL OUTER JOIN #temp_statement b
				ON  a.custid = b.custid
				AND a.accdate = b.accdate
				AND a.transtype = b.transtype
			WHERE a.totalamt <> b.totalamt
				OR a.transdesc <> b.transdesc
				OR a.transtype IS NULL OR b.transtype  IS NULL
				OR a.custid IS NULL OR b.custid  IS NULL
				OR a.accdate IS NULL OR b.accdate  IS NULL 
			)
BEGIN 

	INSERT INTO statement (custid,accdate,totalamt,transtype,transdesc)
	SELECT custid,accdate,totalamt,transtype,transdesc FROM #temp_data

	DELETE A
	FROM Statement A
	INNER JOIN #temp_statement B
		ON A.custid = B.custid
		AND A.accdate = B.accdate
		AND A.totalamt = B.totalamt
		AND A.transtype = B.transtype
		AND A.transdesc = B.transdesc

END

DROP TABLE #temp_data
DROP TABLE #temp_statement
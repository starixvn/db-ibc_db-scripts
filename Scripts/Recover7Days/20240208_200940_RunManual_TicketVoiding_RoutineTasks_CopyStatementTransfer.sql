 /*<info serverAlias="DBACC-bodb02"></info>*/
/*
	Create: 20240208@Sophia
	Task: copy data of transfer Statement by manual void ticket [Redmine: #200940] 
	DB: DBACC-bodb02
*/ 
 
 
INSERT INTO bodb_Report.dbo.Statement (custid,accdate, totalamt,transtype,transdesc )

	SELECT	t.CustId AS custid
			,t.TransDate AS accdate
			,SUM(t.winlost - t.actual_stake) AS totalamt
			,CASE WHEN ti.IsCollection = 1 THEN CONVERT(NVARCHAR(128), 'COLL') ELSE bt.typenamee END AS transtype
			,TransDesc AS transdesc
	FROM	dbo.Transfer t WITH(ROWLOCK)
		LEFT JOIN dbo.TransferInfo ti WITH(NOLOCK)
			ON t.TransId = ti.TransId
		INNER JOIN dbo.bettype bt WITH(NOLOCK)
			ON t.Bettype = bt.typeid
	WHERE	t.WinlostDate IN ('20240129','20240130','20240131', '20240201')
			AND TransDate >= '20240208'
			AND	t.bettype IN (21001, 21002)
			AND custid IN 
				(select CustID from Acc_DWLList 
				 union 
				 select CustID from Acc_DWLList_ExtraPT where IsDisabled = 0 )
	GROUP BY t.CustId, t.TransDesc, t.TransDate, t.TransId
		,CASE WHEN ti.IsCollection = 1 THEN CONVERT(NVARCHAR(128), 'COLL') ELSE bt.typenamee END
	HAVING SUM(t.winlost - t.actual_stake) <> 0;
 /*<info serverAlias="DBSID-bodb02,DBCTG-bodb02"></info>*/
 /*
	Creator: 20250204@Sophia
 	DB: DBSID-bodb02,DBCTG-bodb02
 	Task : Update virtualRate [redmine #217447]
 	 
	
*/	
			
		UPDATE b WITH(ROWLOCK, UPDLOCK)
		SET	b.virtualrate = 0.001682 
		FROM bettrans14 b
		WHERE TransID IN (348180792393859119,348180474566279187,348173735766786048)
			 
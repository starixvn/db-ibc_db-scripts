/*<info serverAlias="DBTXN-bodb02" step="1"></info>*/
Use bodb02

/*
Create: 20200728@Sophia
DB : DBTXN-bodb02
Task: Update Transfer Ticket of HKK by wrong actual_stake [Redmine: #136631]

*/

-------------------Step 1--------------------

UPDATE 	b
SET	 	WinlostDate = '2020-07-26',
		ActualRate = CASE WHEN Currency = 67 THEn 0.4 ELSE ActualRate END
FROM 	Bettrans b WITH (ROWLOCK)
WHERE 	RefNo IN (200437196019,200437299372,200437299421)
		AND b.Bettype = 21003 
		AND b.Winlostdate = '2020-07-27'



-------------------Step 2: All --------------------
SELECT 	SUM( (Winlost- actual_Stake)* actualrate) as balance, refno
INTO 	#Refno 
FROM 	Bettrans WITH (NOLOCK) 
WHERE 	Bettype = 21003 
		AND Winlostdate = '2020-07-27'
		AND Currency IN (2,67)
GROUP BY RefNo 
HAVING SUM((Winlost- actual_Stake) * actualrate ) <> 0
AND COUNT (Currency) = 2  


UPDATE b
SET	 WinlostDate = '2020-07-26',
	 ActualRate = CASE WHEN Currency = 67 THEn 0.4 ELSE ActualRate END
FROM Bettrans b WITH (ROWLOCK)
INNER JOIN #Refno R 
	ON R.RefNo = b.Refno
WHERE b.Bettype = 21003 and b.Winlostdate = '2020-07-27'
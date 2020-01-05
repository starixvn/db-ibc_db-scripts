/*
	Created: 20200105@Helen
	Task: update winlost and comm for master
	DB: DBTXN/bodb02
*/
USE bodb02
GO
DECLARE @tempTrans TABLE (TransID BIGINT, isDecimalOdd BIT, srecommend INT, bettype SMALLINT, isCN88 BIT, isMajorGroup BIT)
DECLARE  @commWinRate		SMALLMONEY
		,@commLostRate		SMALLMONEY
		,@commHalfWLRate	SMALLMONEY
		,@odds				SMALLMONEY
		,@winlost			MONEY
		,@stake				MONEY
		,@m_PT				SMALLMONEY

INSERT INTO @tempTrans(TransID, isDecimalOdd, srecommend, bettype)
SELECT t.TransID, CASE WHEN ot.oddstype = 1 THEN 1 ELSE 0 END AS isDecimalOdd, srecommend, bt.bettype
FROM Viet_C8_CorrectPT_20200105 t WITH (NOLOCK)
	INNER LOOP JOIN dbo.bettrans bt	WITH (NOLOCK) ON bt.transid = t.transid
	LEFT JOIN dbo.f_Set_OddsTypeBettypes() AS ot ON ot.bettype = bt.bettype
WHERE bt.statuswinlost IS NOT NULL
	 
-- update if bettype belongs to the CN88 site or not
UPDATE tmp
  SET	isCN88 = CASE WHEN cs.CustId IS NULL THEN 0 ELSE 1 END,
		isMajorGroup = CASE WHEN f.CommBettypeGroupId IS NOT NULL AND f.CommBettypeGroupId = 1 THEN 1 ELSE 0 END
FROM   @tempTrans tmp
		   LEFT JOIN dbo.CS_CustSuper cs WITH(NOLOCK)
			   ON tmp.srecommend = cs.CustId
			LEFT JOIN dbo.f_Set_GetGroupBettypes() AS f
				ON tmp.bettype = f.BetType

UPDATE  b
	SET 
	   @commWinRate = CASE comstatus -- 0 : pay normal, both win/lost -- 1 : pay 'double' ONLY on lost
							WHEN '0' THEN 1
							WHEN '1' THEN 0
							ELSE 1 END
	   ,@commLostRate = CASE comstatus
							WHEN '0' THEN 1
							WHEN '1' THEN 2
							ELSE 1 END
	   ,@commHalfWLRate = CASE WHEN sr.isCN88 = 1 AND sr.isMajorGroup = 1 THEN 1
							ELSE 0.5
						END
	   ,@odds = CASE WHEN b.bettype IN (468,469) THEN b.odds
						 ELSE (CASE WHEN b.odds < 0 THEN 1 
   									WHEN sr.isDecimalOdd = 1 THEN b.odds - 1 ----/*DECIMAL ONLY*/
									ELSE b.odds 
								END)
				END
		----------------------------------------------------------------------------------------------------------------
		,@winlost = CASE 
						WHEN b.bettype IN (468,469) THEN CASE 
															WHEN statuswinlost IN (2,4) THEN actual_stake + stake * @odds
															WHEN statuswinlost = 0 THEN actual_stake 
														  END	
						ELSE
						CASE
							WHEN statuswinlost = 2 THEN actual_stake + stake * @odds
							WHEN statuswinlost = 1 THEN actual_stake + stake * @odds * 0.5
							WHEN statuswinlost IN (0,6) THEN actual_stake
							WHEN statuswinlost = 3 THEN actual_stake * 0.5
							WHEN statuswinlost = 4 THEN 0
						END 
					END		
		-- check if bettype belongs to major comm group (CommBettypeGroupId = 1) and calc comm with new formula
		,@stake = CASE WHEN sr.isCN88 = 1 AND sr.isMajorGroup = 1 THEN ABS(@winlost - actual_stake)
						ELSE stake 
				  END
		-- check winlost or status change to update SettlementTime
		,mWinLost = CASE 
						WHEN b.bettype IN (468,469) THEN CASE 
															WHEN statuswinlost IN (2,4) THEN stake * @odds * -mpositiontaking
															WHEN statuswinlost = 0 THEN 0 
														  END	
						ELSE
						CASE
							WHEN statuswinlost = 2 THEN stake * @odds * -mpositiontaking
							WHEN statuswinlost = 1 THEN stake * @odds * -mpositiontaking * 0.5
							WHEN statuswinlost IN (0,6)	THEN 0
							WHEN statuswinlost = 3 THEN actual_stake * mpositiontaking * 0.5
							WHEN statuswinlost = 4 THEN actual_stake * mpositiontaking
						END
					END
					
		,aComm = CASE 
					WHEN b.bettype IN (468,469) THEN CASE 
														WHEN statuswinlost = 2 THEN @commWinRate * adiscount * @stake * (1 - (mpositiontaking + apositiontaking))
														WHEN statuswinlost = 4 THEN @commLostRate * adiscount * @stake * (1 - (mpositiontaking + apositiontaking))
														WHEN statuswinlost = 0 THEN 0 
													  END	
					ELSE 
					CASE
						WHEN statuswinlost = 2 THEN @commWinRate * adiscount * @stake * (1-(mpositiontaking+apositiontaking))
						WHEN statuswinlost = 1 THEN @commWinRate * adiscount * @stake * (1-(mpositiontaking+apositiontaking)) * @commHalfWLRate
						WHEN statuswinlost IN (0,6)	THEN 0
						WHEN statuswinlost = 3 THEN @commLostRate * adiscount * @stake * (1-(mpositiontaking+apositiontaking)) * @commHalfWLRate
						WHEN statuswinlost = 4 THEN @commLostRate * adiscount * @stake * (1-(mpositiontaking+apositiontaking))
					END
				END		
		,sComm = CASE 
			WHEN b.bettype IN (468,469) THEN CASE 
												WHEN statuswinlost = 2 THEN @commWinRate * sdiscount * @stake * (1 - (spositiontaking + mpositiontaking + apositiontaking))
												WHEN statuswinlost = 4 THEN @commLostRate * sdiscount * @stake * (1 - (spositiontaking + mpositiontaking + apositiontaking))
												WHEN statuswinlost = 0 THEN 0 
											  END	
			ELSE 
			CASE
				WHEN statuswinlost = 2 THEN @commWinRate * sdiscount * @stake * (1-(spositiontaking+mpositiontaking+apositiontaking))
				WHEN statuswinlost = 1 THEN @commWinRate * sdiscount * @stake * (1-(spositiontaking+mpositiontaking+apositiontaking)) * @commHalfWLRate
				WHEN statuswinlost IN (0,6)	THEN 0
				WHEN statuswinlost = 3 THEN @commLostRate * sdiscount * @stake * (1-(spositiontaking+mpositiontaking+apositiontaking)) * @commHalfWLRate
				WHEN statuswinlost = 4 THEN @commLostRate * sdiscount * @stake * (1-(spositiontaking+mpositiontaking+apositiontaking))
			END
		END	
FROM @tempTrans sr
	INNER JOIN dbo.bettrans b  WITH (ROWLOCK, UPDLOCK) ON  sr.transid = b.transid

GO	
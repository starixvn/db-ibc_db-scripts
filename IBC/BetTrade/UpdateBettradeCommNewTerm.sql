  /*
	Created: 20160805Winnie
	Task : Bettrade Apply new business terms
	DB: DBCust/CustDB		
*/
  
  UPDATE [BetTradeComm]
  SET BetTradeComm=0.03,Licenseecomm=0.03,HouseDeductionRate=0.015,HousePT=0.5
  WHERE IsBA=0 AND (HouseDeductionRate IS NULL OR HousePT IS NULL)
  
  UPDATE [BetTradeComm]
  SET BetTradeComm=0.03,Licenseecomm=0,HouseDeductionRate=0.015,HousePT=0.5
  WHERE IsBA=1 AND (HouseDeductionRate IS NULL OR HousePT IS NULL)
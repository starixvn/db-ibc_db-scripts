 USE BODB_TGRS

 UPDATE TraderPerFormance 
 SET Spread = Spread / 100
 WHERE Spread IS NOT NULL 
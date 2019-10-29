Use bodb02
GO 
/*
Created: 20190826@Sophia
Task: Auto add TXN for Headline balance - add bettype 21007 #117863 
DB: DBPRO.bodb02
*/
INSERT INTO  bettype  (TypeId,TypeNamee,TypeNamec, typedesc, typenamec_uni , ParentTypeid ) VALUES (21007,N'HLTRA',N'HLTRA', N'Daily Auto transfer for CN88 Headline', N'HLTRA', 21007)


 
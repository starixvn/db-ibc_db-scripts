--Run on DBTXN
USE bodb02
GO

INSERT INTO Sport_Bettype_Reference (Bettype, Sporttype, isLicensee, BettypeRef, SporttypeRef, isActive)
SELECT 801, 1, 0, 1, 1, 1
UNION ALL
SELECT 803, 1, 0, 1, 1, 1
UNION ALL
SELECT 804, 1, 0, 1, 1, 1
UNION ALL
SELECT 805, 1, 0, 1, 1, 1
UNION ALL
SELECT 806, 1, 0, 1, 1, 1
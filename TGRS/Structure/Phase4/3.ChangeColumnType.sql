 USE BODB_TGRS

ALTER TABLE Benchmark_SpecialSetting
ALTER COLUMN Spread MONEY 

UPDATE Benchmark_SpecialSetting
SET Spread = Spread/100, BenchMark = BenchMark/100
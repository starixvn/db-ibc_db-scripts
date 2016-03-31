
USE [bodb_TGRS]
GO

/****** Object:  Index [PK_Benchmark_SpecialSetting]    Script Date: 3/31/2016 10:37:54 AM ******/
ALTER TABLE [dbo].[Benchmark_SpecialSetting] DROP CONSTRAINT [PK_Benchmark_SpecialSetting]
GO



ALTER TABLE Benchmark_SpecialSetting
ALTER COLUMN Spread MONEY NOT NULL


/****** Object:  Index [PK_Benchmark_SpecialSetting]    Script Date: 3/31/2016 10:38:04 AM ******/
ALTER TABLE [dbo].[Benchmark_SpecialSetting] ADD  CONSTRAINT [PK_Benchmark_SpecialSetting] PRIMARY KEY CLUSTERED 
(
	[Spread] ASC,
	[Rate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO



UPDATE Benchmark_SpecialSetting
SET Spread = Spread/100, BenchMark = BenchMark/100

 
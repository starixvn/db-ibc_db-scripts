/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20220613@Evan
	DB: DB053-bodb_LicenseeReport
	Task: New table rptLicenseeWinloss [Redmine: #172604]
	Step 1: New file group & partition by month
*/

USE bodb_LicenseeReport
GO

DECLARE @MinPartitionRange DATETIME, @MaxPartitionRange DATETIME
	, @Temp DATETIME, @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255), @PathFile2 VARCHAR(255)

SELECT	@MinPartitionRange = '2019-01-31'
	,@MaxPartitionRange = '2022-12-31'
	,@PathFile = 'E:\IBC_DB\bodb_LicenseeReport\rptLicenseeWinloss\'
	,@PathFile2 = 'D:\IBC_DB\bodb_LicenseeReport\rptLicenseeWinloss\'
	,@Prefix = 'rptLicenseeWinloss'
SET	@Temp = @MinPartitionRange

WHILE @MaxPartitionRange > @MinPartitionRange
BEGIN
	SELECT @Temp = DATEADD(MINUTE, - 1, DATEADD(mm, DATEDIFF(m, 0, @MinPartitionRange) + 1, 0))
	SET @SqlCmd = ''
	SELECT @FileGroupName = @Prefix + '_' + CAST(RIGHT(YEAR(@Temp), 2) AS VARCHAR(2)) 
								+ 'M' + CAST(RIGHT('00' + CAST(MONTH(@Temp) AS VARCHAR(2)), 2) AS VARCHAR(2))

	--create file group
	SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
	--PRINT @SqlCmd
	EXEC (@SqlCmd)

	--assign file group
	SET @SqlCmd = ''
	SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
			+ ''', FILENAME = N''' + CASE WHEN MONTH(@Temp) % 2 = 0 THEN @PathFile ELSE @PathFile2 END + @FileGroupName + '.ndf''
			, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
	--PRINT @SqlCmd
	EXEC (@SqlCmd)
	
	SET @MinPartitionRange = DATEADD(MM, 1, @MinPartitionRange)
END

--create max group file
SET @FileGroupName = @Prefix + '_MAX'
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
--PRINT @SqlCmd
EXEC (@SqlCmd)

SET @SqlCmd = ''
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
	+ ''', FILENAME = N''' + @PathFile + @FileGroupName + '.ndf''
	, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
--PRINT @SqlCmd
EXEC (@SqlCmd)

--create parrtition function
CREATE PARTITION FUNCTION [PF_rptLicenseeWinloss_Monthly](smalldatetime) AS RANGE LEFT FOR VALUES (
N'2019-01-31T23:59:00.000',N'2019-02-28T23:59:00.000',N'2019-03-31T23:59:00.000',N'2019-04-30T23:59:00.000',N'2019-05-31T23:59:00.000',N'2019-06-30T23:59:00.000',N'2019-07-31T23:59:00.000',N'2019-08-31T23:59:00.000',N'2019-09-30T23:59:00.000',N'2019-10-31T23:59:00.000',N'2019-11-30T23:59:00.000',N'2019-12-31T23:59:00.000',N'2020-01-31T23:59:00.000',N'2020-02-28T23:59:00.000',N'2020-03-31T23:59:00.000',N'2020-04-30T23:59:00.000',N'2020-05-31T23:59:00.000',N'2020-06-30T23:59:00.000',N'2020-07-31T23:59:00.000',N'2020-08-31T23:59:00.000',N'2020-09-30T23:59:00.000',N'2020-10-31T23:59:00.000',N'2020-11-30T23:59:00.000',N'2020-12-31T23:59:00.000',N'2021-01-31T23:59:00.000',N'2021-02-28T23:59:00.000',N'2021-03-31T23:59:00.000',N'2021-04-30T23:59:00.000',N'2021-05-31T23:59:00.000',N'2021-06-30T23:59:00.000',N'2021-07-31T23:59:00.000',N'2021-08-31T23:59:00.000',N'2021-09-30T23:59:00.000',N'2021-10-31T23:59:00.000',N'2021-11-30T23:59:00.000',N'2021-12-31T23:59:00.000',N'2022-01-31T23:59:00.000',N'2022-02-28T23:59:00.000',N'2022-03-31T23:59:00.000',N'2022-04-30T23:59:00.000',N'2022-05-31T23:59:00.000',N'2022-06-30T23:59:00.000',N'2022-07-31T23:59:00.000',N'2022-08-31T23:59:00.000',N'2022-09-30T23:59:00.000',N'2022-10-31T23:59:00.000',N'2022-11-30T23:59:00.000',N'2022-12-31T23:59:00.000')
GO

--create partition schema
CREATE PARTITION SCHEME [PS_rptLicenseeWinloss_Monthly] AS PARTITION [PF_rptLicenseeWinloss_Monthly] 
TO (rptLicenseeWinloss_19M01,rptLicenseeWinloss_19M02,rptLicenseeWinloss_19M03,rptLicenseeWinloss_19M04,rptLicenseeWinloss_19M05,rptLicenseeWinloss_19M06,rptLicenseeWinloss_19M07,rptLicenseeWinloss_19M08,rptLicenseeWinloss_19M09,rptLicenseeWinloss_19M10,rptLicenseeWinloss_19M11,rptLicenseeWinloss_19M12,rptLicenseeWinloss_20M01,rptLicenseeWinloss_20M02,rptLicenseeWinloss_20M03,rptLicenseeWinloss_20M04,rptLicenseeWinloss_20M05,rptLicenseeWinloss_20M06,rptLicenseeWinloss_20M07,rptLicenseeWinloss_20M08,rptLicenseeWinloss_20M09,rptLicenseeWinloss_20M10,rptLicenseeWinloss_20M11,rptLicenseeWinloss_20M12,rptLicenseeWinloss_21M01,rptLicenseeWinloss_21M02,rptLicenseeWinloss_21M03,rptLicenseeWinloss_21M04,rptLicenseeWinloss_21M05,rptLicenseeWinloss_21M06,rptLicenseeWinloss_21M07,rptLicenseeWinloss_21M08,rptLicenseeWinloss_21M09,rptLicenseeWinloss_21M10,rptLicenseeWinloss_21M11,rptLicenseeWinloss_21M12,rptLicenseeWinloss_22M01,rptLicenseeWinloss_22M02,rptLicenseeWinloss_22M03,rptLicenseeWinloss_22M04,rptLicenseeWinloss_22M05,rptLicenseeWinloss_22M06,rptLicenseeWinloss_22M07,rptLicenseeWinloss_22M08,rptLicenseeWinloss_22M09,rptLicenseeWinloss_22M10,rptLicenseeWinloss_22M11,rptLicenseeWinloss_22M12,rptLicenseeWinloss_MAX)
GO
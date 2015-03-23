-- archive history for device, kepp only max 5 recent profile 
-- 

select id, count(1)  c
into #tmp
from device (nolock)
group by id
having count(1)>5


SELECT [Increment]
      ,[Id]
      ,[Code]
      ,[Navigator]
      ,[UID]
      ,[Screen]
      ,[Timezone]
      ,[Plugins]
      ,[FontS]
      ,[FontF]
      ,[IdRef]
      ,[CreatedDate]
	  ,[Monitor]
	  ,[SystemTimeOffset]
	  ,[SystemF]
	  ,[SystemS]
	  ,[GPUCode]
INTO #tmp_Device
--select count(1)
FROM (
	select *, ROW_NUMBER() over (partition by  ID order by Increment desc) rn
	
	from Device (nolock)
	where id IN (select id from #tmp)
	) A 
WHERE A.rn>5

--SELECT COUNT(1) FROM #tmp_Device
--select top 10 * FROM #tmp_Device

create table #deviceProcessing 
	(Increment bigint, id nvarchar(50), code nvarchar(41),
	[Navigator] [nvarchar](41) NULL,
	[UID] [varchar](41) NULL,
	[Screen] [nvarchar](41) NULL,
	[Timezone] [int] NULL,
	[Plugins] [nvarchar](41) NULL,
	[FontS] [nvarchar](41) NULL,
	[FontF] [nvarchar](41) NULL,
	[IdRef] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Monitor] bigint NULL,
	[SystemTimeOffset] int NULL,
	[SystemF] varchar(50) NULL,
	[SystemS] varchar(50) NULL,
	[GPUCode] varchar(50) NULL
)

abc: 

truncate table #deviceProcessing

DELETE TOP (1000)
FROM #tmp_Device
OUTPUT deleted.* INTO #deviceProcessing

--select * from #deviceProcessing
IF @@ROWCOUNT=0
BEGIN
	print 'Done'
	return
END
INSERT INTO FPS_DeviceFingerprint_Archive.dbo.Device
(		[Increment]
      ,[Id]
      ,[Code]
      ,[Navigator]
      ,[UID]
      ,[Screen]
      ,[Timezone]
      ,[Plugins]
      ,[FontS]
      ,[FontF]
      ,[IdRef]
      ,[CreatedDate]
	  ,[Monitor]
	  ,[SystemTimeOffset]
	  ,[SystemF]
	  ,[SystemS]
	  ,[GPUCode])
SELECT [Increment]
      ,[Id]
      ,[Code]
      ,[Navigator]
      ,[UID]
      ,[Screen]
      ,[Timezone]
      ,[Plugins]
      ,[FontS]
      ,[FontF]
      ,[IdRef]
      ,[CreatedDate]
	  ,[Monitor]
	  ,[SystemTimeOffset]
	  ,[SystemF]
	  ,[SystemS]
	  ,[GPUCode]
FROM #deviceProcessing

INSERT FPS_DeviceFingerprint_Archive.dbo.DeviceDetail 
(		[Increment]
      ,[DeviceId]
      ,[DeviceCode]
      ,[Navigator]
      ,[Plugins]
      ,[OS]
      ,[Browser]
      ,[Engine]
      ,[Screen]
      ,[DeviceName]
      ,[IdRef]
	  ,[SystemF]
      ,[SystemS]
      ,[Monitor]
	  )
SELECT d.[Increment]
      ,d.[DeviceId]
      ,d.[DeviceCode]
      ,d.[Navigator]
      ,d.[Plugins]
      ,d.[OS]
      ,d.[Browser]
      ,d.[Engine]
      ,d.[Screen]
      ,d.[DeviceName]
      ,d.[IdRef]
	  ,d.[SystemF]
      ,d.[SystemS]
      ,d.[Monitor]
FROM DeviceDetail  d (nolock)
	JOIN (SELECT DISTINCT Code,iD FROM #deviceProcessing) t  ON t.Id=d.DeviceId and d.DeviceCode=t.Code

DELETE d 
from DeviceDetail  d with (UPDLOCK, ROWLOCK)
	JOIN #deviceProcessing t ON t.Id=d.DeviceId and d.DeviceCode=t.Code

DELETE Device WITH (UPDLOCK, ROWLOCK)
where Increment in (select Increment from #deviceProcessing)

goto abc

--drop table #tmp_Device
--drop table #tmp

/*

select count(1)
from DeviceDetail  d with (NOLOCK)
	JOIN #deviceProcessing t ON t.Id=d.DeviceId and d.DeviceCode=t.Code

select * from device (nolock)
where Increment in (select Increment from #deviceProcessing)

select *
from FPS_DeviceFingerprint_Archive.dbo.DeviceDetail  d with (NOLOCK)
	JOIN #deviceProcessing t ON t.Id=d.DeviceId and d.DeviceCode=t.Code

select * from FPS_DeviceFingerprint_Archive.dbo.device (nolock)
where Increment in (select Increment from #deviceProcessing)

select * from FPS_DeviceFingerprint_Archive.dbo.DeviceDetail  d with (NOLOCK)
where Increment=218123

select * from DeviceDetail  d with (NOLOCK)
where Increment=218123

select d.[Increment]
      ,d.[DeviceId]
      ,d.[DeviceCode]
      ,d.[Navigator]
      ,d.[Plugins]
      ,d.[OS]
      ,d.[Browser]
      ,d.[Engine]
      ,d.[Screen]
      ,d.[DeviceName]
      ,d.[IdRef]
from DeviceDetail  d (nolock)
	JOIN #deviceProcessing t ON t.Id=d.DeviceId and d.DeviceCode=t.Code
WHERE d.increment=218123
	JOIN FPS_DeviceFingerprint_Archive.dbo.DeviceDetail Dt ON t.Id=dT.DeviceId and dT.DeviceCode=t.Code

SELECT * FROM #deviceProcessing
where id='08D00484DE9AC65F3102'
and code='9e7a751f1baa2dcfbe141c5c2c9845b750d6dfa8'
*/
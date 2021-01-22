/*
	Created:
	Task: Get all job step on DB215 & Db215\SQL to compare
*/

-- run on DB215
SELECT
        N'SELECT '
        + '''' + REPLACE(j.name, '''', '''''') + ''''
        + ',' + CONVERT(VARCHAR(3), js.step_id)
        + ',' + '''' + REPLACE(js.step_name, '''', '''''') + ''''
        + ',' + '''' + ISNULL(REPLACE(js.command, '''', ''''''), '') + ''''
        + ' UNION ALL'
FROM msdb.dbo.sysjobs j
        INNER JOIN msdb.dbo.sysjobsteps js ON j.job_id = js.job_id
ORDER BY j.name, js.step_id

-- run on DB215\SQL
DECLARE @DB215_sqljob TABLE (job_name SYSNAME, step_id INT, step_name SYSNAME, command NVARCHAR(MAX))
--INSERT INTO @DB215_sqljob (job_name, step_id, step_name, command)
-- copy result from DB215

;WITH CTE_sqljob AS
(SELECT j.name as job_name, js.step_id, js.step_name, js.command
FROM msdb.dbo.sysjobs j
        INNER JOIN msdb.dbo.sysjobsteps js ON j.job_id = js.job_id)
SELECT ISNULL(s1.job_name, s2.job_name), ISNULL(s1.step_id, s2.step_id), ISNULL(s1.step_name, s2.step_name)
        ,CASE
                WHEN s1.job_name IS NULL THEN 'Not exists on DB215\SQL'
                WHEN s2.job_name IS NULL THEN 'Not exists on DB215'
                WHEN ISNULL(s2.command, N'') <> ISNULL(s1.command, N'') THEN 'Command is different'
                ELSE '' END
FROM CTE_sqljob s1
        FULL OUTER JOIN @DB215_sqljob s2 ON s1.job_name = s2.job_name AND s1.step_id = s2.step_id
ORDER BY 1,2
SELECT	[ServerName]		= @@SERVERNAME

		-- Priority --
	,	[BaseText]			= ISNULL('[' + DB_NAME(stx.dbid) + '] ' + OBJECT_NAME(stx.objectid, stx.dbid), stx.text)
	,	[SessionId]			= rqs.session_id
	,	[BlockingSession]	= rqs.blocking_session_id
	,	[WaitInfo]			= rqs.wait_type + ' [' + CAST(rqs.wait_time AS VARCHAR) + 'ms]'
	,	[CPUTime]			= rqs.cpu_time
	,	[ElapsedTime]		= rqs.total_elapsed_time
	,	[RunningText]		= SUBSTRING(LTRIM(stx.text), rqs.statement_start_offset / 2 + 1, CASE WHEN rqs.statement_end_offset <= 0 THEN LEN(stx.text) ELSE rqs.statement_end_offset / 2 END - rqs.statement_start_offset / 2 + 1)
	,	[RunningPlan]		= CAST(qrp.query_plan AS XML)
	,	[WaitResource]		= rqs.wait_resource
	,	[PercentDone]		= rqs.percent_complete

		-- Memory --
	,	[DOP]				= qmg.dop
	,	[GrantedMemoryKB]	= qmg.granted_memory_kb
	,	[MaxUsedMemoryKB]	= qmg.max_used_memory_kb
	,	[UsedMemoryKB]		= qmg.used_memory_kb
	
		-- Request --
	,	[RequestStart]		= rqs.start_time
	,	[RequestStatus]		= rqs.status
	,	[RequestCommand]	= rqs.command
	,	[SchedulerId]		= rqs.scheduler_id
	,	[Read]				= rqs.reads
	,	[LogicalRead]		= rqs.logical_reads
	,	[Write]				= rqs.writes

		-- Sql Text --
	,	[Database]			= DB_NAME(rqs.database_id)
	
		-- Sessions --
	,	[HostName]			= sss.host_name
	,	[Program]			= sss.program_name
	,	[LoginName]			= sss.login_name
	,	[SessionStatus]		= sss.status
		-- Scheduler --
	,	[CPUId]				= sch.cpu_id
	,	[CurrentTasks]		= sch.current_tasks_count
	,	[RunnableTasks]		= sch.runnable_tasks_count
	,	[PendingTasks]		= sch.work_queue_count
	,	[Workers]			= CAST(sch.active_workers_count AS VARCHAR) + '/' + CAST(sch.current_workers_count AS VARCHAR)
	,	[ClientIP]			= cnn.client_net_address
	,	[ClientPort]		= cnn.client_tcp_port
FROM		sys.dm_exec_requests AS rqs WITH (NOLOCK)
	OUTER APPLY	sys.dm_exec_sql_text(rqs.sql_handle) AS stx
	OUTER APPLY	sys.dm_exec_text_query_plan(rqs.plan_handle, rqs.statement_start_offset, rqs.statement_end_offset) AS qrp
	LEFT JOIN	sys.dm_exec_sessions AS sss WITH (NOLOCK)
			ON	rqs.session_id = sss.session_id
	LEFT JOIN	sys.dm_os_schedulers AS sch WITH (NOLOCK)
			ON	rqs.scheduler_id = sch.scheduler_id
	LEFT JOIN	sys.dm_exec_query_memory_grants AS qmg WITH (NOLOCK)
			ON	rqs.session_id = qmg.session_id
			AND	rqs.request_id = qmg.request_id
	LEFT JOIN	sys.dm_exec_connections AS cnn WITH (NOLOCK)
			ON	rqs.session_id = cnn.session_id
	WHERE	rqs.session_id <> @@SPID
		AND	(rqs.session_id > 50 OR stx.text IS NOT NULL OR rqs.blocking_session_id <> 0 OR EXISTS(SELECT 1 FROM sys.dm_exec_requests AS _rqs WITH (NOLOCK) WHERE rqs.session_id = _rqs.blocking_session_id))
		AND	rqs.command NOT IN ('WAITFOR')
ORDER BY BlockingSession DESC, rqs.total_elapsed_time DESC



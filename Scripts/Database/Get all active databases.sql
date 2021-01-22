/*
	Created:
	Task: Generate all active databases
*/

select *
from sys.databases
where is_read_only = 0
    and name not in ('master','msdb','tempdb','distribution','model')
	and state_desc = 'online'
order BY name